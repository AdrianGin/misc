;***************************************************************
; Description:                                                 *
;  E2-563.asm                                                  *
;         DSP56300                                             *
;         Port to Memory FFT - 256 point                       *
;***************************************************************
;    REVISION HISTORY:                                         *
;     Date           Change                                    *
;     June 30,1988    Initial placement                        *
;     Nov  24,1998    Implementation on DSP56300               *
;***************************************************************
;
;
; Radix 2 Decimation in Time In-Place Fast Fourier Transform Routine
;
;    Real input and complex output data
;    Real data in X memory
;    Imaginary data in Y memory
;    Normally ordered input data
;    Normally ordered output data
;    Coefficient lookup table
;    -Cosine value in X memory
;    -Sine value in Y memory
;
; Macro Call - fftedn1   points,data,data1,odata,coef,ptr1,ptr2
;
;    points     number of points (2-32768, power of 2)
;    data       location of pointer to start of data buffer
;    data1      location of pointer to start of second buffer  
;    odata      start of output data buffer
;    coef    start of sine/cosine table
;    ptr1    location of pointer 1 (points to data acquisition buffer)
;    ptr2    location of pointer 2 (points to buffer being processed)
; Alters Data ALU Registers
;    x1   x0   y1   y0
;    a2   a1   a0   a
;    b2   b1   b0   b
;
; Alters Address Registers
;    r0   n0   m0
;    r1   n1   m1
;    r2   n2
;
;    r4   n4   m4
;    r5   n5   m5
;    r6   n6   m6
;
; Alters Program Control Registers
;    pc   sr
;
; Uses 6 locations on System Stack
;
;**************************************************************************
;

reset   equ       0
start   equ       $000100              
points  equ       256
data    equ       $00033f
data1   equ       $00033e
outdata	equ	  $000240
coef    equ       $000342
ptr1    equ       $000340
ptr2    equ       $000341


fftedn1   macro     points,data,data1,odata,coef,ptr1,ptr2
fftedn1   ident     1,2



strt move r7,a
     move x:ptr1,b  ;move input data base addres into a
     cmp  a,b       ;see if equal
     jne  strt      ;if not, go back
;    when ready, swap pointers of buffer to be loaded and buffer to be processed
     
     move x:ptr1,a
     move x:ptr2,b
     move b,x:ptr1
     move a,x:ptr2
     
     move x:data,a
     move x:data1,b
     move b,x:data
     move a,x:data1 
;
;    main fft routine


     move x:data1,r0           						;initialize input pointer
     move #points/4,n0        						;initialize input and output pointers offset
     move n0,n4               
     move n0,n6               						;initialize coefficient offset
     move #points-1,m0        						;initialize address modifiers
     move m0,m1               						;for modulo addressing
     move m0,m4
     move m0,m5
;
; Do first and second Radix 2 FFT passes, combined as 4-point butterflies
;
     	move           		x:(r0)+n0,x0
     	tfr 	 x0,a      	x:(r0)+n0,y1   

     do   n0,_twopass
        tfr	y1,b		x:(r0)+n0,y0
	add	y0,a		x:(r0),x1				;ar+cr
	add	x1,b		r0,r4					;br+dr
	add	a,b		(r0)+n0					;ar'=(ar+cr)+(br+dr)
	subl	b,a		
        move                    b,x:(r0)+n0				;br'=(ar+cr)-(br+dr)
	tfr	x0,a		a,x0			y:(r0),b
	sub	y0,a					y:(r4)+n4,y0	;ar-cr
	sub	y0,b		x0,x:(r0)				;bi-di
	add	a,b					y:(r0)+n0,x0	;cr'=(ar-cr)+(bi-di)
	subl	b,a		
        move                    b,x:(r0)				;dr'=(ar-cr)-(bi-di)
	tfr	x0,a		a,x0			y:(r4),b
	add	y0,a					y:(r0)+n0,y0	;bi+di
	add	y0,b		x0,x:(r0)+n0				;ai+ci
	add	b,a					y:(r0)+,x0	;ai'=(ai+ci)+(bi+di)
	subl	a,b				
        move	                                        a,y:(r4)+n4	;bi'=(ai+ci)-(bi+di)
	tfr	x0,a					b,y:(r4)+n4
	sub	y0,a		x1,b					;ai-ci
	sub	y1,b		x:(r0)+n0,x0				;dr-br
	add	a,b		x:(r0)+n0,y1				;ci'=(ai-ci)+(dr-br)
	subl	b,a				
        move						b,y:(r4)+n4	;di'=(ai-ci)-(dr-br)
	tfr	x0,a					a,y:(r4)+
