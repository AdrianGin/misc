;
; This program originally available on the Motorola DSP bulletin board.
; It is provided under a DISCLAMER OF WARRANTY available from
; Motorola DSP Operation, 6501 Wm. Cannon Drive W., Austin, Tx., 78735.
; 
; Exponential Base 2 by Polynomial Approximation.  (test program)
; 
; Last Update Mar 5,1998   Version 1.0
;
	opt     cex
	page    132,66,0,0
	
		include 'exp2.asm'

datin   equ     $ffffff           
datout  equ     $fffffe           

	org     y:0
pcoef   dc      .6674432,.1713425,.9979554      ;a1,a2,a0

	org     p:$100
start
	
;
	do      #3,loop        
	move    #pcoef,r1       ;point to poly coef
	move    y:datin,x0      ;get input value
	nop
;
	exp2
;
	nop
	move   a,y:datout
loop
	nop
return

	end
