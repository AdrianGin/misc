;**************************************************************
; DESCRIPTION:
; FPSCALE - FLOATING POINT SCALING SUBROUTINE
;
; REVISION HISTORY:
; Date           Change
; 10-05-1987     Initial placement
; 11-19-1998     Implementation on DSP56300 
;**************************************************************
;
fpscale ident   1,0
;
; Entry points: fscal_xa        R = A * 2**X
;               fscal_xy        R = Y * 2**X
;
;       m = 24 bit mantissa (two's complement, normalized fraction)
;
;       e = 14 bit exponent (unsigned integer, biased by +8191)
;
; Input variables:
;
;   X   x0 = ex
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
; Alters Address Registers
;
; Alters Program Control Registers
;       pc      sr
;
; Uses 0 locations on System Stack
;
;
fscal_xy        tfr     y0,b    y1,a    ;get ey, my
fscal_xa        add     x0,b            ;add scale factor to ea
        	    jmp     check           ;check for exponent errors
