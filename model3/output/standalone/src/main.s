	.public _HPF5kHz
	.public _LPF800Hz
	.extern ___TIMER0_COUNT
	.extern ___TIMER1_COUNT
	.extern ___TIMER1_ENABLE
	.public _enabled
	.public _input_L_with_stage_two_gain
	.public _input_R_with_stage_two_gain
	.public _limiterThreshold
	.public _mode
	.public _sampleBuffer
	.public _stage_two_gain
	.public _variableGain
	.public _x_historyLfe
	.public _x_historyLs
	.public _y_historyLfe
	.public _y_historyLs
	.extern _cl_wavread_bits_per_sample
	.extern _cl_wavread_close
	.extern _cl_wavread_frame_rate
	.extern _cl_wavread_getnchannels
	.extern _cl_wavread_number_of_frames
	.extern _cl_wavread_open
	.extern _cl_wavread_recvsample
	.extern _cl_wavwrite_close
	.extern _cl_wavwrite_open
	.extern _cl_wavwrite_sendsample
	.public _main
	.extern _printf
	.extern _processing
	.public _saturation
	.extern _strcpy
	.extern __div
	.xdata_ovly
_HPF5kHz
	.dw  (0x2a522cd7)
	.dw  (0xab5ba652)
	.dw  (0x2a522cd7)
	.dw  (0x40000000)
	.dw  (0xb51c79ea)
	.dw  (0x1e652d46)
	.xdata_ovly
_LPF800Hz
	.dw  (0x310c84)
	.dw  (0x621908)
	.dw  (0x310c84)
	.dw  (0x40000000)
	.dw  (0x8a4be90f)
	.dw  (0x3678e302)
	.xdata_ovly
_enabled
	.dw  (0x1)
	.xdata_ovly
_input_L_with_stage_two_gain
	.dw  (0x0)
	.xdata_ovly
_input_R_with_stage_two_gain
	.dw  (0x0)
	.xdata_ovly
_limiterThreshold
	.dw  (0x7fdf3b64)
	.xdata_ovly
_mode
	.dw  (0x3)
	.ydata_ovly
_sampleBuffer
	.bss (0x80)
	.xdata_ovly
_stage_two_gain
	.dw  (0x65ac8a37)
	.xdata_ovly
_string_const_0
	.dw  (0x45)
	.dw  (0x72)
	.dw  (0x72)
	.dw  (0x6f)
	.dw  (0x72)
	.dw  (0x3a)
	.dw  (0x20)
	.dw  (0x43)
	.dw  (0x6f)
	.dw  (0x75)
	.dw  (0x6c)
	.dw  (0x64)
	.dw  (0x20)
	.dw  (0x6e)
	.dw  (0x6f)
	.dw  (0x74)
	.dw  (0x20)
	.dw  (0x6f)
	.dw  (0x70)
	.dw  (0x65)
	.dw  (0x6e)
	.dw  (0x20)
	.dw  (0x77)
	.dw  (0x61)
	.dw  (0x76)
	.dw  (0x65)
	.dw  (0x66)
	.dw  (0x69)
	.dw  (0x6c)
	.dw  (0x65)
	.dw  (0x2e)
	.dw  (0xa)
	.dw  (0x0)
	.xdata_ovly
_string_const_1
	.dw  (0x45)
	.dw  (0x72)
	.dw  (0x72)
	.dw  (0x6f)
	.dw  (0x72)
	.dw  (0x3a)
	.dw  (0x20)
	.dw  (0x43)
	.dw  (0x6f)
	.dw  (0x75)
	.dw  (0x6c)
	.dw  (0x64)
	.dw  (0x20)
	.dw  (0x6e)
	.dw  (0x6f)
	.dw  (0x74)
	.dw  (0x20)
	.dw  (0x6f)
	.dw  (0x70)
	.dw  (0x65)
	.dw  (0x6e)
	.dw  (0x20)
	.dw  (0x77)
	.dw  (0x61)
	.dw  (0x76)
	.dw  (0x65)
	.dw  (0x66)
	.dw  (0x69)
	.dw  (0x6c)
	.dw  (0x65)
	.dw  (0x2e)
	.dw  (0xa)
	.dw  (0x0)
	.xdata_ovly
_variableGain
	.dw  (0x50c332f0)
	.xdata_ovly
_x_historyLfe
	.dw  (0x0)
	.dw  (0x0)
	.xdata_ovly
_x_historyLs
	.dw  (0x0)
	.dw  (0x0)
	.xdata_ovly
_y_historyLfe
	.dw  (0x0)
	.dw  (0x0)
	.xdata_ovly
_y_historyLs
	.dw  (0x0)
	.dw  (0x0)
	.code_ovly



	# This construction should ensure linking of crt0 in case when target is a standalone program without the OS
	.if defined(_OVLY_)
		.if .strcmp('standalone',_OVLY_)=0
		.if .strcmp('crystal32',_TARGET_FAMILY_)=0
			.extern __start         # dummy use of __start to force linkage of crt0
dummy		.equ(__start)
		.else
			.extern __intvec         # dummy use of __intvec to force linkage of intvec
dummy		.equ(__intvec)
		.endif
		.endif
	.endif

_main:			/* LN: 167 | CYCLE: 0 | RULES: () */ 
	xmem[i7] = i7			# LN: 167 | 
	i7 += 1			# LN: 167 | 
	i7 = i7 + (0x210)			# LN: 167 | 
	i1 = i7 - (0x1)			# LN: 167 | 
	xmem[i1] = a0h			# LN: 167 | 
	i1 = i7 - (0x2)			# LN: 167 | 
	xmem[i1] = i0			# LN: 167 | 
cline_167_0:			/* LN: 187 | CYCLE: 0 | RULES: () */ 
	i0 = i7 - (0x3)			# LN: 187 | 
	a0 = 0			# LN: 187 | 
	xmem[i0] = a0h			# LN: 187 | 
	do (0x8), label_end_93			# LN: 187 | 
cline_187_0:			/* LN: 188 | CYCLE: 0 | RULES: () */ 
label_begin_93:			/* LN: 187 | CYCLE: 0 | RULES: () */ 
	i0 = i7 - (0x4)			# LN: 188 | 
	a0 = 0			# LN: 188 | 
	xmem[i0] = a0h			# LN: 188 | 
	do (0x10), label_end_92			# LN: 188 | 
