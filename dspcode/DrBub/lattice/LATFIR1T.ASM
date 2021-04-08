;**************************************************************
; DESCRIPTION:
; Lattice FIR Filter1 Macro. (test program)
;
; REVISION HISTORY:
; Date           Change
; 08-08-1986     Initial placement
; 11-19-1998     Implementation on DSP56300 
;**************************************************************
;
;       lattice FIR test program
;
        opt     nomd,mex,mu,cex
        page    132,66,0,10
        list
        include 'latfir1'

order   equ     3               ;3 coefficient lattice
datin   equ     $ffffff         ;location in Y memory of input file
datout  equ     $fffffe         ;location in Y memory of output file
npts    equ     20              ;number of points to process
M_BCR   equ	    $fffffb         ;location of BCR

        org     x:0
state   ds      10              ;filter states

        org     y:0
kadd    dc      .5,-.5,.2       ;reflection coefficients, k1,k2,k3

        org     p:$100
start
        movep   #$010000,x:M_BCR     ;one wait states on external i/o

        move    #state,r0       ;point to filter states
        move    #order,m0       ;mod on filter states
        move    #kadd,r4        ;point to reflection coefficients
        move    #order,m4       ;mod on reflection coefficients

        do      #npts,_endp
        movep   y:datin,b       ;get sample, set t
        latfir1 order           ;do lattice fir
	  movep   b,y:datout      ;output sample
_endp
        END
