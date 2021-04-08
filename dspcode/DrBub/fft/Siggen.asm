;**********************************************************************************
; DESCRIPTION:
; SIGGEN.ASM
;  This macro generates a simulated sinewave input signal sequence for test
;  program of FFT (with scaling down by N=POINTS of FFT).
;
; REVISION HISTORY:
; Date           Change
; 10-18-1998     Initial implementation on Motorola DSP56300
;**********************************************************************************
;
;
siggen	macro	points,idata
siggen	ident	1,1
;
; SIGGEN Macro
;
;       idata: start address of X and Y memory to store the input data
;       points: number of points (1-65536)

_pi     equ     3.141592654
inc     set     2.0*_pi*0.032

        org     x:idata
angle   set     0.0
        dup     points
        dc      0.5*@sin(angle)/points
angle   set     angle+inc
        endm

        org     y:idata
angle   set     0.0
        dup     points
;        dc      0.5*@cos(angle)/points
	  dc	    0.0	
angle   set     angle+inc
        endm

        endm    ;end of sinegen macro
