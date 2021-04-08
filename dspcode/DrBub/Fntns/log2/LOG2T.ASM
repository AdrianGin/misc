;
; This program originally available on the Motorola DSP bulletin board.
; It is provided under a DISCLAMER OF WARRANTY available from
; Motorola DSP Operation, 6501 Wm. Cannon Drive W., Austin, Tx., 78735.
; 
; Logarithm Base 2 by Polynomial Approximation.  (test program)
; 
; Last Update Mar.5,1998
;
	opt     cex
	page    132,66,0,0
	include 'log2.asm'

datin   equ     $f000          
datout  equ     $f002          

	org     y:0
pcoef   dc      .9981958,-.3372223,-.6626105    ;a1,a2,a0

	org     p:$100
start

	do      #3,loop
	move    #pcoef,r1       ;point to poly coef
	move    y:datin,x0      ;get input value
	nop
	log2                    ;take log2 of x0
	nop
	move    a,y:datout
loop
	nop
return
	end
