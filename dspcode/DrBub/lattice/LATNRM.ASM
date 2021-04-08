;**************************************************************
; DESCRIPTION:
; Normalized Lattice IIR Filter Macro.
;
; REVISION HISTORY:
; Date           Change
; 07-31-1986     Initial placement
; 11-19-1998     Implementation on DSP56300 
;**************************************************************
latnrm  macro   order
latnrm  ident   1,0
;
;       Normalized Lattice filter macro
;
;       Input value in register y0, output value in register A
;
;       Macro call:
;               latnrm  order           ;call macro
;
;       where 'order' is the number of reflections coefficients
;       in the filter.
;
;       Alters registers: x0 x1 y0 y1 a b, r0 r4, pc sr
;
;       Uses 2 locations on stack
;
;
  move           x:(r0)+,x1               ;get first Q in table
  do    #order,_endnlat
  mpy   x1,y0,a  x:(r0)+,x0   y:(r4),y1   ;q*w, get k, get s
  macr -x0,y1,a  b,y:(r4)+                ;a-k*s, save new s
  mpy   x0,y0,b               		;k*w 
  macr  x1,y1,b  x:(r0)+,x1   a,y0        ;b+q*s, get next q, set new w
_endnlat              
  nop
  move                        b,y:(r4)+   ;sv scnd lst st
  move                        a,y:(r4)+   ;save last state
  clr   a                     y:(r4)+,y0  ;clr acc, get fst st
  rep   #order                            ;do fir taps
  mac   x1,y0,a  x:(r0)+,x1   y:(r4)+,y0	;s*w+out,get s, get w
  macr  x1,y0,a               (r4)+       ;lst tap, rnd, adj pointer
  endm
