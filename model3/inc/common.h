#ifndef COMMON_H
#define COMMON_H

#include <stdfix.h>

// potrebno prekopirati sa pocetka stdfix_emu.h ili ukljuciti ceo stdfix_emu.h!
#if defined(__CCC)

#include <stdfix.h>

#define FRACT_NUM(x) (x##r)
#define LONG_FRACT_NUM(x) (x##lr)
#define ACCUM_NUM(x) (x##lk)

#define FRACT_NUM_HEX(x) (x##r)

#define FRACT_TO_INT_BIT_CONV(x) (bitsr(x))
#define INT_TO_FRACT_BIT_CONV(x) (rbits(x))

#define long_accum long accum
#define long_fract long fract


#endif

/* Basic constants */
/* TO DO: Move defined constants here */
/////////////////////////////////////////////////////////////////////////////////
// Constant definitions
/////////////////////////////////////////////////////////////////////////////////

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

#define PROCESSING_ASM //comment to disable asm
/////////////////////////////////////////////////////////////////////////////////

// DSP type definitions
typedef short DSPshort;					// DSP integer
typedef unsigned short DSPushort;		// DSP unsigned integer
typedef int DSPint;						// native integer
typedef fract DSPfract;					// DSP fixed-point fractional
typedef long_accum DSPaccum;			// DSP accumulator

#endif
