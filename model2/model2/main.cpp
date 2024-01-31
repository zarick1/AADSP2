//////////////////////////////////////////////////////////////////////////////////
// @Author	Krsto Zarić															//
// @Date	20.01.2024.															//
//																				//
// @param - argv[0] - Input file name											//
//        - argv[1] - Output file name											//
//		  - argv[2] - gain: 0 to -inf dB, defualt -4							//
//		  - argv[3] - output mode: default 2_2_0								//
// @return - nothing															//
//																				//
// E-mail:	krstozaric01@gmail.com												//
//																				//
//////////////////////////////////////////////////////////////////////////////////
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "WAVheader.h"
#include <math.h>
#include "common.h"

// Enable
static DSPint enabled = 1;

static DSPfract limiterThreshold = FRACT_NUM(0.999);

const DSPfract stage_two_gain = FRACT_NUM(pow(10.0, -2.0 / 20.0));	// -2dB for C and LFE channel

static DSPfract variableGain = FRACT_NUM(pow(10.0, -4.0 / 20.0));   // scaled, default -4db 

static DSPint mode = OM_2_2_0;

static DSPint num_of_channels = 4;

DSPfract input_L_with_stage_two_gain = FRACT_NUM(0.00);
DSPfract input_R_with_stage_two_gain = FRACT_NUM(0.00);

static DSPfract HPF5kHz[6] = { FRACT_NUM(0.33063278670382765),
					 FRACT_NUM(-0.66126557340765530),
					 FRACT_NUM(0.33063278670382765),
					 FRACT_NUM(0.5),
					 FRACT_NUM(-0.58506847445620070),
					 FRACT_NUM(0.23746267235911003) };

static DSPfract LPF800Hz[6] = { FRACT_NUM(0.00149685338594683095),
						FRACT_NUM(0.00299370677189366190),
						FRACT_NUM(0.00149685338594683095),
						FRACT_NUM(0.5),
						FRACT_NUM(-0.9195583986626017000),
						FRACT_NUM(0.42556417062298607000) };


static DSPfract x_historyLs[] = { FRACT_NUM(0.00), FRACT_NUM(0.00) };	//Ls 
static DSPfract y_historyLs[] = { FRACT_NUM(0.00), FRACT_NUM(0.00) };

static DSPfract x_historyLfe[] = { FRACT_NUM(0.00), FRACT_NUM(0.00) };	//Lfe 
static DSPfract y_historyLfe[] = { FRACT_NUM(0.00), FRACT_NUM(0.00) };

DSPfract saturation(DSPaccum in)
{
	DSPaccum inValue = in;

	if (inValue > (DSPaccum)limiterThreshold)
	{
		return limiterThreshold;
	}
	else if (inValue < (DSPaccum)-limiterThreshold)
	{
		return -limiterThreshold;
	}
	return in;
}

/**************************************
 * IIR filtar drugog reda
 *
 * input - ulazni odbirak
 * coefficients - koeficijenti [a0 a1 a2 b0 b2 b2]
 * z_x - memorija za ulazne odbirke (niz duzine 2)
 * z_y - memorija za izlazne odbirke (niz duzine 2)
 *
 * povratna vrednost - izlazni odbirak
 *
 *************************************/

DSPaccum second_order_IIR(DSPfract input, DSPfract* coefficients, DSPfract* x_history, DSPfract* y_history)
{
	DSPaccum output = FRACT_NUM(0.00);
	output += (*coefficients * input);							/* A0 * x(n)     */
	output += (*(coefficients + 1) * *x_history);				/* A1 * x(n-1) */
	output += (*(coefficients + 2) * *(x_history + 1));			/* A2 * x(n-2)   */
	output -= (*(coefficients + 4) * *y_history);				/* B1 * y(n-1) */
	output -= (*(coefficients + 5) * *(y_history + 1)) ;		/* B2 * y(n-2)   */

	output = output << 1;

	*(y_history + 1) = *y_history;				 /* y(n-2) = y(n-1) */
	*y_history = output;						/* y(n-1) = y(n)   */
	*(x_history + 1) = *x_history;				/* x(n-2) = x(n-1) */
	*x_history = input;							/* x(n-1) = x(n)   */

	return output;
}



