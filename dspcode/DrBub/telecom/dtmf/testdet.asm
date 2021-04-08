;*****************************************************************
; DESCRIPTION:
; DTMF (Dual Tone Multi-Frequency Detection & Generation):
; This file contains DTMF Detection module routines
;
; REVISION HISTORY:
; Date          Change
; 06-08-1998    Implementation on DSP56300
;*****************************************************************

	SECTION DTMF_SHELL


	PAGE    132,66,2,5
	TITLE   'DTMF control flow (shell)'
	OPT     RC,MEX,NOMD,CEX,XR
	IDENT   1,1
	INCLUDE 'DTMF_EQU.INC'
input   equ     $ffffff
output  equ     $fffffe

	ORG     P:
main                                     ; called by codec routine
	movec   #0,sp
	move    #$ffff,m0               ; linear addressing
	move    m0,m1
	move    m0,m2
	move    m0,m4
	move    m0,m5
	move    m0,m7

	jsr     det_init                 ; init DTMF detection
	jsr     tst_init                 ; init DTMF test rules

;*******************************************************************
;
; MAIN PROGRAM LOOP
;        
;*******************************************************************

	do      #1,l_loop1
	


	do      #400,l_det
	jsr     det                     ; call detector
	move    y:DET_Flag,x0           ;
	jsset   #DET_INIT,x0,tst        ; optionally call detector tests
l_det   
	 nop
l_loop1: nop

return:   stop

	ENDSEC
