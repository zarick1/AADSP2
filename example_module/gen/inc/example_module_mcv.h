/*
 * This file is automatically generated by CLIDE
 *
 * MCV (Module Control Vector)
 */
	.include "dsplib/meter_asm.h" 
	.include "dsplib/response_asm.h"

isDefined	 .equ 	 1

MCV_T	.struct
enable .dw 0	 # bool	non-zero to enable this function
G1 .dw 0	 #fract(1.31)
G2 .dw 0	 #fract(1.31)
	.endstruct


STRUCTURE_INITIALIZATION_STRNG .equ "0x1, 0x00000000, 0x00000000"