;**************************************************************
; DESCRIPTION:
; FPSQRT - FLOATING POINT SQUARE ROOT SUBROUTINE
;
; REVISION HISTORY:
; Date           Change
; 10-05-1987     Initial placement
; 11-19-1998     Implementation on DSP56300 
;**************************************************************
fpsqrt  ident   1,0
;
; Entry points: fsqrt_a R = square root(A)
;               fsqrt_x R = square root(X)
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
; Error conditions:     Set CCR L=1 if input value is negative.  Result
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
; Alters Address Registers
;
; Alters Program Control Registers
;       pc      sr
;       la      lc
;       ssh     ssl     sp
;
; Uses 2 locations on System Stack
;
;
fsqrt_x tfr     x0,b    x1,a            		;get mx,ex
fsqrt_a tst     a       fp_space:fp_ebias,x0    ;check for negative input
        jmi     under                   		;jump if negative, set L bit
        jeq     done                    		;jump if zero
        sub     x0,b                    		;remove ebias from ea
        asr     b       #<$40,y0        		;er' = ea / 2, get first guess
        jclr    #23,b0,_sqrt1                  	;jump if er' even
        asr     a       fp_space:fp_m1,x1       ;divide ma by 2, get -1
        sub     x1,b                    		;increment er' by 1
_sqrt1  add     x0,b    y0,x0           		;add ebias to er', save first temp
	  move    a,x1			    		;save ma
        clr     b       b,r0            		;clear root, save er'
        do      #23,_sqrt2              		;square all 23 bits
        mac     -x0,x0,a            		;square temp
        tge     x0,b                    		;update root if correct guess
	  mpy     y0,#1,a					;try next bit
	  nop
        add     b,a     a,y0            		;form root guess, save guess bit
	  nop
        tfr     x1,a    a,x0            		;get ma, save temp
_sqrt2
        tfr     b,a     r0,b            		;get root mr, er
        rts
