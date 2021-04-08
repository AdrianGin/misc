;************************************************************************
; Description:                                                          *
; 1-563.asm                                                             *
;          DSP56300                                                     *
;	   20 tap FIR filter                                            *
;	                                                                *
;************************************************************************
;    REVISION HISTORY:                                                  *
;     Date           Change                                             *
;    June 30,1988    Initial placement                                  *
;    Aug  24,1998    Implementation on DSP56300                         * ;************************************************************************
;
;
;
;	This FIR filter reads the input sample
;	from the memory location Y:input
;	and writes the filtered output sample
;	to the memory location Y:output
;
;	The samples are stored in the X memory
;	The coefficients are stored in the Y memory
;
;
;          X MEMORY                               Y MEMORY
;
;         |        |                             |        |
;    R0   |--------|                             |--------|
;  +----->|  X(n)  |                      +----->|  c(0)  |
;  |  t   |--------|                      |t,t+T |--------|
;  |      | X(n-1) |                      |      |  c(1)  |
;  |      |--------|                      |      |--------|
;  |      |        |                      |      |        |
;  |      |        |                      |      |        |
;  |      |        |                      |      |        |
;  |      |        |                      |      |        |
;  |      |--------|                      |      |--------|
;  +----->|X(n-k+1)|  X(n+1)              +<-----| c(k-1) |
;   t+T   |--------|                             |--------|
;         |        |                             |        |
;
;
;                              C(0)                      
;                              ___          ___
;    x(n)                     /   \        /   \         y(n)
;    -------------+----------|  X  |----->|  +  |--------->
;                 |           \___/        \___/
;                 |                          ^             k-1
;                 |                          |             ____
;              +-----+                       |             \   '
;              |  T  |         C(1)          |      y(n)=  /___,c(p)x(n-p)
;              +-----+         ___           |             p=0
;                 |           /   \          |
;                 +----------|  X  |-------->+  
;                 |           \___/          |
;              +-----+                       |
;              |  T  |         C(2)          |
;              +-----+         ___           |
;                 |           /   \          |
;                 +----------|  X  |-------->+   
;                 |           \___/          |
;                 |                          |
;                 |                          |
;                 |                          |
;                 |                          |
;                 |                          |
;                 |                          |
;              +-----+                       |
;              |  T  |         C(K-1)        |
;              +-----+         ___           |
;                 |           /   \          |
;                 +----------|  X  |-------->+     
;                             \___/
;
;
;                            F I R
;
;**************************************************************************
        org y:$000020
coeff     DC  -0.0008,-0.0032,-0.0075,-0.0114,-0.0076,0.0126,0.0532
          DC  0.1081,0.1617,0.1949,0.1949,0.1617,0.1081,0.0532
          DC  0.0126,-0.0076,-0.0114,-0.0075,-0.0032,-0.0008
    
  
n	equ	20                    ;initialization
start	equ	$000100
wddr	equ	$000020
cddr	equ	$000020
input	equ	$ffffe0
output	equ	$ffffe1

	org	p:start
        move 	#wddr,r0               ;r0 -> samples
	move	#cddr,r4               ;r4 -> coefficients
        move 	#n-1,m0		       ;set modulo arithmetic
	move	m0,m4		       ;for the 2 circular buffers
        nop
        nop
	opt	cc
    do #28,_fff
        movep 	y:input,x:(r0)          ;input sample in memory
	clr	a	x:(r0)+,x0	y:(r4)+,y0
 	rep	#n-1
	mac	x0,y0,a	x:(r0)+,x0 	y:(r4)+,y0
	macr	x0,y0,a	(r0)-
        movep	a,y:output		;output filtered sample
_fff
        nop
;***************************************************************
	end


