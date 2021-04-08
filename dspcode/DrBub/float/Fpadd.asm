;**************************************************************
; DESCRIPTION:
; FPADD - FLOATING POINT ADDITION SUBROUTINE
;
; REVISION HISTORY:
; Date           Change
; 10-07-1987     Initial placement
; 11-19-1998     Implementation on DSP56300 
;**************************************************************
fpadd   ident   1,0
;
; Entry points: fadd_xa R = A + X
;               fadd_xy R = Y + X
;
;       m = 24 bit mantissa (two's complement, normalized fraction)
;
;       e = 14 bit exponent (unsigned integer, biased by +8191)
;
; Input variables:
;
;   X   x1 = mx  (normalized)
;       x0 = ex
;
;   Y   y1 = my  (normalized)
;       y0 = ey
;
;   A   a2 = sign extension of ma
;       a1 = ma  (normalized)
;       a0 = zero
;
;       b2 = sign extension of ea (always zero)
;       b1 = ea
;       b0 = zero
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
; Error conditions:     Set CCR L=1 if floating point overflow.  Result
;                       is set to the maximum floating point value of the
;                       correct sign.  The CCR L bit remains set until
;                       cleared by the user.
;
;                       Set CCR L=1 if floating point underflow.  Result
;                       is set to floating point zero.  The CCR L bit
;                       remains set until cleared by the user.
;
; Assumes m0 and scaling modes initialized by previous call to the subroutine "fpinit".
;
; Alters Data ALU Registers
;       a2      a1      a0      a
;       b2      b1      b0      b
;       x1      x0      y1      y0
;
; Alters Program Control Registers
;       pc      sr
;
; Uses 0 locations on System Stack
;
;
fadd_xy tfr     y0,b    y1,a            ;get ey, my
fadd_xa cmp     x0,b    fp_space:fp_23,y0       ;compare delta = er - ea,
                                                ; get delta limit
        jge     _dpos                   ;jump if er >= ea
;
; er < ea
;
_dneg   tfr     x0,b    b1,x0           ;swap ea with er
	  tfr     x1,a    a1,x1           ;swap ma with mr
;
; er >= ea
;
_dpos   sub     x0,b    b1,y1           ;calculate delta, save er'
        cmp     y0,b               	    ;check delta limit
        jgt     done1                   ;jump if delta > 23
;
; normalize and round result - assumes a=mr', r0=er' and CCR reflects mr' value.
;
addm	  tfr	x1,b	b1,y0    
	  asr	y0,b,b				;denormalize by delta
	  add	b,a					;add mantissa
norm	  clb	a,b
	  normf	b1,a				;normalization
round   rnd     a 	b,y0   		;round to 24 bit mr
	  clb	a,b	
	  normf	b1,a				;correct mr overflow due to round
	  add		y1,b				
	  add		y0,b				;get final er
	  nop
;
; detect and correct exceptions - assumes a=mr and r0=er
;
check   jset    #15,b1,under      		;jump if exponent underflow
        jset    #14,b1,limit      		;jump if exponent overflow
check1  tst     a      				;check mr
        teq     a,b                     	;if mr=0, correct to fp zero
        rts
under   or      #$40,ccr                	;set L=1 for exponent underflow
zero    clr     a       #0,b            	;correct to fp zero
        rts
limit   asl     a       fp_space:fp_emax,y1     ;correct to maximum fp value
	  nop
done1   tfr     y1,b    a,a             	;get mr and er, set L bit if mr limited
done    rts
