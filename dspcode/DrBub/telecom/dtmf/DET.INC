;******************************************************************************
; COPYRIGHT:    Copyright 1996 Motorola. All rights reserved.
;
; Description:  This file contains DTMF Detection module register set
;
; Revision History:
; Revision 1.0  30-12-1996  17:11
; Initial placement
;******************************************************************************

;--- R/O parameters ---
        ORG     Y:
        equx    DET_START,*
        dsx     DET_M,1                 ; Goertzel block size
        equx    DET_SIZE,*-DET_START

;--- R/O parameter defaults ---
        equx    DET_DEF,*
        dc      200                     ; DET_M
	  
;*******************************************************************
; Variables  (y: memory)
;-------------------------------------------------------------------
        dsx     DET_Flag,1              ; Detector flag
        dsx     DET_DaTbl,DET_Max_ND    ; Detector amplitude table, set by DSP
        dsx     DET_ND,1                ; Number of Detectors
        dsx     DET_InvM,1              ; 1/M
        dsx     DET_Dcnt,1              ; Goertzel block count (Dcnt<=M)
        dsx     DET_xn,1                ; x(n)
        dsx     DET_vn,1                ; v(n) = x(n)/M
        dsx     DET_s1,1                ; sum[x(n),{n,0,M-1}]*InvM
        dsx     DET_s2,1                ; sum[x(n)^2,{n,0,M-1}]*InvM

;****************************************************************
; Variables  (x: memory)
;----------------------------------------------------------------
        ORG     X:
        dsx     DET_Q1,DET_Max_ND	;Qk(n-1) detector states.
        dsx     DET_Q2,DET_Max_ND	;Qk(n-2) detector states.
