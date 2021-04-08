;**********************************************************************
; Description:                                                        *
;  7-563.asm                                                          *     
;    DSP56300 Dot Product                                             *
;                                                                     *
;**********************************************************************
;  REVISION HISTORY:                                                  *
;   Date           Change                                             *
;   June 30,1988    Initial placement                                 *
;   Aug  24,1998    Implementation on DSP56300 	                      * 
;**********************************************************************
;
;       This routine performs the scalar product of two
;       [2x1] vectors on the DSP56000. 
;
;       Vector a is in X memory, 
;       vector b is in Y memory, 
;       the result z is stored in X memory.
;
;
;
;     X Memory                     Y Memory
;
; |  | x2 |          |->|  y2 |
; |->| x1 |          |->|  y1 |
; r0 |    |          r0 |     |
;
; |->| z  |              
;
;
;Note: the previous assumes that all immediate addressing is
;immediate short, i.e. all data is in internal memory.
;
;**************************************************************************



veca    equ     $010
z       equ     $010
start	equ	$000100
        org     x:veca
        dc      $600000
        dc      $400000

        org     y:veca
        dc      $300000
        dc      $100000

        org     p:start
;************************************************************
        move #<veca,r0                   ;point to vectors a,b
        move #<z,r1                      ;point to z
        nop
        nop  
        move            l:(r0)+,x       ;load first elements.
        mpy  x0,x1,a    l:(r0)+,x       ;a1*b1
        macr x0,x1,a                    ;+a2*b2
        nop
        move            a,x:(r1)        ;--> z
;*************************************************************
        end
