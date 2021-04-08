;
; This program originally available on the Motorola DSP bulletin board.
; It is provided under a DISCLAMER OF WARRANTY available from
; Motorola DSP Operation, 6501 Wm. Cannon Drive W., Austin, Tx., 78735.
; 
; Square Root by Polynomial Approximation, 10-bit Accuracy.
; (test program)
; 
; Last Update 6 Mar 1998   Version 1.0
;
        opt     cex
        page    132,66,0,0
        
        include 'sqrt2.asm'

datin   equ     $ffff           
datout  equ     $fffe           

        org     y:0
pcoef   dc      .8803385,-.1985987,.3185231     ;a1,a2,a0

        org     p:$100
start
;
        do      #3,_e         ;number of points to do
        move    #pcoef,r1       ;point to poly coef
        move    y:datin,x0      ;get input value
;
        nop
        sqrt2                   ;do square root
        nop
;
        move    a,y:datout
_e
        nop
return

        end
