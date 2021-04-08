;******************************************************************************
; COPYRIGHT:    Copyright 1996 Motorola. All rights reserved.
;
; Description:  This file contains DTMF Equates
;
; Revision History:
; Revision 1.0  30-12-1996  16:02
; Initial placement
;******************************************************************************

        set     GEN_max_dig     40      ; max # of generated digits
        set     DET_Max_ND      16      ; max # of sine detectors
        set     DET_INIT        0       ; DET_Flag bit 0 - init Goertzel flag
        set     TST_SH          0       ; 2nd harmonic detection (0-off, 1-on)
        set     TST_TD          0       ; TST_Flag bit 0 - new tone detected
        set     TST_DTMax       40      ; max # of detected digits

        set     SSISR           $FFEE