cline_188_0:			/* LN: 189 | CYCLE: 0 | RULES: () */ 
label_begin_92:			/* LN: 188 | CYCLE: 0 | RULES: () */ 
	i0 = i7 - (0x3)			# LN: 189 | 
	a0 = xmem[i0]; a1 = 0			# LN: 189, 189 | 
	a0 = a0 << 4			# LN: 189 | 
	i0 = a0			# LN: 189 | 
	i1 = i7 - (0x4)			# LN: 189 | 
	i0 = i0 + (_sampleBuffer + 0)			# LN: 189 | 
	a0 = xmem[i1]			# LN: 189 | 
	b0 = i0			# LN: 189 | 
	a0 = a0 + b0			# LN: 189 | 
	AnyReg(i0, a0h)			# LN: 189 | 
	nop #empty cycle
	ymem[i0] = a1h			# LN: 189 | 
cline_189_0:			/* LN: 188 | CYCLE: 0 | RULES: () */ 
init_latch_label_0:			/* LN: 189 | CYCLE: 0 | RULES: () */ 
	i0 = i7 - (0x4)			# LN: 188 | 
	a0 = xmem[i0]			# LN: 188 | 
	uhalfword(a1) = (0x1)			# LN: 188 | 
	a0 = a0 + a1			# LN: 188 | 
	i0 = i7 - (0x4)			# LN: 188 | 
label_end_92:			# LN: 188 | CYCLE: 5 | RULES: ()
	xmem[i0] = a0h			# LN: 188 | 
cline_188_1:			/* LN: 187 | CYCLE: 0 | RULES: () */ 
init_latch_label_1:			/* LN: 189 | CYCLE: 0 | RULES: () */ 
for_end_1:			/* LN: 188 | CYCLE: 0 | RULES: () */ 
	i0 = i7 - (0x3)			# LN: 187 | 
	a0 = xmem[i0]			# LN: 187 | 
	uhalfword(a1) = (0x1)			# LN: 187 | 
	a0 = a0 + a1			# LN: 187 | 
	i0 = i7 - (0x3)			# LN: 187 | 
label_end_93:			# LN: 187 | CYCLE: 5 | RULES: ()
	xmem[i0] = a0h			# LN: 187 | 
cline_187_1:			/* LN: 193 | CYCLE: 0 | RULES: () */ 
for_end_0:			/* LN: 187 | CYCLE: 0 | RULES: () */ 
	i0 = i7 - (0x2)			# LN: 193 | 
	i0 = xmem[i0]			# LN: 193 | 
	i1 = i7 - (260 - 0)			# LN: 193 | 
	i4 = xmem[i0]			# LN: 193 | 
	i0 = i1			# LN: 193 | 
	i1 = i4			# LN: 193 | 
	call (_strcpy)			# LN: 193 | 
cline_193_0:			/* LN: 194 | CYCLE: 0 | RULES: () */ 
	i0 = i7 - (260 - 0)			# LN: 194 | 
	call (_cl_wavread_open)			# LN: 194 | 
	AnyReg(i0, a0h)			# LN: 194 | 
	i1 = i7 - (0x105)			# LN: 194 | 
	xmem[i1] = i0			# LN: 194 | 
cline_194_0:			/* LN: 195 | CYCLE: 0 | RULES: () */ 
	i0 = i7 - (0x105)			# LN: 195 | 
	a0 = xmem[i0]			# LN: 195 | 
	a0 & a0			# LN: 195 | 
	if (a != 0) jmp (else_2)			# LN: 195 | 
cline_195_0:			/* LN: 197 | CYCLE: 0 | RULES: () */ 
	i0 = (0) + (_string_const_0)			# LN: 197 | 
	call (_printf)			# LN: 197 | 
cline_197_0:			/* LN: 198 | CYCLE: 0 | RULES: () */ 
	halfword(a0) = (0xffff)			# LN: 198 | 
	jmp (__epilogue_240)			# LN: 198 | 
cline_198_0:			/* LN: 204 | CYCLE: 0 | RULES: () */ 
endif_2:			/* LN: 195 | CYCLE: 0 | RULES: () */ 
else_2:			/* LN: 195 | CYCLE: 0 | RULES: () */ 
	i0 = i7 - (0x105)			# LN: 204 | 
	i0 = xmem[i0]			# LN: 204 | 
	call (_cl_wavread_getnchannels)			# LN: 204 | 
	i0 = i7 - (0x106)			# LN: 204 | 
	xmem[i0] = a0h			# LN: 204 | 
cline_204_0:			/* LN: 205 | CYCLE: 0 | RULES: () */ 
	i0 = i7 - (0x105)			# LN: 205 | 
	i0 = xmem[i0]			# LN: 205 | 
	call (_cl_wavread_bits_per_sample)			# LN: 205 | 
	i0 = i7 - (0x107)			# LN: 205 | 
	xmem[i0] = a0h			# LN: 205 | 
cline_205_0:			/* LN: 206 | CYCLE: 0 | RULES: () */ 
	i0 = i7 - (0x105)			# LN: 206 | 
	i0 = xmem[i0]			# LN: 206 | 
	call (_cl_wavread_frame_rate)			# LN: 206 | 
	i0 = i7 - (0x108)			# LN: 206 | 
	xmem[i0] = a0h			# LN: 206 | 
cline_206_0:			/* LN: 207 | CYCLE: 0 | RULES: () */ 
	i0 = i7 - (0x105)			# LN: 207 | 
	i0 = xmem[i0]			# LN: 207 | 
	call (_cl_wavread_number_of_frames)			# LN: 207 | 
	i0 = i7 - (0x109)			# LN: 207 | 
	xmem[i0] = a0h			# LN: 207 | 
cline_207_0:			/* LN: 210 | CYCLE: 0 | RULES: () */ 
switch_0:			/* LN: 210 | CYCLE: 0 | RULES: () */ 
	a0 = xmem[_mode + 0]			# LN: 210 | 
	a0 & a0			# LN: 210 | 
	if (a == 0) jmp (case_0)			# LN: 210 | 
	a0 = xmem[_mode + 0]			# LN: 210 | 
	uhalfword(a1) = (0x1)			# LN: 210 | 
	a0 - a1			# LN: 210 | 
	if (a == 0) jmp (case_1)			# LN: 210 | 
	a0 = xmem[_mode + 0]			# LN: 210 | 
	uhalfword(a1) = (0x2)			# LN: 210 | 
	a0 - a1			# LN: 210 | 
	if (a == 0) jmp (case_2)			# LN: 210 | 
	a0 = xmem[_mode + 0]			# LN: 210 | 
	uhalfword(a1) = (0x3)			# LN: 210 | 
	a0 - a1			# LN: 210 | 
	if (a == 0) jmp (case_3)			# LN: 210 | 
	jmp (default_0)			# LN: 210 | 
