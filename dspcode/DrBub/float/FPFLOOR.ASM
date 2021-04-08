;**************************************************************
; DESCRIPTION:
; FPFLOOR - FLOATING POINT FLOOR SUBROUTINE
;
; REVISION HISTORY:
; Date           Change
; 02-22-1988     Initial placement
; 11-19-1998     Implementation on DSP56300 
;**************************************************************
fpfloor	ident	1,0
;
; Entry points:	floor_a	   R = floor(A)
;			floor_x	   R = floor(X)
;
;	m = 24 bit mantissa (two's complement, normalized fraction)
;
;	e = 14 bit exponent (unsigned integer, biased by +8191)
;
; Input variables:
;
;   X	x1 = mx  (normalized)
;	x0 = ex
;
;   A	a2 = sign extension of ma
;	a1 = ma  (normalized)
;	a0 = zero
;
;	b2 = sign extension of ea (always zero)
;	b1 = ea
;	b0 = zero
;
; Output variables:
;
;   R	a2 = sign extension of mr
;	a1 = mr  (normalized)
;	a0 = zero
;
;	b2 = sign extension of er (always zero)
;	b1 = er
;	b0 = zero
;
; Error conditions:	No error conditions are signaled.
;
; Assumes m0 and scaling modes initialized by previous call to the subroutine "fpinit".
;
; Alters Data ALU Registers
;	a2	a1	a0	a
;	b2	b1	b0	b
;	x1	x0
;
; Alters Program Control Registers
;	pc	sr
;	ssh	ssl	sp
;
; Uses 0 locations on System Stack
;
floor_x	tfr	x0,b	x1,a		;get mx,ex
floor_a
	tst	a	#$1fff+23,x0	;check a, max exponent w/o fraction
	jeq	_done			;if a=0, result=0
	cmp	x0,b	fp_space:fp_ebias,x0	;check for max input
	jge	_done			;if max, result=input
	cmp	x0,b	b,x1		;check for fraction, save exponent
	jgt	_inrange		;jump if not less than one
	and	#$800000,a		;if 0<input<1 --> output=0,if -1<=input<0 --> output=-1
	tst	a	#0,b		
	tmi	x0,b			;if 0<input<1 --> er=$000000,if -1<=input<0 --> er=$001fff
	rts
_inrange
	sub	x0,b			;subtract bias,get real exponent
	neg	b
	add	#23,b			;23-real exponent
	lsr	b1,a
	lsl	b1,a			;clear the less significant (23-real exponent) bits
	move	x1,b			;restore exponent
_done
	rts
