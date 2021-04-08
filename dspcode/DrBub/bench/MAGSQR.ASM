;***********************************************************************
; Description:        						       * 	
;  Magsqr.asm							       *	     
;	MAGSQR Magnitude Squared Macro.          		       * 		
;***********************************************************************
; REVISION HISTORY:                                                    *
;   Date           Change                                              *
;   Update      25 Nov 86                                              *
;   Nov  10,1998    Implementation on DSP56300 	                       * 
;***********************************************************************

; x1 = real input
; x0 = imaginary input
; a  = real*real + imag*imag   (unrounded, double precision output)

magsqr macro
magsqr ident   1,0
magsqr  mpy     x0,x0,a         x1,x0   ;imag*imag
        mac     x0,x0,a                 ;+real*real
        endm
