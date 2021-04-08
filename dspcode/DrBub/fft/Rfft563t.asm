;**************************************************************************************
; DESCRIPTION:
; RFFT563_T.ASM	Test program for CFFT563.ASM (1024-Point Real Input Non-In-Place FFT)
;
; REVISION HISTORY:
; Date           Change
; 11-11-1992     Initial placement
; 11-18-1998     Implementation on Motorola DSP56300
;**************************************************************************************
;
;RFFT563T ident   1,0
;        page    132,60
;        opt     nomd,nomex,loc,nocex,mu

        include 'sincosr'
        include 'cfft563'
        include 'split563'
        include 'bitrev'

reset   equ     0
start   equ     $100
points  equ     512
idata   equ     $00
odata   equ     $1000
coef    equ     $800

;generates input signal

srate   set     44100   	;Hz
ffreq   set     2000    	;Hz
ppi     equ     3.141592654
freq2   equ     2.0*ppi*ffreq/@cvf(srate)

        org     x:idata
count   set     0
        dup     points
        dc      @sin(@cvf(count)*freq2)/points
count   set     count+1
        endm

        org     y:idata
count   set     0
        dup     points
        dc      @sin(@cvf(count)*freq2)/points
count   set     count+1
        endm

        sincosr  points,coef			    ;coefficient generator

        opt     mex
        org     p:reset
        jmp     start

        org      p:start
        movep    #$010000,X:$fffffb            ;Set BCR for 1 wait state
        bitrev   points/4,coef

        cfft563  idata,coef,points,odata
        split563 idata,coef,points,odata

;output results
	   move    #-1,m0          		;linear addressing
	   move    #-1,m4          		;linear addressing
	   move    #idata,r0        		;initialize real input pointer
         move    r0,r4        		;initialize image input pointer
         do      #points/2,end_output
	   movep    x:(r0)+,y:$fffffc
	   movep    y:(r4)+,y:$fffffd
end_output
return
	  nop
        end