void processing(DSPfract input[][BLOCK_SIZE], DSPfract output[][BLOCK_SIZE])
{
	// pointers - get adress of the first sample in the current channel
	// input pointers
	DSPfract* p_L_channel_in = *(input + L_CHANNEL);
	DSPfract* p_R_channel_in = *(input + R_CHANNEL);

	// output pointers
	DSPfract* p_L_channel_out = *(output + L_CHANNEL);
	DSPfract* p_R_channel_out = *(output + R_CHANNEL);
	DSPfract* p_LS_channel_out = *(output + LS_CHANNEL);
	DSPfract* p_RS_channel_out = *(output + RS_CHANNEL);
	DSPfract* p_C_channel_out = *(output + C_CHANNEL);
	DSPfract* p_LFE_channel_out = *(output + LFE_CHANNEL);

	// calculate L and R after gain and apply it to all channels
	for (DSPint i = 0; i < BLOCK_SIZE; i++)
	{
		DSPaccum rescaled;
		DSPfract scaledL;
		DSPfract scaledR;

		// L, R, LS, RS are always included
		//output[L_CHANNEL][i] = input_L_with_gain;
		*p_L_channel_out = *p_L_channel_in * variableGain;	// L channel

		//output[LS_CHANNEL][i] = -input_L_with_gain;		// LS is inverted
		*p_LS_channel_out = -*p_L_channel_out;
		rescaled = second_order_IIR((DSPaccum)*p_LS_channel_out, HPF5kHz, x_historyLs, y_historyLs);
		*p_LS_channel_out = rescaled;

		//output[R_CHANNEL][i] = input_R_with_gain;
		*p_R_channel_out = *p_R_channel_in * variableGain;	// R channel

		//output[RS_CHANNEL][i] = -input_R_with_gain;		// RS is inverted
		*p_RS_channel_out = -*p_R_channel_out;

		input_L_with_stage_two_gain = *p_L_channel_out;  //*stage_two_gain;
		scaledL = input_L_with_stage_two_gain >> 2;
		scaledL = scaledL * stage_two_gain;

		input_R_with_stage_two_gain = *p_R_channel_out; //*stage_two_gain;
		scaledR = input_R_with_stage_two_gain >> 2;
		scaledR = scaledR * stage_two_gain;

		// If C is included
		if (mode == OM_3_2_0 || mode == OM_3_2_1)
		{
			// Central channel is L+R
			//output[C_CHANNEL][i] = input_L_with_stage_two_gain + input_R_with_stage_two_gain;
			rescaled = scaledL + scaledR;
			rescaled = rescaled << 2;
			*p_C_channel_out = saturation(rescaled);
		}

		// If LFE is included
		if (mode == OM_2_2_1 || mode == OM_3_2_1)
		{
			// LFE channel is L-R
			//double inverted_R = -input_R_with_stage_two_gain;
			rescaled = scaledL - scaledR;
			rescaled = rescaled << 2;
			rescaled = saturation(rescaled);
			rescaled = second_order_IIR(rescaled, LPF800Hz, x_historyLfe, y_historyLfe);
			*p_LFE_channel_out = rescaled;

		}

		p_L_channel_in++;
		p_R_channel_in++;
		p_L_channel_out++;
		p_R_channel_out++;
		p_C_channel_out++;
		p_LFE_channel_out++;
		p_LS_channel_out++;
		p_RS_channel_out++;
	}
}

DSPfract sampleBuffer[MAX_NUM_CHANNEL][BLOCK_SIZE];


