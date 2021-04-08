;
; This program originally available on the Motorola DSP bulletin board.
; It is provided under a DISCLAMER OF WARRANTY available from
; Motorola DSP Operation, 6501 Wm. Cannon Drive W., Austin, Tx., 78735.
; 
; LOG2NRM Macro Test Program
; 
; Last Update 30 Mar 87   Version 1.0
;
; This is a test program demonstrating the use of the LOG2NRM macro.
;
log2nrmt        ident   1,0
        opt     cex
        page    132,66,0,0
 
        include 'log2nrm.asm'

datin   equ     $ffff 
datout  equ     $fffe 

        org     y:0
pcoef   dc      .9981958,-.3372223,-.6626105    ;a1,a2,a0

        org     p:$100
start
        

        do      #3,_e         ;number of points to do
        move    #pcoef,r1       ;point to poly coef
        move    y:datin,a       ;get input value
;
        nop        
        log2nrm                 ;take log2 of a
        nop        
;
        move    a,y:datout
_e
        nop
return
        end
