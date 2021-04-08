;
; This program originally available on the Motorola DSP bulletin board.
; It is provided under a DISCLAIMER OF WARRANTY available from
; Motorola DSP Operation, 6501 Wm. Cannon Drive W., Austin, Tx., 78735.
; 
; Last Update May 19,1998   Version 1.0
;

;Memory map:
; 
;    Initial X                           H
;  x(0) x(n-1) x(n-2) x(n-3)       h0   h1   h2   h3
;   |                              |
;   r0                             r4
;                                  r5


XM      equ     0
ntaps   equ     4
H       equ     4
input   equ     $ffffef
output  equ     $ffffcf

    org     p:$100

TrueLms macro
    move    #XM,r0              ;start of X
    move    #ntaps-1,m0         ;mod 4
    move    #-2,n0              ;adjustment for filtering
    move    #H,r4               ;coefficients
    move    m0,m4               ;mod 4
    move    r4,r5               ;coefficients
    move    m0,m5               ;mod 4
 
_getsmp
    movep   y:input,x0          ;get input sample
 
    clr  a        x0,x:(r0)+ y:(r4)+,y0  ;save x(0), get h0    
    rep  #ntaps-1                        ;do fir               
    mac  x0,y0,a  x:(r0)+,x0 y:(r4)+,y0  ;do taps              
    macr x0,y0,a                         ;last tap             
 
    movep  a,y:output     ;output fir if desired
 
;    (Get d(n), subtract fir output, multiply by "u", put
;     the result in x1. This section is application dependent.)
 
    move          x:(r0)+,x0 y:(r4)+,a   ;get x(0), h0         
    do   #ntaps,_coefupdate              ;update coefficients  
    macr x0,x1,a  x:(r0)+,x0 y:(r4)+,y0  ;(u e(n) *x(n))+h     
    tfr  y0,a                a,y:(r5)+   ;copy h, save new h   
_coefupdate
    move   x:(r0)+n0,x0  y:(r4)-,y0      ;update r0,r4         
 
    jmp    _getsmp                       ;continue looping
                                                         

;          Implementation of the delayed LMS on the DSP56000 Revision C
 
;Memory map:
 
;    Initial X                           H
;  x(0) x(n-1) x(n-2) x(n-3)       hx  h0   h1   h2   h3
;   |                              |   |
;   r0                             r5  r4
;hx is an unused value to make the calculations faster.
        endm 
 
 
DelayLms        macro
    move    #XM,r0              ;start of X
    move    #ntaps-1,m0         ;mod 4
    move    #-2,n0              ;adjustment for filtering
    move    #H+1,r4             ;coefficients
    move    #ntaps,m4           ;mod 5
    move    #H,r5               ;coefficients
    move    m4,m5               ;mod 5
 
_smploop
  movep   y:input,a           ;get input sample
 
  move            a,x:(r0)    ;save input sample         
  ;error signal is in y1
  clr   a         x:(r0)+,x0  y:(r4)+,y0  ;get x(0), h0  
  do    #ntaps,_fir_cupdate   ;do fir and coefficient update    
  mac   x0,y0,a   y0,b        b,y:(r5)+   ;fir, copy h, save new h
  macr  x0,y1,b   x:(r0)+,x0  y:(r4)+,y0  ;update h, new x, new h 
_fir_cupdate
  rnd   a       x:(r0)+n0,x0  b,y:(r5)+   ;update r0, save last h 
 
;  (Get d(n), subtract fir output (reg a), multiply by "u", put
;   the result in y1. This section is application dependent.)
 
  movep         a,y:output         ;output fir if desired
  jmp           _smploop

        endm  

