;******************************************************************************
; COPYRIGHT:    Copyright 1996 Motorola. All rights reserved.
;
; Description:  This file contains DTMF Generation module register set
;
; Revision History:
; Revision 1.0  30-12-1996  17:13
; Initial placement
;******************************************************************************

;--- R/O parameters ---
        ORG     Y:
        equx    GEN_START,*
        dsx     GEN_on_time,1           ; on time (samples)
        dsx     GEN_off_time,1          ; off time (samples)
        dsx     GEN_dig_num,1           ; number of digits
        equx    GEN_SIZE,*-GEN_START

;--- R/O parameter defaults ---
        equx    GEN_DEF,*
        dc      400                    ; GEN_on_time
        dc      400                    ; GEN_off_time
        dc      10                      ; GEN_dig_num

;*******************************************************************
; Variables  (y: memory)
;-------------------------------------------------------------------
        dsx     GEN_dig_cnt,1           ; digit counter
        dsx     GEN_samp_cnt,1          ; sample counter
        dsx     GEN_ptr,1               ; digit buffer pointer
        dsx     GEN_cos1,1              ; low freq cos
        dsx     GEN_sn11,1              ; low freq state(n-1)
        dsx     GEN_sn12,1              ; low freq state(n-2)
        dsx     GEN_cos2,1              ; high freq cos
        dsx     GEN_sn21,1              ; high freq state(n-1)
        dsx     GEN_sn22,1              ; high freq state(n-2)
        dsx     GEN_yn,1                ; generation output

;****************************************************************
; Variables  (x: memory)
;----------------------------------------------------------------
        ORG     X:
        dsx     GEN_dig_buf,GEN_max_dig ; digit buffer