cline_210_0:			/* LN: 212 | CYCLE: 0 | RULES: () */ 
case_0:			/* LN: 211 | CYCLE: 0 | RULES: () */ 
	i0 = i7 - (0x10a)			# LN: 212 | 
	uhalfword(a0) = (0x4)			# LN: 212 | 
	xmem[i0] = a0h			# LN: 212 | 
cline_212_0:			/* LN: 213 | CYCLE: 0 | RULES: () */ 
	jmp (switch_end_0)			# LN: 213 | 
cline_213_0:			/* LN: 215 | CYCLE: 0 | RULES: () */ 
case_1:			/* LN: 214 | CYCLE: 0 | RULES: () */ 
	i0 = i7 - (0x10a)			# LN: 215 | 
	uhalfword(a0) = (0x5)			# LN: 215 | 
	xmem[i0] = a0h			# LN: 215 | 
cline_215_0:			/* LN: 216 | CYCLE: 0 | RULES: () */ 
	jmp (switch_end_0)			# LN: 216 | 
cline_216_0:			/* LN: 218 | CYCLE: 0 | RULES: () */ 
case_2:			/* LN: 217 | CYCLE: 0 | RULES: () */ 
	i0 = i7 - (0x10a)			# LN: 218 | 
	uhalfword(a0) = (0x5)			# LN: 218 | 
	xmem[i0] = a0h			# LN: 218 | 
cline_218_0:			/* LN: 219 | CYCLE: 0 | RULES: () */ 
	jmp (switch_end_0)			# LN: 219 | 
cline_219_0:			/* LN: 221 | CYCLE: 0 | RULES: () */ 
case_3:			/* LN: 220 | CYCLE: 0 | RULES: () */ 
	i0 = i7 - (0x10a)			# LN: 221 | 
	uhalfword(a0) = (0x6)			# LN: 221 | 
	xmem[i0] = a0h			# LN: 221 | 
cline_221_0:			/* LN: 222 | CYCLE: 0 | RULES: () */ 
	jmp (switch_end_0)			# LN: 222 | 
cline_222_0:			/* LN: 224 | CYCLE: 0 | RULES: () */ 
default_0:			/* LN: 223 | CYCLE: 0 | RULES: () */ 
	i0 = i7 - (0x10a)			# LN: 224 | 
	uhalfword(a0) = (0x2)			# LN: 224 | 
	xmem[i0] = a0h			# LN: 224 | 
cline_224_0:			/* LN: 225 | CYCLE: 0 | RULES: () */ 
	jmp (switch_end_0)			# LN: 225 | 
cline_225_0:			/* LN: 230 | CYCLE: 0 | RULES: () */ 
switch_end_0:			/* LN: 210 | CYCLE: 0 | RULES: () */ 
	i0 = i7 - (0x2)			# LN: 230 | 
	i0 = xmem[i0]			# LN: 230 | 
	i1 = i7 - (522 - 0)			# LN: 230 | 
	i0 += 1			# LN: 230 | 
	i4 = xmem[i0]			# LN: 230 | 
	i0 = i1			# LN: 230 | 
	i1 = i4			# LN: 230 | 
	call (_strcpy)			# LN: 230 | 
cline_230_0:			/* LN: 235 | CYCLE: 0 | RULES: () */ 
	i0 = i7 - (522 - 0)			# LN: 235 | 
	i1 = i7 - (0x107)			# LN: 235 | 
	a0 = xmem[i1]			# LN: 235 | 
	i1 = i7 - (0x10a)			# LN: 235 | 
	a1 = xmem[i1]			# LN: 235 | 
	i1 = i7 - (0x108)			# LN: 235 | 
	b0 = xmem[i1]			# LN: 235 | 
	call (_cl_wavwrite_open)			# LN: 235 | 
	AnyReg(i0, a0h)			# LN: 235 | 
	i1 = i7 - (0x20b)			# LN: 235 | 
	xmem[i1] = i0			# LN: 235 | 
cline_235_0:			/* LN: 236 | CYCLE: 0 | RULES: () */ 
	i0 = i7 - (0x20b)			# LN: 236 | 
	a0 = xmem[i0]			# LN: 236 | 
	a0 & a0			# LN: 236 | 
	if (a != 0) jmp (else_3)			# LN: 236 | 
cline_236_0:			/* LN: 238 | CYCLE: 0 | RULES: () */ 
	i0 = (0) + (_string_const_1)			# LN: 238 | 
	call (_printf)			# LN: 238 | 
cline_238_0:			/* LN: 239 | CYCLE: 0 | RULES: () */ 
	halfword(a0) = (0xffff)			# LN: 239 | 
	jmp (__epilogue_240)			# LN: 239 | 
cline_239_0:			/* LN: 252 | CYCLE: 0 | RULES: () */ 
endif_3:			/* LN: 236 | CYCLE: 0 | RULES: () */ 
else_3:			/* LN: 236 | CYCLE: 0 | RULES: () */ 
	i0 = i7 - (0x20c)			# LN: 252 | 
	a0 = 0			# LN: 252 | 
	xmem[i0] = a0h			# LN: 252 | 
for_2:			/* LN: 252 | CYCLE: 0 | RULES: () */ 
	i0 = i7 - (0x109)			# LN: 252 | 
	a0 = xmem[i0]			# LN: 252 | 
	uhalfword(a1) = (0x10)			# LN: 252 | 
	call (__div)			# LN: 252 | 
	i0 = i7 - (0x20c)			# LN: 252 | 
	a1 = xmem[i0]			# LN: 252 | 
	a1 - a0			# LN: 252 | 
	if (a >= 0) jmp (for_end_2)			# LN: 252 | 
cline_252_0:			/* LN: 254 | CYCLE: 0 | RULES: () */ 
	i0 = i7 - (0x20d)			# LN: 254 | 
	a0 = 0			# LN: 254 | 
	xmem[i0] = a0h			# LN: 254 | 
	do (0x10), label_end_94			# LN: 254 | 
cline_254_0:			/* LN: 256 | CYCLE: 0 | RULES: () */ 
label_begin_94:			/* LN: 254 | CYCLE: 0 | RULES: () */ 
	i0 = i7 - (0x20e)			# LN: 256 | 
	a0 = 0			# LN: 256 | 
	xmem[i0] = a0h			# LN: 256 | 
