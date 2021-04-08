;*******************************************************************
; DESCRIPTION:
; This file contains DTMF Detection tests module routines
;
; REVISION HISTORY:
; Date         Change
; 03-12-1996   Initial placement
; 06-08-1998   Implementation on DSP56300
;*******************************************************************
	SECTION TST
	PAGE    132,60,2,5
	TITLE   'DTMF Detection Tests module routines'
	OPT     RC,MEX,NOMD,CEX,XR
	IDENT   1,1
	NOLIST
	INCLUDE 'EQUX.ASM'
	INCLUDE 'DSX.ASM'
	INCLUDE 'DTMF_EQU.INC'
	INCLUDE 'TST.INC'
	INCLUDE 'COM.INC'
	LIST
	XDEF    tst,tst_init
output  equ     $ffff95
	ORG     P:
;*******************************************************************************
; Subroutine:   tst                                                            *
;                                                                              *
; Description:  This routine performs a series of tests (some of which are     *
;               optional) on detected tones to verify their compliance with    *
;               the ITU Q.23 and Q.24 specification. Confirmed valid digits    *
;               are converted from cos(freq) representation to actual digits   *
;               in the range 0-15 using a mapping rule.                        *
;                                                                              *
;*******************************************************************************
tst
	move    y:DET_s1,x0
	mpy     -x0,x0,a
	nop
	move    y:DET_s2,a a,x0
	add     x0,a
	asr     a   y:TST_Tx,y0         ;scale to match with Goertzel output
	move    a,y:TST_Ex a,x0         ;Ex = (1/2)*(s2 - s1^2)
	mpy     x0,y0,a
	nop
	move    a,y:TST_THI             ;THI = Tx * Ex

	clr     a                       ;Reset moments of x(n)
	nop
	move    a,y:DET_s1              ;s1 = 0
	move    a,y:DET_s2              ;s2 = 0

;==============================
;           Minimum Energy Test
;==============================
	move    y:TST_Ex,a
	move    y:TST_ExMin,x0
	cmp     x0,a                    ;Ex - TST_ExMin
	jlt     clr_TD                  ;If Ex < ExMin Then Exit

;==============================
;                Ef1 + Ef2 Test
;==============================
	move    #DET_DaTbl,r1           ;y:(r1) = DaTbl[0] = A1
	move    #4,n4                   ;n4 = 4
	clr     a                       ;Ef1 = 0

	Do      n4,k1_loop              ;For k1=0 to 3
	  move  y:(r1),y0               ;  y0 = A[k]  (Goertzel Energy)
	  cmp   y0,a                    ;  Ef1 - A[k]
	  jgt   not_max_1               ;  If Ef1 <= A[k] Then
	  move  y0,a                    ;    Ef1 = A[k]
	  move  r1,r3                   ;    r3 = 2*k1 + base addr of DaTbl
not_max_1                               ;  Endif
	  move  (r1)+
k1_loop                                 ;EndFor

	move    a,x0                    ;x0 = Ef1
	clr     a                       ;Ef2 = 0

	Do      n4,k2_loop              ;For k2=4 to 7
	  move  y:(r1),y0               ;  y0 = A[k]  (Goertzel Energy)
	  cmp   y0,a                    ;  Ef2 - A[k]
	  jgt   not_max_2               ;  If Ef2 <= A[k] Then
	  move  y0,a                    ;    Ef2 = A[k]
	  move  r1,r4                   ;    r4 = 2*k2 + base addr of DaTbl
not_max_2                               ;  Endif
	  move  (r1)+
k2_loop                                 ;EndFor

	move    a,x1                    ;x1 = Ef2
	add     x0,a    y:TST_THI,y0            
	cmp     y0,a                    ;(Ef1+Ef2) - THI
					
	jlt     clr_TD                  ;If (Ef1+Ef2) < Tx*Ex Then Exit

;==============================
;                    Twist Test
;==============================
	jset    #TST_TD,y:TST_Flag,DoneTwTst   ;IF (TD = 1) Then skip test
					; (this acts like hysterisis)
	move    x1,a                    
	cmp     x0,a                    ;  Ef2 - Ef1
					
	jlt     Bck_Twist               ;  If (Ef2 > Ef1) Then
	  move y:TST_FTws,y0            ;
	  mpy   x1,y0,a                 ;
	  cmp   x0,a                    ;    FTws*Ef2 - Ef1
	  jgt   clr_TD                  ;    If (FTws*Ef2 > Ef1) Then Exit
	  jmp   DoneTwTst
Bck_Twist                               ;  Else
	  move y:TST_BTws,y0            ;
	  mpy  x0,y0,a                  ;
	  cmp  x1,a                     ;    BTws*Ef1 - Ef2
	  jgt  clr_TD                   ;    If (BTws*Ef1 > Ef2) Then Exit
					;  Endif
DoneTwTst
;==============================
;             2nd Harmonic Test
;==============================
	move    y:TST_Config,y0
	jclr    #TST_SH,y0,last_test    ;If SH = 0 then skip 2nd Harmonic Tst

	  move #8,n3
	  nop
	  nop
	  nop
	  move y:(r3),x0                ;  Second Harmonic Test
	  move y:TST_TL12,y0            ;  Low Bank
	  mpy  x0,y0,a          
	  move y:(r3+n3),x0
	  cmp  x0,a                     ;  TL12*Ef1 - Ef1_2H
	  jlt  clr_TD                   ;  If (TL12*Ef1 < Ef1_2H) Then Exit

	  move #8,n4
	  nop
	  nop
	  nop
	  move y:(r4),x0                ;  Second Harmonic Test
	  move y:TST_TL22,y0            ;  High Bank
	  mpy  x0,y0,a          
	  move y:(r4+n4),x0
	  cmp  x0,a                     ;  TL22*Ef2 - Ef2_2H
	  jlt  clr_TD                   ;  If (TL22*Ef2 < Ef2_2H) Then Exit
