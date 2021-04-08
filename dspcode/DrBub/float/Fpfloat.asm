;**************************************************************
; DESCRIPTION:
; FPFLOAT - FIXED POINT TO FLOATING POINT CONVERSION SUBROUTINE
;
; REVISION HISTORY:
; Date           Change
; 06-10-1987     Initial placement
; 11-19-1998     Implementation on DSP56300 
;**************************************************************
fpfloat ident   1,0
;
; Entry points: float_a R = float(A)
;               float_x R = float(X)
;
;       data = 56 bit two's complement fixed point number
;              consisting of a 48 bit fraction with an 8 bit
;              integer extension in standard accumulator data
;              representation.
;
;       m = 24 bit mantissa (two's complement, normalized fraction)
;
;       e = 14 bit exponent (unsigned integer, biased by +8191)
;
; Input variables:
;
;   X   x1 = data
;
;   A    a = data
;
; Output variables:
;
;   R   a2 = sign extension of mr
;       a1 = mr  (normalized)
;       a0 = zero
;
;       b2 = sign extension of er (always zero)
;       b1 = er
;       b0 = zero
;
; Error conditions:     none
;
; Assumes m0 and scaling modes initialized by previous call to the subroutine "fpinit".
;
; Alters Data ALU Registers
;       a2      a1      a0      a
;       b2      b1      b0      b
;       y1
;
; Alters Address Registers
;
; Alters Program Control Registers
;       pc      sr
;
; Uses 0 locations on System Stack
;
;
float_x tfr     	x1,a                    ;get data
float_a tst     	a       fp_space:fp_ebias,y1		;check data, initialize er
        jnr     	float1                  ;jump if data normalized
	  clb		a,b
	  normf	b1,a			    	;normalization
	  add		y1,b			
	  nop
	  move	b,y1			    	;get new er
float1  rnd     	a 	   		    	;round to 24 bit mr
	  clb		a,b	
	  normf	b1,a	
	  add		y1,b			    	;correct mr overflow due to round
        jmp     	check1                  ;go check exponent range
