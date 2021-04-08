;**********************************************************************************
; DESCRIPTION:
; FFTR2A.ASM	Radix 2, Decimation-In-Time In-Place FFT Routine
;			Please refer to the file FFTR2A.HLP for detailed information
;			 about this program.
;
; REVISION HISTORY:
; Date           Change
; 09-30-1986     Initial placement
; 10-29-1998     Implementation on Motorola DSP56300
;**********************************************************************************
;
fftr2a   macro     points,data,coef
fftr2a   ident     1,0
;
;    Complex input and output data
;        Real data in X memory
;        Imaginary data in Y memory
;    Normally ordered input data
;    Bit reversed output data
;        Coefficient lookup table
;        -Cosine values in X memory
;        -Sine values in Y memory
;
; Macro Call - fftr2a   points,data,coef
;
;        points     number of points (2-32768, power of 2)
;        data       start of data buffer
;        coef       start of sine/cosine table
;
; Alters Data ALU Registers
;        x1     x0  y1       y0
;        a2     a1  a0       a
;        b2     b1  b0       b
;
; Alters Address Registers
;        r0     n0  m0
;        r1     n1  m1
;               n2
;
;        r4     n4  m4
;        r5     n5  m5
;        r6     n6  m6
;
; Uses 6 locations on System Stack
;
         move    #points/2,n0     		;initialize butterflies per group
         move    #1,n2            		;initialize groups per pass
         move    #points/4,n6      		;initialize C pointer offset
         move    #-1,m0            		;initialize A and B address modifiers
         move    m0,m1             		;for linear addressing
         move    m0,m4
         move    m0,m5
         move    #0,m6             		;initialize C address modifier for
                                   		; reverse carry (bit-reversed) addressing
;
; Perform all FFT passes with triple nested DO loop
;
         do      #@cvi(@log(points)/@log(2)+0.5),_end_pass
         move    #data,r0        		;initialize A input pointer
         move    r0,r4           		;initialize A output pointer
         move    n0,n1           		;initialize pointer offsets
         move    n0,n4
         lua     (r0)+n0,r1 			;initialize B input pointer
         move    #coef,r6        		;initialize C input pointer
         move    n0,n5
         lua     (r1)-,r5        		;initialize B output pointer

         do      n2,_end_grp
         move    x:(r1),x1  y:(r6),y0     ;lookup -sine and -cosine values
         move    x:(r5),a   y:(r0),b      ;preload data
         move    x:(r6)+n6,x0             ;update C pointer

         do      n0,_end_bfy
         mac     x1,y0,b    y:(r1)+,y1    ;Radix 2 DIT butterfly kernel
         macr    -x0,y1,b   a,x:(r5)+   y:(r0),a
	   nop
         subl    b,a        x:(r0),b    b,y:(r4)
         mac     -x1,x0,b   x:(r1),x1
         macr    -y1,y0,b   x:(r0)+,a   a,y:(r5)
         subl    b,a        
	   move    b,x:(r4)+  y:(r0),b
_end_bfy
         move    a,x:(r5)+n5    y:(r1)+n1,y1   	;update A and B pointers
         move    x:(r0)+n0,x1   y:(r4)+n4,y1	
_end_grp
         move    n0,b1
         lsr     b   n2,a1     		;divide butterflies per group by two
	   nop
         lsl     a   b1,n0     		;multiply groups per pass by two
	   nop
         move    a1,n2
_end_pass
         endm