last_test
;==============================
;        Background Energy Test
;==============================
	  move  #DET_DaTbl,r1           ;  y:(r1) = DaTbl[0] = A1
	  move  #4,n4                   ;  n4 = 4

	  move  y:(r3),x0
	  move  y:TST_TL1,y0
	  mpy   x0,y0,a                 ;  a = TL1 * Ef1
	  move  r3,b                    ;  r3=k1_Ef1, DaTbl[r3] = Ef1
	  move  #0,y1                   ;  y1 = Fail Flag (0 = pass)
	  
	  Do    n4,k1_loop2             ;  For k1=0 to 3
	    move r1,x0                  ;
	    cmp x0,b                    ;

	    jeq skip_cmp1               ;    If k1 <> k1_Ef1 Then
	      move y:(r1),y0            ;      y0 = A[k]  (Goertzel Energy)
	      cmp y0,a                  ;      TL1*Ef1 - A[k]

	      jgt skip_cmp1             ;      jump to pass
	      bset #0,y1                ;      If TL1*Ef1 < A[k] Fail=1
skip_cmp1                               ;    Endif
	    move (r1)+
k1_loop2                                ;  EndFor

	  jset  #0,y1,clr_TD            ;  If Fail Flag = 1 Then exit

	  move  y:(r4),x0
	  move  y:TST_TL2,y0
	  mpy   x0,y0,a                 ;  a = TL2 * Ef2
	  move  r4,b                    ;  r4=k2_Ef2, DaTbl[r2] = Ef2
	  move  #0,y1                   ;  y1 = Fail Flag (0 = pass)

	  Do    n4,k2_loop2             ;  For k1=4 to 7
	    move r1,x0                  ;
	    cmp x0,b                    ;

	    jeq skip_cmp2               ;    If k2 <> k2_Ef2 Then
	      move y:(r1),y0            ;      y0 = A[k]  (Goertzel Energy)
	      cmp y0,a                  ;      TL2*Ef2 - A[k]

	      jgt skip_cmp2             ;      jump to pass
	      bset #0,y1                ;      If TL2*Ef2 < A[k] Fail=1
skip_cmp2                               ;    Endif
	    move (r1)+
k2_loop2                                ;  EndFor

	  jset  #0,y1,clr_TD            ;  If Fail Flag = 1 Then exit

;=============================
;***   All Tests Passed    ***
;***  DTMF Tone Detected   ***
;=============================
	  
;==============================
;     If this is a new tone, 
;     enter it in the InTbl
;==============================
	jset    #TST_TD,y:TST_Flag,DT_done     ;IF (TD = 0) Then
	  bset  #TST_TD,y:TST_Flag             ;  TD = 1
	  
	  move  #DET_DaTbl,n3
	  move  #DET_DaTbl,n4
	  move  (r3)-n3                 ;  r3 = k1 + base addr of DaTbl
	  nop
	  move  (r4)-n4                 ;  r4 = k2 + base addr of DaTbl
	  move  #COM_DfTbl,n3
	  move  #COM_DfTbl,n4
	  move  (r3)+n3                 ;  r3 = k1 + base addr of DfTbl
	  nop
	  move  (r4)+n4                 ;  r4 = k2 + base addr of DfTbl

	  move  x:TST_kDT,r0            ;  r0 = kDT
	  move  y:(r3),x0               ;  x0 = c1[k1] = DfTbl[2,k1]
	  move  y:(r4),y0               ;  y0 = c2[k2] = DfTbl[2,k2]
	  decode x0,y0
	  move  a,y:(r0)+               ;  InTbl[kDT] = decode(x0,y0)
	  move  a,x:output
	  move  r0,x:TST_kDT            ;  save kDT
	  jmp   DT_done
clr_TD  
	bclr    #TST_TD,y:TST_Flag             ;TD = 0
DT_done
	
;========================================
;    Update ND if user has changed SH
;========================================
	move    y:TST_Config,a          ;SH (second harmonic flag bit)
	jclr    #TST_SH,a,no_2nd_harm   ;    0 = don't test 2nd harmonic
					;    1 = test 2nd harmonic
	  move  #>16,a
	  move  a,y:DET_ND              ;ND = 16
	  jmp   DTMF_Exit
no_2nd_harm
	  move  #>8,a
	  move  a,y:DET_ND              ;ND = 8

DTMF_Exit
	rts

;*******************************************************************************
; Subroutine:   tst_init                                                       *
;                                                                              *
; Description:  TST module initialization block, executed once each time       *
;               DTMF restarts.                                                 *
;                                                                              *
;*******************************************************************************
tst_init
	move    #TST_START,r1           ; set default parameter values
	move    #TST_DEF,r4             ;   from "TST.INC"
	do      #TST_SIZE,init1         ;
	move    y:(r4)+,a               ;
	nop
	move    a,y:(r1)+               ;
init1   clr     a                       ;
	move    #TST_InTbl,r1           ; kDT = InTbl
	move    r1,x:TST_kDT            ;
	do      #TST_DTMax,init2        ; zero InTbl
	move    a,y:(r1)+               ;
init2   bclr    #TST_TD,y:TST_Flag      ;set TD bit in Flag
	rts
	ENDSEC
