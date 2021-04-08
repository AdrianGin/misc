;
; This program originally available on the Motorola DSP bulletin board.
; It is provided under a DISCLAMER OF WARRANTY available from
; Motorola DSP Operation, 6501 Wm. Cannon Drive W., Austin, Tx., 78735.
; 
; Companded CODEC to/from Linear Data Conversion Test Program
; 
; Last Update 12 Mar 1998   Version 1.0
;
    page        132
loglint ident   1,0
;
; Latest Revision - Mar 12,1998
; Tested and verified - Mar 12,1998
;
	opt     mex
	nolist
	include '../loglin.asm'
	include '../linlog.asm'
	list
;
; Cold start (reset)
;
input   equ     $ffffff
output  equ     $fffffe

	org     p:0
	jmp     <start
	org     p:$100
start   

;
; Convert  sign magnitude to linear conversion
;
	do #16,l_rep
	move    x:input,a1

		allin

	move    a1,x:output
	move    a0,x:output
l_rep
	nop
return
	end     start
