;**************************************************************
; DESCRIPTION:
; Generalized Lattice FIR/IIR Filter Macro. (test program)
;
; REVISION HISTORY:
; Date           Change
; 08-01-1986     Initial placement
; 11-19-1998     Implementation on DSP56300 
;**************************************************************
;
;     generalized lattice iir/fir test program
;

order   equ   3               ;third order lattice
datin   equ   $ffffff         ;location of input file
datout  equ   $fffffe         ;location of output file
npts    equ   20              ;number of points to process
M_BCR	  equ   $fffffb         ;location of output file

      org     x:0
kadd  dc      .8,-.5,.5       ;k3, k2, k1
      dc      .1,.2,.3,.4     ;v3, v2, v1, v0
      org     y:0
state ds      10              ;filter states
        include 'latgen'

        org     p:$100
start
      movep   #$010000,x:M_BCR    ;one wait states on external io

      move    #kadd,r0        ;point to k's
      move    #order*2,m0     ;mod order*2+1
      move    #state,r4       ;point to first state
      move    #order,m4       ;mod order+1
      move    #2,n4		

      do      #npts,_endp
      movep   y:datin,a       ;get sample
      latgen  order           ;filter sample
      movep   a,y:datout      ;output sample
_endp
      end