for_4:			/* LN: 256 | CYCLE: 0 | RULES: () */ 
	i0 = i7 - (0x20e)			# LN: 256 | 
	a0 = xmem[i0]			# LN: 256 | 
	i0 = i7 - (0x106)			# LN: 256 | 
	a1 = xmem[i0]			# LN: 256 | 
	a0 - a1			# LN: 256 | 
	if (a >= 0) jmp (for_end_4)			# LN: 256 | 
cline_256_0:			/* LN: 258 | CYCLE: 0 | RULES: () */ 
	i0 = i7 - (0x105)			# LN: 258 | 
	i0 = xmem[i0]			# LN: 258 | 
	call (_cl_wavread_recvsample)			# LN: 258 | 
	i0 = i7 - (0x20f)			# LN: 258 | 
	xmem[i0] = a0h			# LN: 258 | 
cline_258_0:			/* LN: 259 | CYCLE: 0 | RULES: () */ 
	i0 = i7 - (0x20e)			# LN: 259 | 
	a0 = xmem[i0]			# LN: 259 | 
	a0 = a0 << 4			# LN: 259 | 
	i0 = a0			# LN: 259 | 
	i1 = i7 - (0x20d)			# LN: 259 | 
	i0 = i0 + (_sampleBuffer + 0)			# LN: 259 | 
	a0 = xmem[i1]			# LN: 259 | 
	a1 = i0			# LN: 259 | 
	a0 = a1 + a0			# LN: 259 | 
	AnyReg(i0, a0h)			# LN: 259 | 
	i1 = i7 - (0x20f)			# LN: 259 | 
	a0 = xmem[i1]			# LN: 259 | 
	ymem[i0] = a0h			# LN: 259 | 
cline_259_0:			/* LN: 256 | CYCLE: 0 | RULES: () */ 
init_latch_label_2:			/* LN: 260 | CYCLE: 0 | RULES: () */ 
	i0 = i7 - (0x20e)			# LN: 256 | 
	a0 = xmem[i0]			# LN: 256 | 
	uhalfword(a1) = (0x1)			# LN: 256 | 
	a0 = a0 + a1			# LN: 256 | 
	i0 = i7 - (0x20e)			# LN: 256 | 
	xmem[i0] = a0h			# LN: 256 | 
	jmp (for_4)			# LN: 256 | 
cline_256_1:			/* LN: 254 | CYCLE: 0 | RULES: () */ 
init_latch_label_3:			/* LN: 261 | CYCLE: 0 | RULES: () */ 
for_end_4:			/* LN: 256 | CYCLE: 0 | RULES: () */ 
	i0 = i7 - (0x20d)			# LN: 254 | 
	a0 = xmem[i0]			# LN: 254 | 
	uhalfword(a1) = (0x1)			# LN: 254 | 
	a0 = a0 + a1			# LN: 254 | 
	i0 = i7 - (0x20d)			# LN: 254 | 
label_end_94:			# LN: 254 | CYCLE: 5 | RULES: ()
	xmem[i0] = a0h			# LN: 254 | 
cline_254_1:			/* LN: 266 | CYCLE: 0 | RULES: () */ 
for_end_3:			/* LN: 254 | CYCLE: 0 | RULES: () */ 
	a0 = xmem[_enabled + 0]			# LN: 266 | 
	a0 & a0			# LN: 266 | 
	if (a == 0) jmp (else_4)			# LN: 266 | 
cline_266_0:			/* LN: 267 | CYCLE: 0 | RULES: () */ 
	i0 = (0) + (_sampleBuffer)			# LN: 267 | 
	i1 = (0) + (_sampleBuffer)			# LN: 267 | 
	call (_processing)			# LN: 267 | 
	jmp (endif_4)			# LN: 267 | 
cline_267_0:			/* LN: 274 | CYCLE: 0 | RULES: () */ 
endif_4:			/* LN: 266 | CYCLE: 0 | RULES: () */ 
else_4:			/* LN: 266 | CYCLE: 0 | RULES: () */ 
	i0 = i7 - (0x20d)			# LN: 274 | 
	a0 = 0			# LN: 274 | 
	xmem[i0] = a0h			# LN: 274 | 
	do (0x10), label_end_95			# LN: 274 | 
cline_274_0:			/* LN: 276 | CYCLE: 0 | RULES: () */ 
label_begin_95:			/* LN: 274 | CYCLE: 0 | RULES: () */ 
	i0 = i7 - (0x20e)			# LN: 276 | 
	a0 = 0			# LN: 276 | 
	xmem[i0] = a0h			# LN: 276 | 
for_6:			/* LN: 276 | CYCLE: 0 | RULES: () */ 
	i0 = i7 - (0x20e)			# LN: 276 | 
	a0 = xmem[i0]			# LN: 276 | 
	i0 = i7 - (0x10a)			# LN: 276 | 
	a1 = xmem[i0]			# LN: 276 | 
	a0 - a1			# LN: 276 | 
	if (a >= 0) jmp (for_end_6)			# LN: 276 | 
cline_276_0:			/* LN: 278 | CYCLE: 0 | RULES: () */ 
	i0 = i7 - (0x210)			# LN: 278 | 
	a0 = 0			# LN: 278 | 
	xmem[i0] = a0h			# LN: 278 | 
cline_278_0:			/* LN: 279 | CYCLE: 0 | RULES: () */ 
switch_1:			/* LN: 279 | CYCLE: 0 | RULES: () */ 
	a0 = xmem[_mode + 0]			# LN: 279 | 
	a0 & a0			# LN: 279 | 
	if (a == 0) jmp (case_4)			# LN: 279 | 
	a0 = xmem[_mode + 0]			# LN: 279 | 
	uhalfword(a1) = (0x1)			# LN: 279 | 
	a0 - a1			# LN: 279 | 
	if (a == 0) jmp (case_5)			# LN: 279 | 
	a0 = xmem[_mode + 0]			# LN: 279 | 
	uhalfword(a1) = (0x2)			# LN: 279 | 
	a0 - a1			# LN: 279 | 
	if (a == 0) jmp (case_6)			# LN: 279 | 
	a0 = xmem[_mode + 0]			# LN: 279 | 
	uhalfword(a1) = (0x3)			# LN: 279 | 
	a0 - a1			# LN: 279 | 
	if (a == 0) jmp (case_7)			# LN: 279 | 
	jmp (default_1)			# LN: 279 | 
