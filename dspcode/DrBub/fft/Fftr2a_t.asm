;**********************************************************************************
; DESCRIPTION:
; FFTR2A_T.ASM	
;  Test program for Radix 2, In-Place, Decimation-In-Time FFT:
;   FFTR2A, FFTR2AA, FFTR2B, FFTR2BF, FFTR2C, FFTR2CC, and FFTR2E.ASM
;   (Please refer to the file FFTR2AT.HLP for detailed information.)
;
; REVISION HISTORY:
; Date           Change
; 09-30-1986     Initial placement
; 11-18-1998     Implementation on Motorola DSP56300
;**********************************************************************************
;
;fftr2at ident   1,0
;        page    132,54
;        opt     nomd,nomex,loc,cre,nocex,mu

        include 'siggen'
        include 'sincos'
        include 'outdata'
        include 'bitrev'

        include 'fftr2a'
        include 'fftr2aa'
        include 'fftr2b'
        include 'fftr2bf'
        include 'fftr2c'
        include 'fftr2cc'
        include 'fftr2e'
;
; Main program to call the FFT macro
;
;       32 point complex, in-place FFT, 8 FFT passes
;       Data starts at address 0
;       Coefficient table starts at address $400
;

reset   equ     0
start   equ     $100
points  equ     32
data    equ     $40          
coef    equ     $400
temp	  equ	    $100	

        sincos  points,coef
        siggen  points,data

        opt     mex
        org     p:reset
        jmp     start

        org     p:start
        movep   #$010000,X:$fffffb            	;Set BCR for 1 wait state

;----------------------------------------------------------------------------------
; Please unmask the subroutine that you want to test and mask all others
;----------------------------------------------------------------------------------

        fftr2a  points,data,coef
;        fftr2aa  points,data,coef
;        fftr2b  points,data,coef
;        fftr2bf  points,data,coef,temp
;        fftr2c  points,data,coef
;        fftr2cc  points,data,coef
;        fftr2e  points,data,coef

;------------------------------------------------------------------------------------
; The following subroutines transform bit-reversed data into normal ordered data
; and then output the data into specified port. 
;------------------------------------------------------------------------------------
	  bitrev   points,data
	  outdata  points,data
return
        end
