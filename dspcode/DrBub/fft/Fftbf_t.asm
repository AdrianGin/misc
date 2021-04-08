;************************************************************************************
; DESCRIPTION:
; FFTBF_T.ASM	Test program for FFTBF.ASM (Radix 2, In-Place, Decimation-In-Time
;			 FFT (smallest code size)).
;
; REVISION HISTORY:
; Date           Change
; 09-30-1986     Initial placement
; 11-18-1998     Implementation on Motorola DSP56300
;************************************************************************************
;
;fftbf_t ident   1,0
;        page    132,54
;        opt     nomd,nomex,loc,cre,nocex,mu

        include 'sincos'
        include 'fftbf'
        include 'bitrev'
        include 'outdata_bf'
;
; Main program to call the FFTBF macro
;
;       32 point complex, in-place FFT
;       8 FFT passes
;       Data starts at address 0
;       Coefficient table starts at address 1024
;

reset   equ     0
start   equ     $100
points  equ     32
data    equ     0          
coef    equ     1024
_pi     equ     3.141592654
inc     set     2.0*_pi*0.032


        org     x:data		;generates input signal (no scaling needed)
angle   set     0.0
        dup     points
        dc      0.5*@sin(angle)
angle   set     angle+inc
        endm

        org     y:data
angle   set     0.0
        dup     points
;        dc      0.5*@cos(angle)
	  dc	    0.0	
angle   set     angle+inc
        endm

        sincos  points,coef			    ;coefficient generator	

        opt     mex
        org     p:reset
        jmp     start

        org     p:start
        movep   #$010000,X:$fffffb            ;Set BCR for 1 wait state
        fftbf   points,data,coef
	  bitrev   points,data	
	  outdata  points,data
return
        end