DSPint main(DSPint argc, char* argv[])
{
	// Check if right arguments were passed
	if (argc < 3 || argc > 5)
	{
		printf("Bad command line arguments !!!!!!\n");
		printf("Comman line example: \n");
		printf(" path/to/input/file/audio.wav path/to/output/file/audio_out.wav -4(default) 0(default)\n");
		printf("	Gain: 0 to -inf\n\n");
		printf("	Output modes: 0 for 2_2_0\n");
		printf("                      1 for 2_2_1\n");
		printf("                      2 for 3_2_0\n");
		printf("                      3 for 3_2_1\n");
	}

	// Input/output wav files
	//-------------------------------------------------
	FILE* wav_in = NULL;
	FILE* wav_out = NULL;
	char WavInputName[256];
	char WavOutputName[256];
	WAV_HEADER inputWAVhdr, outputWAVhdr;
	//-------------------------------------------------

	// Parameters
	//-------------------------------------------------
	DSPint gain_dB;
	//double gain = pow(10.0, variableGain / 20.0);			// Convert dB to floating point
	//int mode = OM_2_2_0;
	//int num_of_channels = 4;
	//-------------------------------------------------

	// Getting values from command line
	//-------------------------------------------------
	if (argc >= 4)
	{
		gain_dB = strtod(argv[3], NULL);

		if (gain_dB > 0)
		{
			gain_dB = 0;
		}
		else
		{
			gain_dB = gain_dB;
		}

		//printf("gain before %f\n", gain_dB);
		variableGain = pow(10.0, gain_dB / 20.0); //scaled
	}

	if (argc >= 5)
	{
		mode = atoi(argv[4]);
		if (mode < 0 || mode > 3) mode = 0;
		switch (mode)
		{
		case OM_2_2_0:
			num_of_channels = 4;
			break;
		case OM_2_2_1:
			num_of_channels = 5;
			break;
		case OM_3_2_0:
			num_of_channels = 5;
			break;
		case OM_3_2_1:
			num_of_channels = 6;
			break;
		default:
			break;
		}
	}

	if (argc == 6)
	{
		if (strcmp(argv[5], "0") == 0)
			enabled = 0;
		else if (strcmp(argv[5], "1") != 0)
		{
			printf("Wrong Enable control!\n");
			return -1;
		}
	}
	//-------------------------------------------------

	printf("input gain %f\n", variableGain);
	printf("stage two gain %f\n", stage_two_gain);
	printf("input + stage_two_gain %f\n", variableGain + stage_two_gain);
	printf("mode %d\n", mode);

	// Get gain and output mode from command line arguments
	//-------------------------------------------------
	strcpy(WavInputName, argv[1]);
	wav_in = OpenWavFileForRead(WavInputName, "rb");
	strcpy(WavOutputName, argv[2]);
	wav_out = OpenWavFileForRead(WavOutputName, "wb");
	//-------------------------------------------------


	// Init channel buffers
	for (DSPint i = 0; i < MAX_NUM_CHANNEL; i++)
		for (DSPint j = 0; j < BLOCK_SIZE; j++)
			sampleBuffer[i][j] = FRACT_NUM(0.0);

	// Open input and output wav files
	//-------------------------------------------------
	strcpy(WavInputName, argv[1]);
	wav_in = OpenWavFileForRead(WavInputName, "rb");
	strcpy(WavOutputName, argv[2]);
	wav_out = OpenWavFileForRead(WavOutputName, "wb");
	//-------------------------------------------------

	// Read input wav header
	//-------------------------------------------------
	ReadWavHeader(wav_in, inputWAVhdr);
	//-------------------------------------------------

	// Set up output WAV header
	//-------------------------------------------------	
	outputWAVhdr = inputWAVhdr;
	if (enabled)
		outputWAVhdr.fmt.NumChannels = num_of_channels; // inputWAVhdr.fmt.NumChannels; // change number of channels
	else
		outputWAVhdr.fmt.NumChannels = 2;

	DSPint oneChannelSubChunk2Size = inputWAVhdr.data.SubChunk2Size / inputWAVhdr.fmt.NumChannels;
	DSPint oneChannelByteRate = inputWAVhdr.fmt.ByteRate / inputWAVhdr.fmt.NumChannels;
	DSPint oneChannelBlockAlign = inputWAVhdr.fmt.BlockAlign / inputWAVhdr.fmt.NumChannels;

	outputWAVhdr.data.SubChunk2Size = oneChannelSubChunk2Size * outputWAVhdr.fmt.NumChannels;
	outputWAVhdr.fmt.ByteRate = oneChannelByteRate * outputWAVhdr.fmt.NumChannels;
	outputWAVhdr.fmt.BlockAlign = oneChannelBlockAlign * outputWAVhdr.fmt.NumChannels;


	// Write output WAV header to file
	//-------------------------------------------------
	WriteWavHeader(wav_out, outputWAVhdr);


	// Processing loop
	//-------------------------------------------------	
	{
		DSPint sample;
		DSPint BytesPerSample = inputWAVhdr.fmt.BitsPerSample / 8;
		printf("BytesPerSample %d\n", BytesPerSample);
		const double SAMPLE_SCALE = -(double)(1 << 31);		//2^31
		DSPint iNumSamples = inputWAVhdr.data.SubChunk2Size / (inputWAVhdr.fmt.NumChannels * inputWAVhdr.fmt.BitsPerSample / 8);
		printf("iNumSamples %d\n", iNumSamples / BLOCK_SIZE);

		// exact file length should be handled correctly...
		for (DSPint i = 0; i < iNumSamples / BLOCK_SIZE; i++)
		{
			for (DSPint j = 0; j < BLOCK_SIZE; j++)
			{
				for (DSPint k = 0; k < inputWAVhdr.fmt.NumChannels; k++)
				{
					sample = 0; //debug
					fread(&sample, BytesPerSample, 1, wav_in);
					sample = sample << (32 - inputWAVhdr.fmt.BitsPerSample); // force signextend
					sampleBuffer[k][j] = sample / SAMPLE_SCALE;				 // scale sample to 1.0/-1.0 range		
				}
			}


			if (enabled)
				processing(sampleBuffer, sampleBuffer);

			for (DSPint j = 0; j < BLOCK_SIZE; j++)
			{
				for (DSPint k = 0; k < outputWAVhdr.fmt.NumChannels; k++)
				{
					DSPint channel = 0;
					switch (mode)
					{
					case OM_2_2_0:
						if (k == 0) channel = L_CHANNEL;
						if (k == 1) channel = R_CHANNEL;
						if (k == 2) channel = LS_CHANNEL;
						if (k == 3) channel = RS_CHANNEL;
						break;
					case OM_2_2_1:
						if (k == 0) channel = L_CHANNEL;
						if (k == 1) channel = R_CHANNEL;
						if (k == 2) channel = LFE_CHANNEL;
						if (k == 3) channel = LS_CHANNEL;
						if (k == 4) channel = RS_CHANNEL;
						break;
					case OM_3_2_0:
						if (k == 0) channel = L_CHANNEL;
						if (k == 1) channel = R_CHANNEL;
						if (k == 2) channel = C_CHANNEL;
						if (k == 3) channel = LS_CHANNEL;
						if (k == 4) channel = RS_CHANNEL;
						break;
					case OM_3_2_1:
						if (k == 0) channel = L_CHANNEL;
						if (k == 1) channel = R_CHANNEL;
						if (k == 2) channel = C_CHANNEL;
						if (k == 3) channel = LFE_CHANNEL;
						if (k == 4) channel = LS_CHANNEL;
						if (k == 5) channel = RS_CHANNEL;
						break;
					default:
						break;
					}
					sample = sampleBuffer[channel][j].toLong();	// crude, non-rounding 			
					sample = sample >> (32 - inputWAVhdr.fmt.BitsPerSample);
					fwrite(&sample, outputWAVhdr.fmt.BitsPerSample / 8, 1, wav_out);
				}
			}
		}
	}

	// Close files
	//-------------------------------------------------	
	fclose(wav_in);
	fclose(wav_out);
	//-------------------------------------------------	

	return 0;
}