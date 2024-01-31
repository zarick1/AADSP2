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

#define BLOCK_SIZE 16
#define MAX_NUM_CHANNEL 8

// Index of channels
#define L_CHANNEL		0		// Front left
#define R_CHANNEL		1		// Front right
#define C_CHANNEL		2		// Front center
#define LFE_CHANNEL		3		// Subwoofer
#define LS_CHANNEL		4		// Back left
#define RS_CHANNEL		5		// Back right

enum OUTPUT_MODES
{
	OM_2_2_0 = 0,			// L, R, LS, RS
	OM_2_2_1 = 1,			// L, R, LS, RS, LFE
	OM_3_2_0 = 2,			// L, R, C, LS, RS
	OM_3_2_1 = 3			// L, R, C, LS, RS, LFE
};

static int enabled = 1;

static double limiterThreshold = 0.999;

const double stage_two_gain = pow(10.0, -2.0 / 20.0);	// -2dB for C and LFE channel

static double variableGain = pow(10.0, -4.0 / 20.0);   // default -4db 

static int mode = OM_2_2_0;

static int num_of_channels = 4;

double input_L_with_stage_two_gain = 0;
double input_R_with_stage_two_gain = 0;
//double inverted_LS = 0;
//double substracted_LFE = 0;

static double HPF5kHz[6] = { 0.6612655734076553,
					 -1.3225311468153107,
					 0.6612655734076553,
					 1.0,
					 -1.1701369489124014,
					 0.47492534471822007 };

static double LPF800Hz[6] = { 0.00299370677189366190,
						0.00598741354378732380,
						0.00299370677189366190,
						1.00000000000000000000,
						-1.83911679732520340000,
						0.85112834124597214000 };


static double x_historyLs[] = { 0, 0 };	//Ls 
static double y_historyLs[] = { 0, 0 };

static double x_historyLfe[] = { 0, 0 };	//Lfe 
static double y_historyLfe[] = { 0, 0 };

