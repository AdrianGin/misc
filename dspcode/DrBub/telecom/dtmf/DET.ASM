;****************************************************************
; DESCRIPTION:
; This file contains DTMF Detection module routines
;
; REVISION HISTORY:
; Date          Change
; 03-12-1996    Initial placement 
; 06-08-1998    Implementation on DSP56300
;****************************************************************

	SECTION DET
	
	PAGE    132,60,2,5
	TITLE   'DTMF Detection module routines'
	OPT     RC,MEX,NOMD,CEX,XR
	IDENT   1,1
	NOLIST
	INCLUDE 'EQUX.ASM'
	INCLUDE 'DSX.ASM'
	INCLUDE 'DTMF_EQU.INC'
	INCLUDE 'DET.INC'
	LIST
	XDEF    det,det_init
	ORG     P:
;*******************************************************************************
; Subroutine:   det                                                            *
;                                                                              *
; Description:  This routine detects DTMF digits by applying the Goertzel      *
;               detector to each tone, and optionally to the 2nd harmonic      *
;               (for protection against false detection during speech).        *
;                                                                              *
;*******************************************************************************
input   equ     $ffff98
output  equ     $ffff95
det
	move    #COM_DfTbl,r2

	move    y:DET_ND,a              ;a = ND
	tst     a
	jeq     skip_to_exit            ;if ND=0 skip detector processing.      

	move    y:DET_InvM,x0           ;x0 = 1/M
	movep   x:input,y0
	
;        move    y:DET_xn,y0             ;y0 = x(n) 
	mpy     x0,y0,a                 ;a = x(n)/M
	move    y0,y:DET_xn
	move    a,y:DET_vn              ;vn = x(n)/M

	jsr     GOERT                   ;perform one step of detector
					;  process for all ND frequencies.
skip_to_exit

;--- update 1st & 2nd Moments of x(n) ---

	move    y:DET_xn,x0
	mpyr    x0,x0,b y:DET_s1,a
	move    y:DET_InvM,y0
	macr    x0,y0,a y:DET_s2,b b,x0
	macr    x0,y0,b a,y:DET_s1      ; s1 = s1 + (1/M)*x(n)
	move    b,y:DET_s2              ; s2 = s2 + (1/M)*(x(n)^2)
	rts

;===================================================================
	page
;*******************************************************************
; Goertzel Sinusoid Detector
;-------------------------------------------------------------------    
GOERT
	jclr    #DET_INIT,y:DET_Flag,skip_InitDtc  ;if bit INIT of Flag is set,
						   ; initialize detectors.
	move    #DET_Q1,r4              ;base address of Q1[k]
	move    #DET_Q2,r5              ;base address of Q2[k]
	move    y:DET_ND,n2             ;n2 = ND
	clr     a                       ;a = 0

	do      n2,loop_InitDtc         ;loop for k=1 to ND
	  move  a,x:(r4)+               ;Q1[k] = 0
	  move  a,x:(r5)+               ;Q2[k] = 0
loop_InitDtc

	bclr    #DET_INIT,y:DET_Flag    ;clr bit INIT of Flag to indicate
					;initialization was performed.
	move    y:DET_M,r7              ;r7 = Dcnt (Goert block count).
	move    r7,y:DET_Dcnt

skip_InitDtc
	move    y:DET_Dcnt,r7
	move    r7,a
	tst     a                       ;Dcnt = 0 ?
	jeq     skip_goert              ;if Dcnt = 0, skip goertzel.

	move    (r7)-                   ;Dcnt = Dcnt - 1
	move    r7,y:DET_Dcnt           

	move    y:DET_ND,n2             ;n2 = ND
	move    #COM_DfTbl,r2           ;address of DfTbl[2] = c1
	move    #DET_Q1,r4              ;base address of Q1[k]
	move    #DET_Q2,r5              ;base address of Q2[k]
	move    y:DET_vn,y1             ;a = vn = xn/M

	do      n2,loop_dtc             ;loop for k=1 to ND
	  move  x:(r4),x0  y:(r2)+,y0   ;y0 = c[k]; x0 = Q1[k]
	  mpy   x0,y0,a x:(r5),x1       ;a = Q1[k]*c[k]; x1 = Q2[k]
	  asl   a                       ;a=2*c[k]*Q1[k]
	  sub   x1,a    x0,x:(r5)+      ;a=2*c[k]*Q1[k]-Q2[k];Q2[k]=Q1[k]
	  add   y1,a                    ;a = vn + 2*c[k]*Q1[k] - Q2[k]
	  nop
	  move  a,x:(r4)+               ;Q1[k] = vn+2*Q1[k]*c[k]-Q2[k]
