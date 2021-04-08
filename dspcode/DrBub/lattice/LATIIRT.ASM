;**************************************************************
; DESCRIPTION:
; Lattice IIR Filter Macro. (test program)
;
; REVISION HISTORY:
; Date           Change
; 07-31-1986     Initial placement
; 11-19-1998     Implementation on DSP56300 
;**************************************************************
;
;       LATTICE IIR
;
        opt     cex
        page    132,66,0,10
        list
        include 'latiir'


order   equ     3               ;three coefficient lattice
datin   equ     $ffffff         ;location of input file
datout  equ     $fffffe         ;location of output file
npts    equ     20              ;number of points to process
M_BCR	  equ     $fffffb         ;location of BCR register

        org     x:0
kadd    dc      .5,-.5,.8       ;filter reflection coefficients
        org     y:0
state   ds      3               ;filter states

        org     p:$100
start
        movep   #$010000,x:M_BCR        ;one wait states on external io

        move    #kadd+order-1,r0        ;point to k's
        move    #order-1,m0             ;mod order
        move    #state,r4               ;point to state variables
        move    #order-1,m4             ;mod order
        move    #2,n4             	    

        do      #npts,_endp             ;filter some points
        movep   y:datin,a               ;get input sample
        latiir  order                   ;filter it
        movep   a,y:datout              ;output sample
_endp
        END
