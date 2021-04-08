;
; This program originally available on the Motorola DSP bulletin board.
; It is provided under a DISCLAMER OF WARRANTY available from
; Motorola DSP Operation, 6501 Wm. Cannon Drive W., Austin, Tx., 78735.
; 
; Full Precision Square Root by Polynomial Approximation. (test program)
; 
; Last Update 06 Mar 1998   Version 1.0
;
sqrt3t  ident   1,0
;
;       square root test program
;
        opt     cex
        page    132,66,0,0
        include 'sqrt3.asm'

datin   equ     $ffff     
datout  equ     $fffe     

        org     p:$100
start   ;movep   #0,x:M_BCR      ;no wait states on external io
        move    #<$0,y0         ;clear ls input word
        do      #3,loop         ;number of points to do
        move    y:datin,y1      ;get input value
        sqrt3                   ;do 24 bit sqrt
        move    b,y:datout      ;output square root
loop                     
        nop 
return        
        end
