;**********************************************************************************
; DESCRIPTION:
; BITREV.ASM	Transforming bit-reversed data into normal-ordered data
;
; REVISION HISTORY:
; Date           Change
; 08-18-1988     Initial placement
; 11-06-1998     Implementation on Motorola DSP56300
;**********************************************************************************
;
bitrev  macro   points,coef
bitrev  ident   1,0
;
;
;       POINTS:    number of points (2 - 32768, power of 2)
;       COEF:      base address of sine/cosine table
;                   negative cosine (Wr) and negative sine (Wi) in X memory
;
;

        move    #coef,r0         	;twiddle factor start address
        move    #0,m0            	;bit reverse address
        move    #-1,m1           	;linear address
        move    m1,m4            	;linear address
        move    m1,m5            	;linear address

        move    #points/2,n0     	;half of FFT length
        move    #coef+1,r1       	;r1 ptr to normal order data 
	  nop	
	  nop
        move    (r0)+n0          	;r0 ptr to bitrev 
        do      #points-1,_end_bit  ;do N-1 points swap
        move    r1,x0
        move    r0,a
        cmp     x0,a
        jle	    _incr			;if r0 less than r1, no swap
        move    r1,r5		
        move    r0,r4
	  nop
	  nop
        move    x:(r1),x0 y:(r5),y0
        move    x:(r0),a  y:(r4),b
        move    x0,x:(r0)+n0 y0,y:(r4)
        move    a,x:(r1)+  b,y:(r5)
        jmp     _wast
_incr    
        move    (r1)+            	;no swap but update points
        move    (r0)+n0
_wast
        nop
_end_bit
        endm    ;end of bitrev macro