double saturation(double in)
{
	if (in > limiterThreshold)
	{
		return fmin(in, limiterThreshold);
	}
	else if (in < -limiterThreshold)
	{
		return fmax(in, -limiterThreshold);
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

double second_order_IIR(double input, double* coefficients, double* x_history, double* y_history)
{
	double output = 0;

	output += *coefficients * input;					/* A0 * x(n)     */
	output += *(coefficients + 1) * *x_history;			/* A1 * x(n-1) */
	output += *(coefficients + 2) * *(x_history + 1);	/* A2 * x(n-2)   */
	output -= *(coefficients + 4) * *y_history;			/* B1 * y(n-1) */
	output -= *(coefficients + 5) * *(y_history + 1);	/* B2 * y(n-2)   */


	*(y_history + 1) = *y_history;				 /* y(n-2) = y(n-1) */
	*y_history = output;						/* y(n-1) = y(n)   */
	*(x_history + 1) = *x_history;				/* x(n-2) = x(n-1) */
	*x_history = input;							/* x(n-1) = x(n)   */

	return output;
}



void processing(double input[][BLOCK_SIZE], double output[][BLOCK_SIZE])
{
	// pointers - get adress of the first sample in the current channel
	// input pointers
	double* p_L_channel_in = *(input + L_CHANNEL);
	double* p_R_channel_in = *(input + R_CHANNEL);

	// output pointers
	double* p_L_channel_out = *(output + L_CHANNEL);
	double* p_R_channel_out = *(output + R_CHANNEL);
	double* p_LS_channel_out = *(output + LS_CHANNEL);
	double* p_RS_channel_out = *(output + RS_CHANNEL);
	double* p_C_channel_out = *(output + C_CHANNEL);
	double* p_LFE_channel_out = *(output + LFE_CHANNEL);

	// calculate L and R after gain and apply it to all channels
	for (int i = 0; i < BLOCK_SIZE; i++)
	{

		/*double input_L_with_gain = input[L_CHANNEL][i] * variableGain;
		double input_R_with_gain = input[R_CHANNEL][i] * variableGain;
		double input_L_with_stage_two_gain = input_L_with_gain * stage_two_gain;
		double input_R_with_stage_two_gain = input_R_with_gain * stage_two_gain;*/

		// L, R, LS, RS are always included
		//output[L_CHANNEL][i] = input_L_with_gain;
		*p_L_channel_out = *p_L_channel_in * variableGain;	// L channel

		//output[LS_CHANNEL][i] = -input_L_with_gain;		// LS is inverted
		*p_LS_channel_out = -*p_L_channel_out;
		*p_LS_channel_out = second_order_IIR(*p_LS_channel_out, HPF5kHz, x_historyLs, y_historyLs);

		//output[R_CHANNEL][i] = input_R_with_gain;
		*p_R_channel_out = *p_R_channel_in * variableGain;	// R channel

		//output[RS_CHANNEL][i] = -input_R_with_gain;		// RS is inverted
		*p_RS_channel_out = -*p_R_channel_out;

		input_L_with_stage_two_gain = *p_L_channel_out * stage_two_gain;
		input_R_with_stage_two_gain = *p_R_channel_out * stage_two_gain;


		// If C is included
		if (mode == OM_3_2_0 || mode == OM_3_2_1)
		{
			// Central channel is L+R
			//output[C_CHANNEL][i] = input_L_with_stage_two_gain + input_R_with_stage_two_gain;
			*p_C_channel_out = saturation(input_L_with_stage_two_gain + input_R_with_stage_two_gain);
		}

		// If LFE is included
		if (mode == OM_2_2_1 || mode == OM_3_2_1)
		{
			// LFE channel is L-R
			//double inverted_R = -input_R_with_stage_two_gain;
			*p_LFE_channel_out = input_L_with_stage_two_gain - input_R_with_stage_two_gain;
			*p_LFE_channel_out = saturation(*p_LFE_channel_out);
			*p_LFE_channel_out = second_order_IIR(*p_LFE_channel_out, LPF800Hz, x_historyLfe, y_historyLfe);
			//*p_LFE_channel_out = saturation(*p_LFE_channel_out);

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

/*double calculateMaxMidLevel(double leftMaxLevel, double rightMaxLevel, double leftGain, double rightGain) {
	double midLevel = (leftMaxLevel + leftGain + rightMaxLevel + rightGain) / 2;
	return midLevel;
}*/

double sampleBuffer[MAX_NUM_CHANNEL][BLOCK_SIZE];


int main(int argc, char* argv[])
{

	//printf("Expected db for center channel: %f dB\n", calculateMaxMidLevel(-46, -46.3, -6, -6));

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
	double gain_dB;
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

		variableGain = pow(10.0, gain_dB / 20.0);
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
		}
	}

	//-------------------------------------------------

	printf("input gain %f\n", variableGain);
	printf("stage two gain %f\n", stage_two_gain);
	printf("input + stage_two_gain %f\n", variableGain + stage_two_gain);
	printf("mode %d", mode);

	// Get gain and output mode from command line arguments
	//-------------------------------------------------
	strcpy(WavInputName, argv[1]);
	wav_in = OpenWavFileForRead(WavInputName, "rb");
	strcpy(WavOutputName, argv[2]);
	wav_out = OpenWavFileForRead(WavOutputName, "wb");
	//-------------------------------------------------


	// Init channel buffers
	for (int i = 0; i < MAX_NUM_CHANNEL; i++)
		memset(&sampleBuffer[i], 0, BLOCK_SIZE);

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

	int oneChannelSubChunk2Size = inputWAVhdr.data.SubChunk2Size / inputWAVhdr.fmt.NumChannels;
	int oneChannelByteRate = inputWAVhdr.fmt.ByteRate / inputWAVhdr.fmt.NumChannels;
	int oneChannelBlockAlign = inputWAVhdr.fmt.BlockAlign / inputWAVhdr.fmt.NumChannels;

	outputWAVhdr.data.SubChunk2Size = oneChannelSubChunk2Size * outputWAVhdr.fmt.NumChannels;
	outputWAVhdr.fmt.ByteRate = oneChannelByteRate * outputWAVhdr.fmt.NumChannels;
	outputWAVhdr.fmt.BlockAlign = oneChannelBlockAlign * outputWAVhdr.fmt.NumChannels;


	// Write output WAV header to file
	//-------------------------------------------------
	WriteWavHeader(wav_out, outputWAVhdr);


	// Processing loop
	//-------------------------------------------------	
	{
		int sample;
		int BytesPerSample = inputWAVhdr.fmt.BitsPerSample / 8;
		const double SAMPLE_SCALE = -(double)(1 << 31);		//2^31
		int iNumSamples = inputWAVhdr.data.SubChunk2Size / (inputWAVhdr.fmt.NumChannels * inputWAVhdr.fmt.BitsPerSample / 8);

		// exact file length should be handled correctly...
		for (int i = 0; i < iNumSamples / BLOCK_SIZE; i++)
		{
			for (int j = 0; j < BLOCK_SIZE; j++)
			{
				for (int k = 0; k < inputWAVhdr.fmt.NumChannels; k++)
				{
					sample = 0; //debug
					fread(&sample, BytesPerSample, 1, wav_in);
					sample = sample << (32 - inputWAVhdr.fmt.BitsPerSample); // force signextend
					sampleBuffer[k][j] = sample / SAMPLE_SCALE;				 // scale sample to 1.0/-1.0 range		
				}
			}


			if (enabled)
				processing(sampleBuffer, sampleBuffer);

			for (int j = 0; j < BLOCK_SIZE; j++)
			{
				for (int k = 0; k < outputWAVhdr.fmt.NumChannels; k++)
				{
					int channel = 0;
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
					sample = sampleBuffer[channel][j] * SAMPLE_SCALE;	// crude, non-rounding 			
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