;***********************************************************************
; Description:            					       * 	
;  Sqrt3.asm							       *	
;	Full 23 bit precision square root routine using                *
;       a successive approximation technique.		               * 		
;***********************************************************************
; REVISION HISTORY:                                                    *
;    Date           Change                                             *
;    Update 09 Feb 87   Version 1.0				       *
;    Nov  10,1998    Implementation on DSP56300 	               * 
;***********************************************************************
; SQRT3 Macro
; y  = double precision (48 bit) positive input number
; b  = 24 bit output root
;
; a  = temporary storage
; x0 = guess
; x1 = bit being tested
; y1:y0 = input number

sqrt3   macro
sqrt3   ident   1,0

 
sqrt3
        clr     b    #<$40,x0           ; init root and guess
        move          x0,x1             ; init bit to tes
  do    #23,_endl                       ;START OF LOOP
        mpy     -x0,x0,a                ; square and negate the guess
        add     y,a                     ; compare to double precision input
        tge     x0,b                    ; update root if input >= guess
        mpy    x1,#1,a       
        nop
        add     b,a     a,x1            ; form new guess
        nop
        move                    a,x0            ; save new guess
        
_endl                                    ;END OF LOOP
        endm
