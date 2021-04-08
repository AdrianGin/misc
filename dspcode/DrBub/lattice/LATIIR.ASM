;**************************************************************
; DESCRIPTION:
; Lattice IIR Filter Macro.
;
; REVISION HISTORY:
; Date           Change
; 07-31-1986     Initial placement
; 11-19-1998     Implementation on DSP56300 
;**************************************************************
latiir  macro   order
latiir  ident   1,0
;
;       Lattice IIR filter macro
;
;       Input value in register A, output value in register A
;
;       Macro call:
;               latiir  order           ;call macro
;
;       where 'order' is the number of reflections coefficients
;       in the filter.
;
;       Alters registers: x0 x1 y0 a b, r0 r4, pc sr
;
;       Uses 2 locations on stack
;
;
  move            x:(r0)-,x0  y:(r4)+,y0    ;get first k, first state
  macr  -x0,y0,a  x:(r0)-,x0  y:(r4)-,y0    ;do first section
  do    #order-1,_endlat                    ;do remaining sections
  macr  -x0,y0,a              		  ;a-k*s
  nop
  tfr   y0,b	a,x1        b,y:(r4)+n4   ;set a for mul,st to b , save previous state
  macr  x1,x0,b   x:(r0)-,x0  y:(r4)-,y0    ;fnd nxt s, nxt s, nxt k
_endlat
  nop
  move                        b,y:(r4)+     ;round; save second last state
  move            x:(r0)+,x0  a,y:(r4)+     ;update r0, save last state
  endm 
