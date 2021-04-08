;**************************************************************
; DESCRIPTION:
; Normalized Lattice IIR Filter Macro. (test program)
;
; REVISION HISTORY:
; Date           Change
; 08-01-1986     Initial placement
; 11-19-1998     Implementation on DSP56300 
;**************************************************************
;
;       normalized lattice test program
;
        opt     cex
        page    132,66,0,10
        list
        include 'latnrm'

order   equ     3               ;three coefficient lattice
datin   equ     $ffffff         ;location in y memory of input file
datout  equ     $fffffe         ;location in y memory of output file
npts    equ     20              ;number of points to process
M_BCR	  equ     $fffffb         ;location of BCR register

        org     x:0
;       note: the following coefficients were used for testing
;       purposes only and do not follow the relationship q=sqrt(1-k**2)
;       as described by Markel
;
cadd    dc      .9,.8,.7,.6,.3,.2   ;q2,k2,q1,k1...
        dc      .1,.2,.3,.4         ;v's
        org     y:0
state   ds      10              	;filter states

        org     p:$100
start
        movep   #$010000,x:M_BCR    ;one wait states on external io

        move    #cadd,r0           	;point to k's
        move    #3*order,m0     	;mod order
        move    #state,r4       	;point to first state
        move    #order,m4       	;mod order

        do      #npts,_endp

        movep   y:datin,y0      	;get input sample
        latnrm  order           	;do normalized lattice
        movep   a,y:datout      	;output filtered sample
_endp
        end