cline_279_0:			/* LN: 282 | CYCLE: 0 | RULES: () */ 
case_4:			/* LN: 281 | CYCLE: 0 | RULES: () */ 
	i0 = i7 - (0x20e)			# LN: 282 | 
	a0 = xmem[i0]			# LN: 282 | 
	a0 & a0			# LN: 282 | 
	if (a != 0) jmp (else_5)			# LN: 282 | 
	i0 = i7 - (0x210)			# LN: 282 | 
	a0 = 0			# LN: 282 | 
	xmem[i0] = a0h			# LN: 282 | 
	jmp (endif_5)			# LN: 282 | 
cline_282_0:			/* LN: 283 | CYCLE: 0 | RULES: () */ 
endif_5:			/* LN: 282 | CYCLE: 0 | RULES: () */ 
else_5:			/* LN: 282 | CYCLE: 0 | RULES: () */ 
	i0 = i7 - (0x20e)			# LN: 283 | 
	a0 = xmem[i0]			# LN: 283 | 
	uhalfword(a1) = (0x1)			# LN: 283 | 
	a0 - a1			# LN: 283 | 
	if (a != 0) jmp (else_6)			# LN: 283 | 
	i0 = i7 - (0x210)			# LN: 283 | 
	uhalfword(a0) = (0x1)			# LN: 283 | 
	xmem[i0] = a0h			# LN: 283 | 
	jmp (endif_6)			# LN: 283 | 
cline_283_0:			/* LN: 284 | CYCLE: 0 | RULES: () */ 
endif_6:			/* LN: 283 | CYCLE: 0 | RULES: () */ 
else_6:			/* LN: 283 | CYCLE: 0 | RULES: () */ 
	i0 = i7 - (0x20e)			# LN: 284 | 
	a0 = xmem[i0]			# LN: 284 | 
	uhalfword(a1) = (0x2)			# LN: 284 | 
	a0 - a1			# LN: 284 | 
	if (a != 0) jmp (else_7)			# LN: 284 | 
	i0 = i7 - (0x210)			# LN: 284 | 
	uhalfword(a0) = (0x4)			# LN: 284 | 
	xmem[i0] = a0h			# LN: 284 | 
	jmp (endif_7)			# LN: 284 | 
cline_284_0:			/* LN: 285 | CYCLE: 0 | RULES: () */ 
endif_7:			/* LN: 284 | CYCLE: 0 | RULES: () */ 
else_7:			/* LN: 284 | CYCLE: 0 | RULES: () */ 
	i0 = i7 - (0x20e)			# LN: 285 | 
	a0 = xmem[i0]			# LN: 285 | 
	uhalfword(a1) = (0x3)			# LN: 285 | 
	a0 - a1			# LN: 285 | 
	if (a != 0) jmp (else_8)			# LN: 285 | 
	i0 = i7 - (0x210)			# LN: 285 | 
	uhalfword(a0) = (0x5)			# LN: 285 | 
	xmem[i0] = a0h			# LN: 285 | 
	jmp (endif_8)			# LN: 285 | 
cline_285_0:			/* LN: 286 | CYCLE: 0 | RULES: () */ 
endif_8:			/* LN: 285 | CYCLE: 0 | RULES: () */ 
else_8:			/* LN: 285 | CYCLE: 0 | RULES: () */ 
	jmp (switch_end_1)			# LN: 286 | 
cline_286_0:			/* LN: 288 | CYCLE: 0 | RULES: () */ 
case_5:			/* LN: 287 | CYCLE: 0 | RULES: () */ 
	i0 = i7 - (0x20e)			# LN: 288 | 
	a0 = xmem[i0]			# LN: 288 | 
	a0 & a0			# LN: 288 | 
	if (a != 0) jmp (else_9)			# LN: 288 | 
	i0 = i7 - (0x210)			# LN: 288 | 
	a0 = 0			# LN: 288 | 
	xmem[i0] = a0h			# LN: 288 | 
	jmp (endif_9)			# LN: 288 | 
cline_288_0:			/* LN: 289 | CYCLE: 0 | RULES: () */ 
endif_9:			/* LN: 288 | CYCLE: 0 | RULES: () */ 
else_9:			/* LN: 288 | CYCLE: 0 | RULES: () */ 
	i0 = i7 - (0x20e)			# LN: 289 | 
	a0 = xmem[i0]			# LN: 289 | 
	uhalfword(a1) = (0x1)			# LN: 289 | 
	a0 - a1			# LN: 289 | 
	if (a != 0) jmp (else_10)			# LN: 289 | 
	i0 = i7 - (0x210)			# LN: 289 | 
	uhalfword(a0) = (0x1)			# LN: 289 | 
	xmem[i0] = a0h			# LN: 289 | 
	jmp (endif_10)			# LN: 289 | 
cline_289_0:			/* LN: 290 | CYCLE: 0 | RULES: () */ 
endif_10:			/* LN: 289 | CYCLE: 0 | RULES: () */ 
else_10:			/* LN: 289 | CYCLE: 0 | RULES: () */ 
	i0 = i7 - (0x20e)			# LN: 290 | 
	a0 = xmem[i0]			# LN: 290 | 
	uhalfword(a1) = (0x2)			# LN: 290 | 
	a0 - a1			# LN: 290 | 
	if (a != 0) jmp (else_11)			# LN: 290 | 
	i0 = i7 - (0x210)			# LN: 290 | 
	uhalfword(a0) = (0x3)			# LN: 290 | 
	xmem[i0] = a0h			# LN: 290 | 
	jmp (endif_11)			# LN: 290 | 
cline_290_0:			/* LN: 291 | CYCLE: 0 | RULES: () */ 
endif_11:			/* LN: 290 | CYCLE: 0 | RULES: () */ 
else_11:			/* LN: 290 | CYCLE: 0 | RULES: () */ 
	i0 = i7 - (0x20e)			# LN: 291 | 
	a0 = xmem[i0]			# LN: 291 | 
	uhalfword(a1) = (0x3)			# LN: 291 | 
	a0 - a1			# LN: 291 | 
	if (a != 0) jmp (else_12)			# LN: 291 | 
	i0 = i7 - (0x210)			# LN: 291 | 
	uhalfword(a0) = (0x4)			# LN: 291 | 
	xmem[i0] = a0h			# LN: 291 | 
	jmp (endif_12)			# LN: 291 | 