_twopass
;
; Perform all next FFT passes except last pass with triple nested DO loop
;    
     move #points/8,n1        						;initialize butterflies per group
     move #4,n2               						;initialize groups per pass
     move #-1,m2              						;linear addressing for r2
     move #0,m6               						;initialize C address modifier for
                             						;reverse carry (bit-reversed) addressing

     do   #@cvi(@log(points)/@log(2)-2.5),_end_pass    			;example: 7 passes for 1024 pt. FFT
        move x:data1,r0                                 			;initialize A input pointer
        move	r0,r1
	move	n1,r2
	move	r0,r4							;initialize A output pointer
	move	#coef,r6						;initialize C input pointer
        move	(r1)+n1							;initialize B input pointer
	move	r1,r5							;initialize B output pointer
	lua	(r2)+,n0						;initialize pointer offsets
	move	n0,n4
	move	n0,n5
	move	(r2)-					    		;butterfly loop count
	move			x:(r1),x1	y:(r6),y0   		;lookup -sine and -cosine values
	move			x:(r6)+n6,x0	y:(r0),b    		;update C pointer, preload data
	mac	x1,y0,b				y:(r1)+,y1
	macr	-x0,y1,b			y:(r0),a

	do	n2,_end_grp
	do	r2,_end_bfy
	nop
        subl	b,a		x:(r0),b	b,y:(r4)		;Radix 2 DIT butterfly kernel
	mac	-x1,x0,b			
	macr	-y1,y0,b	x:(r1),x1       a,y:(r5)
	move                    x:(r0)+,a
        subl	b,a		b,x:(r4)+	y:(r0),b
	mac	x1,y0,b				y:(r1)+,y1
	macr	-x0,y1,b	a,x:(r5)+	y:(r0),a
_end_bfy
	move	(r1)+n1
	subl	b,a		x:(r0),b	b,y:(r4)
	mac	-x1,x0,b	
	macr	-y1,y0,b	x:(r0)+n0,a	a,y:(r5)
	move                    x:(r1),x1	y:(r6),y0
        subl	b,a		b,x:(r4)+n4	y:(r0),b
	mac	x1,y0,b	        x:(r6)+n6,x0	y:(r1)+,y1
	macr	-x0,y1,b	a,x:(r5)+n5	y:(r0),a
_end_grp
	move	n1,b1
	lsr	b	n2,a1						;divide butterflies per group by two
	lsl	a							;multiply groups per pass by two
	move    b1,n1
        move	a1,n2
_end_pass
;
; Do last FFT pass
;
        move    #2,n0          						;initialize pointer offsets
        move    n0,n1
        move    #points/4,n4   						;output pointer A offset
        move    n4,n5          						;output pointer B offset
        move    x:data1,r0      						;initialize A input pointer
        move	#odata,r2        					;initialize A output pointer
	move    r2,r4							;save A output pointer
	move    #0,m4							;bit-reversed addressing for output ptr. A
	move	m4,m5							;bit-reversed addressing for output ptr. B
        lua	(r2)+n2,r5						;initialize B output pointer
	lua	(r0)+,r1						;initialize B input pointer
	move	#coef,r6						;initialize C input pointer
	move    (r5)-n5							;predecrement output pointer
	move			x:(r5),a	y:(r0),b
        move			x:(r1),x1	y:(r6),y0
     do   n2,_lastpass
        mac	x1,y0,b		x:(r6)+n6,x0	y:(r1)+n1,y1		;Radix 2 DIT butterfly kernel
	macr	-x0,y1,b	a,x:(r5)+n5	y:(r0),a		;with one butterfly per group
	nop
        subl	b,a		x:(r0),b	b,y:(r4)
	mac	-x1,x0,b	
	macr	-y1,y0,b	x:(r0)+n0,a	a,y:(r5)
	move                    x:(r1),x1	y:(r6),y0
        subl	b,a		b,x:(r4)+n4	y:(r0),b
_lastpass
     nop
     move          		 a,x:(r5)+n5
     jmp  strt
     endm
;
;    interrupt routine
     org p:$000010
     movep     y:$ffffff,y:(r7)+       					 ;data collection upon interrupt
;
;    main routine
    opt     mex
       org     p:reset
       jmp     start
       org     p:start
                  
     move  #$100007,x1
     move  x1,x:$ffffff                                                 ;set interupt state
     move  #$000000,sr 
      
     move #255,a1                         
     move #511,m7                       				;set r7 for modulo addressing
     move a,x:$340                     					;store pointer to data block 1
     move #511,a1
     nop
     move a,x:$341                      				;store pointer to data block 2
     
     move  #0,a1
     nop
     move  a,x:data
     move  #256,a1
     nop
     move  a,x:data1 
;
;    call fft macro
     fftedn1  points,data,data1,outdata,coef,ptr1,ptr2 
  
     end