loop_dtc
	nop
skip_goert

	move    r7,a
	tst     a                       ;Dcnt = 0 ?
	jne     skip_mag                ;if Dcnt = 0, calc. magnitude.

	move    #COM_DfTbl,r2           ;address of DfTbl[0] = c1
	move    #DET_DaTbl,r7           ;address of DaTbl[0]
	move    #DET_Q1,r4              ;base address of Q1[k]
	move    #DET_Q2,r5              ;base address of Q2[k]

	do      n2,loop_mag             ;loop for k=1 to ND
	  move  x:(r4)+,x0  y:(r2)+,y0  ;y0 = c[k]; x0 = Q1[k]
	  move  x:(r5)+,x1              ;x1 = Q2[k].
	  mpy   x0,x1,a                 ;a=Q1[k]*Q2[k]
	  nop
	  move  a,y1                    ;y1 = Q1[k]*Q2[k]
	  mpy   -y0,y1,a                ;a = -c[k]*Q1[k]*Q2[k] 
	  asl   a        x1,y1          ;a = -2*ck*Q1*Q2; y1 = Q2  
	  mac   x0,x0,a                 ;a = Q1^2 - 2*ck*Q1*Q2 
	  macr  x1,y1,a                 ;a = Q1^2 + Q2^2 - 2*ck*Q1*Q2 
	  nop
	  move  a,y:(r7)+               ;DaTbl[k] = a (magnitude)
loop_mag
	bset    #DET_INIT,y:DET_Flag    ;set bit INIT of Flag to indicate
					;done with goertzel and ready
skip_mag                                ;for next initialization.
	rts

;*******************************************************************************
; Subroutine:   det_init                                                       *
;                                                                              *
; Description:  DET module initialization block, executed once each time       *
;               DTMF restarts.                                                 *
;                                                                              *
;*******************************************************************************
det_init
	move    #DET_START,r1           ;set default parameter values
	move    #DET_DEF,r4             ;  from "DET.INC"

	do      #DET_SIZE,init1
	  move    y:(r4)+,A
	  nop
	  move    A,y:(r1)+
init1  
	move    #$ffff,m2               ;linear addressing
	move    #COM_DfTbl,r2
	move    #DET_DaTbl,r4           

	move    y:TST_Config,a          ;SH (second harmonic flag bit)
	jclr    #TST_SH,a,No_2nd_Harm   ;    0 = don't test 2nd harmonic
					;    1 = test 2nd harmonic
	  move  #>16,y0
	  move  y0,y:DET_ND             ;ND = 16
	  jmp   clr_DaTbl               
No_2nd_Harm
	  move  #>8,y0
	  move  y0,y:DET_ND             ;ND = 8
clr_DaTbl
	clr     a
	nop
	move    a,y:DET_Dcnt            ;Dcnt = 0
	move    a,y:DET_s1              ;s1 = 0
	move    a,y:DET_s2              ;s2 = 0
					;clear DaTbl
	do      y0,clr_datbl            ;for k=1 to ND
	  move  a,y:(r4)+               ;A[k] = 0
clr_datbl

	clr     b
	move    #>1,b1                  ;b = 00 000001 000000
	move    y:DET_M,y1              ;y1 = M
	jsr     DIVIDE
	move    b,y:DET_InvM            ;y1 = 1/M


	rts
;===================================================================

;*******************************************************************
;DIVIDE
;  Input:  y1  and  b
; Output:  b=b/y1
;-------------------------------------------------------------------    
DIVIDE
	and     #$fe,ccr
	rep     #$18
	div     y1,b
	move    b0,b1
	move    #0,b2

	rts
;===================================================================

	ENDSEC