cline_291_0:			/* LN: 292 | CYCLE: 0 | RULES: () */ 
endif_12:			/* LN: 291 | CYCLE: 0 | RULES: () */ 
else_12:			/* LN: 291 | CYCLE: 0 | RULES: () */ 
	i0 = i7 - (0x20e)			# LN: 292 | 
	a0 = xmem[i0]			# LN: 292 | 
	uhalfword(a1) = (0x4)			# LN: 292 | 
	a0 - a1			# LN: 292 | 
	if (a != 0) jmp (else_13)			# LN: 292 | 
	i0 = i7 - (0x210)			# LN: 292 | 
	uhalfword(a0) = (0x5)			# LN: 292 | 
	xmem[i0] = a0h			# LN: 292 | 
	jmp (endif_13)			# LN: 292 | 
cline_292_0:			/* LN: 293 | CYCLE: 0 | RULES: () */ 
endif_13:			/* LN: 292 | CYCLE: 0 | RULES: () */ 
else_13:			/* LN: 292 | CYCLE: 0 | RULES: () */ 
	jmp (switch_end_1)			# LN: 293 | 
cline_293_0:			/* LN: 295 | CYCLE: 0 | RULES: () */ 
case_6:			/* LN: 294 | CYCLE: 0 | RULES: () */ 
	i0 = i7 - (0x20e)			# LN: 295 | 
	a0 = xmem[i0]			# LN: 295 | 
	a0 & a0			# LN: 295 | 
	if (a != 0) jmp (else_14)			# LN: 295 | 
	i0 = i7 - (0x210)			# LN: 295 | 
	a0 = 0			# LN: 295 | 
	xmem[i0] = a0h			# LN: 295 | 
	jmp (endif_14)			# LN: 295 | 
cline_295_0:			/* LN: 296 | CYCLE: 0 | RULES: () */ 
endif_14:			/* LN: 295 | CYCLE: 0 | RULES: () */ 
else_14:			/* LN: 295 | CYCLE: 0 | RULES: () */ 
	i0 = i7 - (0x20e)			# LN: 296 | 
	a0 = xmem[i0]			# LN: 296 | 
	uhalfword(a1) = (0x1)			# LN: 296 | 
	a0 - a1			# LN: 296 | 
	if (a != 0) jmp (else_15)			# LN: 296 | 
	i0 = i7 - (0x210)			# LN: 296 | 
	uhalfword(a0) = (0x1)			# LN: 296 | 
	xmem[i0] = a0h			# LN: 296 | 
	jmp (endif_15)			# LN: 296 | 
cline_296_0:			/* LN: 297 | CYCLE: 0 | RULES: () */ 
endif_15:			/* LN: 296 | CYCLE: 0 | RULES: () */ 
else_15:			/* LN: 296 | CYCLE: 0 | RULES: () */ 
	i0 = i7 - (0x20e)			# LN: 297 | 
	a0 = xmem[i0]			# LN: 297 | 
	uhalfword(a1) = (0x2)			# LN: 297 | 
	a0 - a1			# LN: 297 | 
	if (a != 0) jmp (else_16)			# LN: 297 | 
	i0 = i7 - (0x210)			# LN: 297 | 
	uhalfword(a0) = (0x2)			# LN: 297 | 
	xmem[i0] = a0h			# LN: 297 | 
	jmp (endif_16)			# LN: 297 | 
cline_297_0:			/* LN: 298 | CYCLE: 0 | RULES: () */ 
endif_16:			/* LN: 297 | CYCLE: 0 | RULES: () */ 
else_16:			/* LN: 297 | CYCLE: 0 | RULES: () */ 
	i0 = i7 - (0x20e)			# LN: 298 | 
	a0 = xmem[i0]			# LN: 298 | 
	uhalfword(a1) = (0x3)			# LN: 298 | 
	a0 - a1			# LN: 298 | 
	if (a != 0) jmp (else_17)			# LN: 298 | 
	i0 = i7 - (0x210)			# LN: 298 | 
	uhalfword(a0) = (0x4)			# LN: 298 | 
	xmem[i0] = a0h			# LN: 298 | 
	jmp (endif_17)			# LN: 298 | 
cline_298_0:			/* LN: 299 | CYCLE: 0 | RULES: () */ 
endif_17:			/* LN: 298 | CYCLE: 0 | RULES: () */ 
else_17:			/* LN: 298 | CYCLE: 0 | RULES: () */ 
	i0 = i7 - (0x20e)			# LN: 299 | 
	a0 = xmem[i0]			# LN: 299 | 
	uhalfword(a1) = (0x4)			# LN: 299 | 
	a0 - a1			# LN: 299 | 
	if (a != 0) jmp (else_18)			# LN: 299 | 
	i0 = i7 - (0x210)			# LN: 299 | 
	uhalfword(a0) = (0x5)			# LN: 299 | 
	xmem[i0] = a0h			# LN: 299 | 
	jmp (endif_18)			# LN: 299 | 
cline_299_0:			/* LN: 300 | CYCLE: 0 | RULES: () */ 
endif_18:			/* LN: 299 | CYCLE: 0 | RULES: () */ 
else_18:			/* LN: 299 | CYCLE: 0 | RULES: () */ 
	jmp (switch_end_1)			# LN: 300 | 
cline_300_0:			/* LN: 302 | CYCLE: 0 | RULES: () */ 
case_7:			/* LN: 301 | CYCLE: 0 | RULES: () */ 
	i0 = i7 - (0x20e)			# LN: 302 | 
	a0 = xmem[i0]			# LN: 302 | 
	a0 & a0			# LN: 302 | 
	if (a != 0) jmp (else_19)			# LN: 302 | 
	i0 = i7 - (0x210)			# LN: 302 | 
	a0 = 0			# LN: 302 | 
	xmem[i0] = a0h			# LN: 302 | 
	jmp (endif_19)			# LN: 302 | 
cline_302_0:			/* LN: 303 | CYCLE: 0 | RULES: () */ 
endif_19:			/* LN: 302 | CYCLE: 0 | RULES: () */ 
else_19:			/* LN: 302 | CYCLE: 0 | RULES: () */ 
	i0 = i7 - (0x20e)			# LN: 303 | 
	a0 = xmem[i0]			# LN: 303 | 
	uhalfword(a1) = (0x1)			# LN: 303 | 
	a0 - a1			# LN: 303 | 
	if (a != 0) jmp (else_20)			# LN: 303 | 
	i0 = i7 - (0x210)			# LN: 303 | 
	uhalfword(a0) = (0x1)			# LN: 303 | 
	xmem[i0] = a0h			# LN: 303 | 
	jmp (endif_20)			# LN: 303 | 
