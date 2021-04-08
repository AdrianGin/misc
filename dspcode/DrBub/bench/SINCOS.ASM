
;***********************************************************************
; Description:						               * 	
;  Sincos.asm                                                          *	
;        Sine-Cosine Table Generator for FFTs.    		       * 		
;***********************************************************************
; REVISION HISTORY:                                                    *
;   Date           Change                                              *
;   Last Update 25 Nov 86   Version 1.2                                *
;   Nov  10,1998    Implementation on DSP56300 	                       * 
;***********************************************************************


;
;       sincos  -       macro to generate sine and cosine coefficient
;                       lookup tables for Decimation in Time FFT
;                       twiddle factors.
;
;       points  -       number of points (2 - 32768, power of 2)
;       coef    -       base address of sine/cosine table
;                       negative cosine value in X memory
;                       negative sine value in Y memory

sincos  macro   points,coef
sincos  ident   1,2
pi      equ     3.141592654
freq    equ     2.0*pi/@cvf(points)

        org     x:coef
count   set     0
        dup     points/2
        dc      -@cos(@cvf(count)*freq)
count   set     count+1
        endm

        org     y:coef
count   set     0
        dup     points/2
        dc      -@sin(@cvf(count)*freq)
count   set     count+1
        endm

        endm    ;end of sincos macro
