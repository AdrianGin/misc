;**************************************************************
; DESCRIPTION:
; Lattice FIR Filter Macro (modified modulo count).
;
; REVISION HISTORY:
; Date           Change
; 08-08-1986     Initial placement
; 11-19-1998     Implementation on DSP56300 
;**************************************************************
latfir2 macro   order
latfir2 ident   1,0
;
;       LATTICE FIR
;
;       Lattice FIR filter macro
;
;       Input value in register B, output value in register B.
;
;       Macro call:     latfir2 order
;               order   - order of filter (number of K coefficients)
;
;       Alters Data ALU Registers:
;       x0      y0      y1      a       b
;
;       Alters Address Registers:
;       r0      r4
;
;       Alters Program Control Registers:
;       pc      sr
;
;       Uses 2 locations on stack
;
;
	  move    x:(r0),x0   y:(r4)+,y0                 ;get s,get k
	  move    b,a                                    ;save first state
  	  do      #order,_endlat
	  macr    x0,y0,b     b,y1                       ;t'=s*k+t,copy t for mul
	  tfr     x0,a	      a,x:(r0)+	                 ;save s',copy next s
	  macr    y1,y0,a     x:(r0),x0     y:(r4)+,y0   ;s'=t*k+s,get s,get k
_endlat
	  nop
	  move		a,x:(r0)+	y:(r4)-,y0       ;save s',adj r4,dummy load
  endm