cline_303_0:			/* LN: 304 | CYCLE: 0 | RULES: () */ 
endif_20:			/* LN: 303 | CYCLE: 0 | RULES: () */ 
else_20:			/* LN: 303 | CYCLE: 0 | RULES: () */ 
	i0 = i7 - (0x20e)			# LN: 304 | 
	a0 = xmem[i0]			# LN: 304 | 
	uhalfword(a1) = (0x2)			# LN: 304 | 
	a0 - a1			# LN: 304 | 
	if (a != 0) jmp (else_21)			# LN: 304 | 
	i0 = i7 - (0x210)			# LN: 304 | 
	uhalfword(a0) = (0x2)			# LN: 304 | 
	xmem[i0] = a0h			# LN: 304 | 
	jmp (endif_21)			# LN: 304 | 
cline_304_0:			/* LN: 305 | CYCLE: 0 | RULES: () */ 
endif_21:			/* LN: 304 | CYCLE: 0 | RULES: () */ 
else_21:			/* LN: 304 | CYCLE: 0 | RULES: () */ 
	i0 = i7 - (0x20e)			# LN: 305 | 
	a0 = xmem[i0]			# LN: 305 | 
	uhalfword(a1) = (0x3)			# LN: 305 | 
	a0 - a1			# LN: 305 | 
	if (a != 0) jmp (else_22)			# LN: 305 | 
	i0 = i7 - (0x210)			# LN: 305 | 
	uhalfword(a0) = (0x3)			# LN: 305 | 
	xmem[i0] = a0h			# LN: 305 | 
	jmp (endif_22)			# LN: 305 | 
cline_305_0:			/* LN: 306 | CYCLE: 0 | RULES: () */ 
endif_22:			/* LN: 305 | CYCLE: 0 | RULES: () */ 
else_22:			/* LN: 305 | CYCLE: 0 | RULES: () */ 
	i0 = i7 - (0x20e)			# LN: 306 | 
	a0 = xmem[i0]			# LN: 306 | 
	uhalfword(a1) = (0x4)			# LN: 306 | 
	a0 - a1			# LN: 306 | 
	if (a != 0) jmp (else_23)			# LN: 306 | 
	i0 = i7 - (0x210)			# LN: 306 | 
	uhalfword(a0) = (0x4)			# LN: 306 | 
	xmem[i0] = a0h			# LN: 306 | 
	jmp (endif_23)			# LN: 306 | 
cline_306_0:			/* LN: 307 | CYCLE: 0 | RULES: () */ 
endif_23:			/* LN: 306 | CYCLE: 0 | RULES: () */ 
else_23:			/* LN: 306 | CYCLE: 0 | RULES: () */ 
	i0 = i7 - (0x20e)			# LN: 307 | 
	a0 = xmem[i0]			# LN: 307 | 
	uhalfword(a1) = (0x5)			# LN: 307 | 
	a0 - a1			# LN: 307 | 
	if (a != 0) jmp (else_24)			# LN: 307 | 
	i0 = i7 - (0x210)			# LN: 307 | 
	uhalfword(a0) = (0x5)			# LN: 307 | 
	xmem[i0] = a0h			# LN: 307 | 
	jmp (endif_24)			# LN: 307 | 
cline_307_0:			/* LN: 308 | CYCLE: 0 | RULES: () */ 
endif_24:			/* LN: 307 | CYCLE: 0 | RULES: () */ 
else_24:			/* LN: 307 | CYCLE: 0 | RULES: () */ 
	jmp (switch_end_1)			# LN: 308 | 
cline_308_0:			/* LN: 310 | CYCLE: 0 | RULES: () */ 
default_1:			/* LN: 309 | CYCLE: 0 | RULES: () */ 
	jmp (switch_end_1)			# LN: 310 | 
cline_310_0:			/* LN: 312 | CYCLE: 0 | RULES: () */ 
switch_end_1:			/* LN: 279 | CYCLE: 0 | RULES: () */ 
	i0 = i7 - (0x210)			# LN: 312 | 
	a0 = xmem[i0]			# LN: 312 | 
	a0 = a0 << 4			# LN: 312 | 
	i0 = a0			# LN: 312 | 
	i1 = i7 - (0x20d)			# LN: 312 | 
	i0 = i0 + (_sampleBuffer + 0)			# LN: 312 | 
	a0 = xmem[i1]			# LN: 312 | 
	a1 = i0			# LN: 312 | 
	a0 = a1 + a0			# LN: 312 | 
	AnyReg(i0, a0h)			# LN: 312 | 
	i1 = i7 - (0x20f)			# LN: 312 | 
	a0 = ymem[i0]			# LN: 312 | 
	xmem[i1] = a0h			# LN: 312 | 
cline_312_0:			/* LN: 313 | CYCLE: 0 | RULES: () */ 
	i0 = i7 - (0x20b)			# LN: 313 | 
	i1 = i7 - (0x20f)			# LN: 313 | 
	a0 = xmem[i1]			# LN: 313 | 
	i0 = xmem[i0]			# LN: 313 | 
	call (_cl_wavwrite_sendsample)			# LN: 313 | 
cline_313_0:			/* LN: 276 | CYCLE: 0 | RULES: () */ 
init_latch_label_4:			/* LN: 314 | CYCLE: 0 | RULES: () */ 
	i0 = i7 - (0x20e)			# LN: 276 | 
	a0 = xmem[i0]			# LN: 276 | 
	uhalfword(a1) = (0x1)			# LN: 276 | 
	a0 = a0 + a1			# LN: 276 | 
	i0 = i7 - (0x20e)			# LN: 276 | 
	xmem[i0] = a0h			# LN: 276 | 
	jmp (for_6)			# LN: 276 | 
cline_276_1:			/* LN: 274 | CYCLE: 0 | RULES: () */ 
init_latch_label_5:			/* LN: 315 | CYCLE: 0 | RULES: () */ 
for_end_6:			/* LN: 276 | CYCLE: 0 | RULES: () */ 
	i0 = i7 - (0x20d)			# LN: 274 | 
	a0 = xmem[i0]			# LN: 274 | 
	uhalfword(a1) = (0x1)			# LN: 274 | 
	a0 = a0 + a1			# LN: 274 | 
	i0 = i7 - (0x20d)			# LN: 274 | 
