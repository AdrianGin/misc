;
; This program originally available on the Motorola DSP bulletin board.
; It is provided under a DISCLAMER OF WARRANTY available from
; Motorola DSP Operation, 6501 Wm. Cannon Drive W., Austin, Tx., 78735.
; 
; Square Root by Polynomial Approximation, 7-bit Accuracy.
; (test program)
; 
; Last Update Mar 6,1998   Version 1.0
;
;
;       square root test program
;
        opt     cex
        page    132,66,0,0
        
        include 'sqrt1.asm'

datin   equ     $ffff           ;location in y memory of input file
datout  equ     $fffe           ;location in y memory of output file

        org     y:0
pcoef   dc      .5031642,-.2831102,.2726661

        org     p:$100
start
        
;
        do      #3,_e         ;number of points to do
        move    #pcoef,r1       ;point to poly coef
        move    y:datin,x0      ;get input value
;
        nop
        sqrt1
        nop
;
        move    a,y:datout      ;output square root
_e                     
        nop
return
        end
