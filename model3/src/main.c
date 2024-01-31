#include <stdio.h>
#include <dsplib\wavefile.h>
#include <stdfix.h>
#include <string.h>
#include "common.h"
#include <dsplib\timers.h>	// for profiling

__memY DSPfract sampleBuffer[MAX_NUM_CHANNEL][BLOCK_SIZE];

// Enable
DSPint enabled = 1;

DSPfract limiterThreshold = FRACT_NUM(0.999);

DSPfract stage_two_gain = FRACT_NUM(0.794328);	// -2dB for C and LFE channel

DSPfract variableGain = FRACT_NUM(0.630957);   // default -4db
//DSPfract variableGain = FRACT_NUM(1.000000);

DSPint mode = OM_3_2_1;

//static DSPint num_of_channels = 6;

DSPfract input_L_with_stage_two_gain = FRACT_NUM(0.00);
DSPfract input_R_with_stage_two_gain = FRACT_NUM(0.00);

DSPfract HPF5kHz[6] = { FRACT_NUM(0.33063278670382765),
		 	 	 	 	 	   FRACT_NUM(-0.66126557340765530),
		 	 	 	 	 	   FRACT_NUM(0.33063278670382765),
		 	 	 	 	 	   FRACT_NUM(0.5),
		 	 	 	 	 	   FRACT_NUM(-0.58506847445620070),
		 	 	 	 	 	   FRACT_NUM(0.23746267235911003) };

DSPfract LPF800Hz[6] = { FRACT_NUM(0.00149685338594683095),
								FRACT_NUM(0.00299370677189366190),
								FRACT_NUM(0.00149685338594683095),
								FRACT_NUM(0.5),
								FRACT_NUM(-0.9195583986626017000),
								FRACT_NUM(0.42556417062298607000) };


DSPfract x_historyLs[] = { FRACT_NUM(0.00), FRACT_NUM(0.00) };	//Ls
DSPfract y_historyLs[] = { FRACT_NUM(0.00), FRACT_NUM(0.00) };

DSPfract x_historyLfe[] = { FRACT_NUM(0.00), FRACT_NUM(0.00) };	//Lfe
DSPfract y_historyLfe[] = { FRACT_NUM(0.00), FRACT_NUM(0.00) };

DSPfract saturation(DSPaccum in)
{
	DSPaccum in_value = in;

	if (in_value > (DSPaccum)limiterThreshold)
	{
		return limiterThreshold;
	}
	else if (in_value < (DSPaccum)-limiterThreshold)
	{
		return -limiterThreshold;
	}
	return in;
}

#ifdef PROCESSING_ASM
extern DSPaccum second_order_IIR(DSPfract input, DSPfract* coefficients, DSPfract* x_history, DSPfract* y_history);
#else
DSPaccum second_order_IIR(DSPfract input, DSPfract* coefficients, DSPfract* x_history, DSPfract* y_history)
{
	DSPaccum output = FRACT_NUM(0.0);

	output += (*coefficients * input);							// A0 * x(n)
	output += (*(coefficients + 1) * *x_history);				// A1 * x(n-1)
	output += (*(coefficients + 2) * *(x_history + 1));			// A2 * x(n-2)
	output -= (*(coefficients + 4) * *y_history);				// B1 * y(n-1)
	output -= (*(coefficients + 5) * *(y_history + 1)) ;		// B2 * y(n-2)

	output = output << 1;

	*(y_history + 1) = *y_history;				 // y(n-2) = y(n-1)
	*y_history = output;						 // y(n-1) = y(n)
	*(x_history + 1) = *x_history;				 // x(n-2) = x(n-1)
	*x_history = input;							 // x(n-1) = x(n)

	return output;
}
#endif

