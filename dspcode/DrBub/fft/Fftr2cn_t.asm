;**********************************************************************************
; DESCRIPTION:
; FFTR2CN_T.ASM	
;  Test program for Radix 2, Non-In-Place, Decimation-In-Time FFT:
;   FFTR2CN.ASM and FFTR2EN.ASM
;   (Please refer to the file FFTR2AT.HLP for detailed information)
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

        include 'fftr2cn'
        include 'fftr2en'
;
; Main program to call the FFT macro
;
;       32 point complex, non-in-place FFT, 8 FFT passes
;       Data starts at address 0
;       Coefficient table starts at address $400
;

reset   equ     0
start   equ     $100
points  equ     32
data    equ     $40          
coef    equ     $400
odata	  equ	    $80
temp	  equ	    $100	

        sincos  points,coef
        siggen  points,data

        opt     mex
        org     p:reset
        jmp     start

        org     p:start
        movep   #$010000,X:$fffffb            	;Set BCR for 1 wait state

;----------------------------------------------------------------------------------
; Please unmask the subroutine that you want to test and mask the other one
;----------------------------------------------------------------------------------

	   fftr2cn  points,data,odata,coef
;        fftr2en  points,data,coef,odata

;------------------------------------------------------------------------------------
; The following subroutines transform bit-reversed data into normal ordered data
; and then output the data into specified port. 
;------------------------------------------------------------------------------------
	  bitrev   points,data
	  outdata  points,odata
return
        end
