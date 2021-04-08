;**************************************************************
; DESCRIPTION:
; Generalized Lattice FIR/IIR Filter Macro.
;
; REVISION HISTORY:
; Date           Change
; 08-08-1986     Initial placement
; 11-19-1998     Implementation on DSP56300 
;**************************************************************
latgen        macro   order
latgen        ident   1,0
;
;     Generalized Lattice FIR/IIR
;
;     Input value in register A, output value in register A.
;
;     Macro call:
;             latgen  order           ;call macro
;
;     where 'order' is the number of K coefficients.
;
;     Alters registers: x0 x1 y0 a b, r0 r4, pc sr
;
;     uses 2 locations on the stack.
;
;
    move   x:(r0)+,x0   y:(r4)-,y0                 ;get first k, first s
    do     #order,_el                              ;calculate states
    macr   -x0,y0,a                                ;a-k*s
    nop
    tfr    y0,b         a,x1        b,y:(r4)+n4    ;set a for mul, get s to B, save prev s 
    macr   x1,x0,b      x:(r0)+,x0  y:(r4)-,y0     ;a*k+s, get nxt k, nxt s
_el
    nop
    move                            b,y:(r4)+      ;sv scnd to 1st st
    clr    a                        a,y:(r4)+      ;save first state
    move                            y:(r4)+,y0     ;get last state
    rep    #order
    mac    x0,y0,a      x:(r0)+,x0  y:(r4)+,y0     ;do fir taps
    macr   x0,y0,a      (r4)+                      ;mac and round, adj pointer
    endm
