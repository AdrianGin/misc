;**************************************************************
; DESCRIPTION:
; FPCEIL - FLOATING POINT CEIL SUBROUTINE
;
; REVISION HISTORY:
; Date           Change
; 02-22-1988     Initial placement
; 11-19-1998     Implementation on DSP56300 
;**************************************************************
fpceil  ident   1,0
;
; Entry points: fceil_a    R = ceil(A)
;               fceil_x    R = ceil(X)
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
; Error conditions:     No error conditions are signaled.
;
; Assumes m0 and scaling modes initialized by previous call to the subroutine "fpinit".
;
; Alters Data ALU Registers
;       a2      a1      a0      a
;       b2      b1      b0      b
;       x1      x0
;
; Alters Program Control Registers
;       pc      sr
;       ssh     ssl     sp
;
; Uses 1 location on System Stack
;
fceil_x tfr     	x0,b    x1,a            ;get mx,ex
	  nop
fceil_a
        neg     	a      	b,y1        ;reverse number line,save ea
	  clb		a,b
	  normf	b1,a	
	  add		y1,b				;normalize the input for the floor operation
        jsr     	floor_a                 ;do floor operation
        neg     	a       b,y1            ;reverse number line,save ea
	  clb		a,b
	  normf	b1,a	
	  add		y1,b				;normalize the output 
        rts
 
 
 
 
 