label_end_95:			# LN: 274 | CYCLE: 5 | RULES: ()
	xmem[i0] = a0h			# LN: 274 | 
cline_274_1:			/* LN: 252 | CYCLE: 0 | RULES: () */ 
init_latch_label_6:			/* LN: 316 | CYCLE: 0 | RULES: () */ 
for_end_5:			/* LN: 274 | CYCLE: 0 | RULES: () */ 
	i0 = i7 - (0x20c)			# LN: 252 | 
	a0 = xmem[i0]			# LN: 252 | 
	uhalfword(a1) = (0x1)			# LN: 252 | 
	a0 = a0 + a1			# LN: 252 | 
	i0 = i7 - (0x20c)			# LN: 252 | 
	xmem[i0] = a0h			# LN: 252 | 
	jmp (for_2)			# LN: 252 | 
cline_252_1:			/* LN: 321 | CYCLE: 0 | RULES: () */ 
for_end_2:			/* LN: 252 | CYCLE: 0 | RULES: () */ 
	i0 = i7 - (0x105)			# LN: 321 | 
	i0 = xmem[i0]			# LN: 321 | 
	call (_cl_wavread_close)			# LN: 321 | 
cline_321_0:			/* LN: 322 | CYCLE: 0 | RULES: () */ 
	i0 = i7 - (0x20b)			# LN: 322 | 
	i0 = xmem[i0]			# LN: 322 | 
	call (_cl_wavwrite_close)			# LN: 322 | 
cline_322_0:			/* LN: 325 | CYCLE: 0 | RULES: () */ 
	a0 = 0			# LN: 325 | 
	jmp (__epilogue_240)			# LN: 325 | 
cline_325_0:			/* LN: 326 | CYCLE: 0 | RULES: () */ 
__epilogue_240:			/* LN: 326 | CYCLE: 0 | RULES: () */ 
	i7 = i7 - (0x210)			# LN: 326 | 
	i7 -= 1			# LN: 326 | 
	ret			# LN: 326 | 



_saturation:			/* LN: 48 | CYCLE: 0 | RULES: () */ 
	xmem[i7] = i7			# LN: 48 | 
	i7 += 1			# LN: 48 | 
	i7 = i7 + (0x6)			# LN: 48 | 
	i0 = i7 - (0x3)			# LN: 48 | 
	xmem[i0] = a0g; i0 += 1			# LN: 48, 48 | 
	xmem[i0] = a0h; i0 += 1			# LN: 48, 48 | 
	xmem[i0] = a0l			# LN: 48 | 
cline_48_0:			/* LN: 50 | CYCLE: 0 | RULES: () */ 
	i0 = i7 - (0x3)			# LN: 50 | 
	a0g = xmem[i0]; i0 += 1			# LN: 50, 50 | 
	a0h = xmem[i0]; i0 += 1			# LN: 50, 50 | 
	a0l = xmem[i0]			# LN: 50 | 
	i0 = i7 - (0x6)			# LN: 50 | 
	xmem[i0] = a0g; i0 += 1			# LN: 50, 50 | 
	xmem[i0] = a0h; i0 += 1			# LN: 50, 50 | 
	xmem[i0] = a0l			# LN: 50 | 
cline_50_0:			/* LN: 52 | CYCLE: 0 | RULES: () */ 
	i0 = i7 - (0x6)			# LN: 52 | 
	a1g = xmem[i0]; i0 += 1			# LN: 52, 52 | 
	a1h = xmem[i0]; i0 += 1			# LN: 52, 52 | 
	a1l = xmem[i0]			# LN: 52 | 
	b0 =+ a1			# LN: 52 | 
	b0 = b0 >> 1			# LN: 52 | 
	a0 = xmem[_limiterThreshold + 0]			# LN: 52 | 
	a0 = a0 >> 1			# LN: 52 | 
	b0 - a0			# LN: 52 | 
	if (b <= 0) jmp (else_0)			# LN: 52 | 
cline_52_0:			/* LN: 54 | CYCLE: 0 | RULES: () */ 
	a0 = xmem[_limiterThreshold + 0]			# LN: 54 | 
	jmp (__epilogue_234)			# LN: 54 | 
cline_54_0:			/* LN: 56 | CYCLE: 0 | RULES: () */ 
else_0:			/* LN: 52 | CYCLE: 0 | RULES: () */ 
	a0 = xmem[_limiterThreshold + 0]			# LN: 56 | 
	i0 = i7 - (0x6)			# LN: 56 | 
	a1g = xmem[i0]; i0 += 1			# LN: 56, 56 | 
	a1h = xmem[i0]; i0 += 1			# LN: 56, 56 | 
	a0 =- a0			# LN: 56 | 
	a1l = xmem[i0]			# LN: 56 | 
	b0 =+ a1			# LN: 56 | 
	a0 = a0 >> 1; b0 = b0 >> 1			# LN: 56, 56 | 
	b0 - a0			# LN: 56 | 
	if (b >= 0) jmp (else_1)			# LN: 56 | 
cline_56_0:			/* LN: 58 | CYCLE: 0 | RULES: () */ 
	a0 = xmem[_limiterThreshold + 0]			# LN: 58 | 
	a0 =- a0			# LN: 58 | 
	jmp (__epilogue_234)			# LN: 58 | 
cline_58_0:			/* LN: 60 | CYCLE: 0 | RULES: () */ 
endif_0:			/* LN: 52 | CYCLE: 0 | RULES: () */ 
endif_1:			/* LN: 56 | CYCLE: 0 | RULES: () */ 
else_1:			/* LN: 56 | CYCLE: 0 | RULES: () */ 
	i0 = i7 - (0x3)			# LN: 60 | 
	a0g = xmem[i0]; i0 += 1			# LN: 60, 60 | 
	a0h = xmem[i0]; i0 += 1			# LN: 60, 60 | 
	a0l = xmem[i0]			# LN: 60 | 
	a0 = a0			# LN: 60 | 
	jmp (__epilogue_234)			# LN: 60 | 
cline_60_0:			/* LN: 61 | CYCLE: 0 | RULES: () */ 
__epilogue_234:			/* LN: 61 | CYCLE: 0 | RULES: () */ 
	i7 = i7 - (0x6)			# LN: 61 | 
	i7 -= 1			# LN: 61 | 
	ret			# LN: 61 | 
