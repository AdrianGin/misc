;**************************************************************
; DESCRIPTION:
; FPFIX - FLOATING POINT TO FIXED POINT CONVERSION SUBROUTINE
;
; REVISION HISTORY:
; Date           Change
; 10-05-1987     Initial placement
; 11-19-1998     Implementation on DSP56300 
;**************************************************************
fpfix   ident   1,0
;
; Entry points: fix_a   D = fix(A)
;               fix_x   D = fix(X)
;
;       m = 24 bit mantissa (two's complement, normalized fraction)
;
;       e = 14 bit exponent (unsigned integer, biased by +8191)
;
;       data = 56 bit fixed point data in standard integer/fractional
;              accumulator data representation.
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
;   D    a = data
;
; Error conditions:     Set CCR L=1 if conversion overflow error.  That is,
;                       the input value was larger than +/- 256 and could
;                       not be represented in the standard 56 bit accumulator
;                       format.  Result is the maximum 56 bit fixed point
;                       value having the same sign as the floating point
;                       mantissa.  The CCR L bit remains set until cleared
;                       by the user.
;
; Assumes m0 and scaling modes initialized by previous call to the subroutine "fpinit".
;
; Alters Data ALU Registers
;       a2      a1      a0      a
;       b2      b1      b0      b
;               x0      y1
;
; Alters Program Control Registers
;       pc      sr
;
; Uses 0 locations on System Stack
;
;
fix_x   tfr     x0,b    x1,a            ;get mx,ex
fix_a   tst     a       fp_space:fp_ebias,x0    ;check ma, get bias
        jeq     done                    ;jump if ma = 0
        sub     x0,b    #>8,x0          ;remove ea bias, get shift limit
        jlt     _eneg                   ;jump if exponent < 0
        jeq     done                    ;jump if exponent = 0
;
; exponent > 0
;
        cmp     x0,b                    ;check left shift limit
        jgt     _ehigh                  ;jump if exponent > 8
	  asl	    b1,a,a			    ;shift left b bits
        rts
_ehigh  or      #$40,ccr                ;set L=1 for conversion overflow
        tst     a                       ;check sign of ma
        jpl     _fix1                   ;jump if ma positive
        clr     a                       ;limit to maximum negative 56 bit value
        move    #$80,a2                 ;set extension word
        rts
_fix1   clr     a                       ;limit to maximum positive 56 bit value
        not     a    		          ;set most significant word
	  nop
        move    a1,a0                   ;set least significant word
        move    #$7f,a2                 ;set extension word
        rts
;
; exponent < 0
;
_eneg	  abs	    b		#>48,x0	    ;fix exponent, get right shift limit
	  cmp	    x0,b			    ;check right shift limit
	  jge	    zero			    ;jump if exponent >= 48
	  asr	    b1,a,a			    ;shift right b bits
	  rts	
