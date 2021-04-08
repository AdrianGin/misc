;******************************************************************************
; COPYRIGHT:    Copyright 1996 Motorola. All rights reserved.
;
; Description:  This file contains DTMF Detection module register set
;
; Revision History:
; Revision 1.0  30-12-1996  17:09
; Initial placement
;******************************************************************************
;--- R/O parameters ---
        ORG     Y:
        equx    TST_START,*
        dsx     TST_Config,1 ;bit 0, SH = 2nd harm. det. (0-disabled, 1-enabled)
        dsx     TST_ExMin,1  ;Minimum Ex for a detection
        dsx     TST_Tx,1     ;(Ef1+Ef2) > Tx*Ex  for a detection
        dsx     TST_TL1,1    ;low bank threshold for adjacent energies
        dsx     TST_TL2,1    ;high bank threshold for adjacent energies
        dsx     TST_TL12,1   ;2nd Harmonic Threshold (low bank)
        dsx     TST_TL22,1   ;2nd Harmonic Threshold (high bank)
        dsx     TST_FTws,1   ;Forward Twist = -4 dB
        dsx     TST_BTws,1   ;Backward Twist = -8 dB
        equx    TST_SIZE,*-TST_START

;--- R/O parameter defaults ---
        equx    TST_DEF,*
        dc      1                       ; TST_Config
        dc      0.0001                  ; TST_ExMin
        dc      0.35                    ; TST_Tx
        dc      0.2                     ; TST_TL1
        dc      0.2                     ; TST_TL2
        dc      0.2                     ; TST_TL12
        dc      0.2                     ; TST_TL22
        dc      @pow(10,(-4./10.))      ; TST_FTws
        dc      @pow(10,(-8./10.))      ; TST_BTws

;*******************************************************************
; Variables  (y: memory)
;-------------------------------------------------------------------
        dsx     TST_Flag,1              ; Tests flag (bit 0 used for hystersis)
        dsx     TST_Ex,1                ; Ex = s2 - s1^2 (energy in {x(n)-xDC})
        dsx     TST_THI,1               ; Tx*Ex
        dsx     TST_InTbl,TST_DTMax     ; list of input digits (detected)
;****************************************************************
; Variables  (x: memory)
;----------------------------------------------------------------
        ORG     X:
        dsx     TST_kDT,1		;index to InTbl detected tone pairs
