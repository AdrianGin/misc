;**********************************************************************************
; DESCRIPTION:
; FFTR2D_T.ASM	
;  Test program for Radix 2, In-Place, Decimation-In-Time FFT.
;   (Please refer to the file FFTR2AT.HLP for detailed information)
;
; REVISION HISTORY:
; Date           Change
; 08-08-1986     Initial placement
; 11-18-1998     Implementation on Motorola DSP56300
;**********************************************************************************
;
;fftr2dt ident   1,0
;        page    132,66,2,2
;        opt     nomd,loc,cre,mu

        include 'siggen'
        include 'sinewave'
        include 'outdata'
        include 'bitrev'

        include 'fftr2d'

; Main program to call the FFTR2D macro
;
;       32 point complex, in-place FFT
;       Data starts at address 0
;       Coefficient table starts at address $100
;
; This example shows how to perform a 32 point FFT using a 256 point
; full cycle sinewave table generated by sinewave macro.
;
reset   equ     0
start   equ     $100
points  equ     32
data    equ     0
coef    equ     $100
table   equ     256

        org     y:coef
        sinewave    table
        siggen      points,data

        opt     mex
        org     p:reset
        jmp     start

        org     p:start
        movep    #$010000,X:$fffffb            ;Set BCR for 1 wait state 
        fftr2d   points,data,coef,table
	  bitrev   points,data	
	  outdata  points,data
return
        end