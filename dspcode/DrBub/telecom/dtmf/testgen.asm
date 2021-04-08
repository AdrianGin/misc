;*******************************************************************
; DESCRIPTION:
; DTMF  (Dual Tone Multi-Frequency Generation): 
; This file contains the DTMF control flow (shell)
;
; REVISION HISTORY:
; Date          Change
; 06-08-1998    Implementation on DSP56300
;*******************************************************************

	SECTION TEST_GEN
	XREF    gen,gen_init
	PAGE    132,66,2,5
	TITLE   'DTMF control flow (shell)'
	OPT     RC,MEX,NOMD,CEX,XR
	IDENT   1,1
	INCLUDE 'DTMF_EQU.INC'
input   equ     $ffffff
output  equ     $fffffe

	ORG     P:
main                                     ; called by codec routine
	jsr     gen_init                 ; init DTMF generation
	do      #800,l_gen
	jsr     gen                     ; call generator
l_gen   
	nop

return
	nop
	ENDSEC