#ifdef PROCESSING_ASM
extern void processing(__memY DSPfract input[][BLOCK_SIZE],__memY DSPfract output[][BLOCK_SIZE]);
#else
void processing(__memY DSPfract input[][BLOCK_SIZE],__memY DSPfract output[][BLOCK_SIZE])
{
	DSPint i;
	DSPaccum rescaled;
	DSPfract scaledL;
	DSPfract scaledR;
	// pointers - get adress of the first sample in the current channel
	// input pointers
	__memY DSPfract* p_L_channel_in = *(input + L_CHANNEL);
	__memY DSPfract* p_R_channel_in = *(input + R_CHANNEL);

	// output pointers
	__memY DSPfract* p_L_channel_out = *(output + L_CHANNEL);
	__memY DSPfract* p_R_channel_out = *(output + R_CHANNEL);
	__memY DSPfract* p_LS_channel_out = *(output + LS_CHANNEL);
	__memY DSPfract* p_RS_channel_out = *(output + RS_CHANNEL);
	__memY DSPfract* p_C_channel_out = *(output + C_CHANNEL);
	__memY DSPfract* p_LFE_channel_out = *(output + LFE_CHANNEL);

	// calculate L and R after gain and apply it to all channels
	for (i = 0; i < BLOCK_SIZE; i++)
	{
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
			rescaled = scaledL + scaledR;
			rescaled = rescaled << 2;
			*p_C_channel_out = saturation(rescaled);
		}

		// If LFE is included
		if (mode == OM_2_2_1 || mode == OM_3_2_1)
		{
			// LFE channel is L-R
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
#endif

int main(int argc, char *argv[])
 {
    WAVREAD_HANDLE *wav_in;
    WAVWRITE_HANDLE *wav_out;

	char WavInputName[256];
	char WavOutputName[256];

    DSPint inChannels;
    DSPint outChannels;
    DSPint bitsPerSample;
    DSPint sampleRate;
    DSPint iNumSamples;
    DSPint i;
    DSPint j;
    DSPint channel;

    //unsigned long long count1, count2, spent_cycles;	// for profiling

	// Init channel buffers
	for(i=0; i<MAX_NUM_CHANNEL; i++)
		for(j=0; j<BLOCK_SIZE; j++)
			sampleBuffer[i][j] = FRACT_NUM(0.0);

	// Open input wav file
	//-------------------------------------------------
	strcpy(WavInputName,argv[0]);
	wav_in = cl_wavread_open(WavInputName);
	 if(wav_in == NULL)
    {
        printf("Error: Could not open wavefile.\n");
        return -1;
    }
	//-------------------------------------------------

	// Read input wav header
	//-------------------------------------------------
	inChannels = cl_wavread_getnchannels(wav_in);
    bitsPerSample = cl_wavread_bits_per_sample(wav_in);
    sampleRate = cl_wavread_frame_rate(wav_in);
    iNumSamples =  cl_wavread_number_of_frames(wav_in);
	//-------------------------------------------------

    switch(mode){
    	case OM_2_2_0:
    		outChannels = 4;
    		break;
    	case OM_2_2_1:
    		outChannels = 5;
    		break;
    	case OM_3_2_0:
    		outChannels = 5;
    		break;
    	case OM_3_2_1:
    		outChannels = 6;
    		break;
    	default:
    		outChannels = 2;
    		break;
    	}

	// Open output wav file
	//-------------------------------------------------
	strcpy(WavOutputName,argv[1]);
	//if(enabled)
	//	outChannels = num_of_channels;
	//else
	//	outChannels = inChannels;
	wav_out = cl_wavwrite_open(WavOutputName, bitsPerSample, outChannels, sampleRate);
	if(!wav_out)
    {
        printf("Error: Could not open wavefile.\n");
        return -1;
    }
	//-------------------------------------------------

	// Processing loop
	//-------------------------------------------------
    {
		int i;
		int j;
		int k;
		int sample;

		// exact file length should be handled correctly...
		for(i=0; i<iNumSamples/BLOCK_SIZE; i++)
		{
			for(j=0; j<BLOCK_SIZE; j++)
			{
				for(k=0; k<inChannels; k++)
				{
					sample = cl_wavread_recvsample(wav_in);
        			sampleBuffer[k][j] = rbits(sample);
				}
			}

			// pozvati processing funkciju ovde
			//count1 = cl_get_cycle_count();

			if (enabled)
				processing(sampleBuffer, sampleBuffer);

			//count2 = cl_get_cycle_count();
			//spent_cycles = count2 - count1;
			//printf("%llu\n", spent_cycles);
			// ----------------------------------

			for(j=0; j<BLOCK_SIZE; j++)
			{
				for(k=0; k<outChannels; k++)
				{
					channel = 0;
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
					sample = bitsr(sampleBuffer[channel][j]);
					cl_wavwrite_sendsample(wav_out, sample);
				}
			}
		}
	}

	// Close files
	//-------------------------------------------------
    cl_wavread_close(wav_in);
    cl_wavwrite_close(wav_out);
	//-------------------------------------------------

    return 0;
 }
