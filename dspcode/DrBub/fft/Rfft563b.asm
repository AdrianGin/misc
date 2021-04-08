;**********************************************************************************
; DESCRIPTION:
; RFFT563B.ASM	Real input FFT based on Glen Bergland algorithm
;
; REVISION HISTORY:
; Date           Change
; 04-12-1992     Initial placement
; 11-06-1998     Implementation on DSP56300
;**********************************************************************************
;
; Since 56300 does not support bergland addressing, extra instruction cycles are needed 
; for converting bergland order to normal order.It has been done in the last pass by 
; looking at bergtable.
; 'bergsincos' generates sin and cos table with size of points/4,COS in Y, SIN in X
; 'bergorder' generates table for address convertion, the size of twiddle factors is half 
; of FFT output's
; 'rfft-56b' does FFT
;
; Normal order input and normal order output.
;
; Real input data are splited into two parts, the first part is put in X, the second in Y.
; Real output data are in X, imaginary output data are in Y. 
; The first real output plus the first imaginary output is DC value.
; Note that only DC to Nyquist frequency range is calculated by this algorithm
; After twiddle factors and bergtable are generated, you may overwrite 'bergorder',
; 'norm2berg' by 'rfft-56b' for saving P memory.	
; 
;rfft563b	ident   1,0
;        page    132,60
;        opt     nomd,nomex,loc,nocex,mu

	  include 'outdata'
;        include 'bergsincos'
;        include 'bergorder'
;        include 'norm2berg'
;        include 'rfft-563b'
;
;
bergsincos  macro   points,coef
bergsincos  ident   2,1
;
;       sincos  -       macro to generate sine and cosine coefficient
;                       lookup tables for Decimation in Time FFT
;                       twiddle factors.
;
;       points  -       number of points (2 - 32768, power of 2)
;       coef    -       base address of sine/cosine table
;                       negative cosine value in X memory
;                       negative sine value in Y memory
;
;

pi      equ     3.141592654
freq    equ     2.0*pi/@cvf(points)

        org     y:coef
count   set     0
        dup     points/4
        dc      @cos(@cvf(count)*freq)
count   set     count+1
        endm

        org     x:coef
count   set     0
        dup     points/4
        dc      @sin(@cvf(count)*freq)
count   set     count+1
        endm

        endm    ;end of sincos macro

bergsiggen	macro	points,idata
bergsiggen	ident	1,1
;
; Bergsiggen Macro: Generates "points" samples of a sinewave of arbitrary
; amplitude, frequency and phase.
;
;       points  -       number of points (1-65536)

_pi     equ     3.141592654
inc     set     2.0*_pi*0.032

        org     x:idata
angle   set     0.0
        dup     points/2
        dc      0.5*@sin(angle)/points
angle   set     angle+inc
        endm

        org     y:idata
angle   set     angle
        dup     points/2
        dc      0.5*@sin(angle)/points
angle   set     angle+inc
        endm

        endm    ;end of siggen macro


bergorder  macro   points,bergtable,offset
bergorder  ident   2,1

		  move 	#points,r4				;points=number of points of bergtable to be generated
		  move	#>points/4,b       		;initial pointer
		  move	#bergtable,r0			;table resides in
		  move	b,n0					;init offset
		  move	#>4,a
		  move	#>0,x0
		  move	x0,x:(r0)+n0			;seeds
		  move	#>2,x0
		  move	x0,x:(r0)+n0
		  move	#>1,x0
		  move	x0,x:(r0)+n0
		  move	#>3,x0
		  move	x0,x:(r0)
		  move	#bergtable,n0			;location of bergtable
		  do 		#@cvi(@log(points/4)/@log(2)),_endl
		  lsr		b	b,x0				;x0=i+i,b=i
		  nop
		  move	b,r0					;r0=i
		  nop
		  nop
		  nop
		  lsl		a	a,x:(r0+n0)			;k-> bergtable,k=k*2
		  nop
		  move	a,y1					;save A content
_star	  	  move	r4,a					;r4=# of points
		  cmp		x0,a					;x0=j, if j< points, cont
		  jle		_loop
		  move	x0,r0					;r0=i+i=j,b=i
	        move 	y1,a					;recover A=k
		  nop
		  move	b,x1					;save b, x1=i
		  move	x:(r0+n0),y0			;y0=bergtabl[j] 
		  sub		y0,a					;k-bergtabl[j]
		  move	r0,y0					;y0=j=i+i
		  add		y0,b					;b=j+i
		  nop
		  move	b,r0					;r0=j+i
		  nop
	 	  nop
		  add		x1,b					;b=j+i+i
		  move	a,x:(r0+n0)				;store bergtabl[j+i]
		  move	b,x0					;save b
		  move	x1,b					;recover b=i
		  jmp	_star
_loop		  move	y1,a					;recover a
_endl
		  move	#>offset,a				;offset is the location of output data or twiddle
		  move	#bergtable,r0
		  do		#points,_add_offset
		  move	x:(r0),b
		  add		a,b
		  nop
		  move	b,x:(r0)+
_add_offset

	        endm    ;end of order macro



;convert normal order to berglang order
;points is actual size of table to be converting 
;
norm2berg	macro	points,bergtable,twiddle
									
		move	#bergtable,r0				;r0=pointer of bergland table
		move	#twiddle,r2					;r2=twiddle pointer for X
		move 	r2,r6						;r6=twiddle pointer for Y
		do	#points,data_temp
		move	x:(r0)+,r3					;get index
		move	r3,r7
		nop
		nop
		nop
		move	x:(r3),a  y:(r7),b			;get value
		nop
		move	a,x:(r2)+ b,y:(r6)+			;write back
data_temp
		endm


; Real-Valued FFT for MOTOROLA DSP56300
; based on Glenn Bergland's algorithm
;   ______________________________
rifft macro points,idata,odata,twiddle,bergtable


    	move  #idata,r0              			;r0 = ptr to a
    	move  #points/4,n0                        ;bflys in ea group, half at ea pass
  	move 	#twiddle+1,r7				;r7 always points to start location of twiddle
	nop
    	lua	(r0)+n0,r1             			;r1 = ptr to b
    	move  r0,r4						;r4 points to c 
    	move	r1,r5						;r5 points to d,with predecrement 
	move 	#1,r3						;group per pass, double at ea pass
	nop
    	move  x:(r0),A        y:(r4),y0		;A=a, y0=c 

    	do     n0,pass1					;first pass is trivial, no multiplications
; ------------------------------------------------
;    First Pass -- W(n) = 1
;
;    A---\     /---A'= Re[ A + jB + (C + jD) ] =  A + C
;    B----\_|_/----B'= Im[ A + jB + (C + jD) ] =j(D + B)
;    C----/ | \----C'= Re[ A + jB - (C + jD) ] =  A - C
;    D---/     \---D'= Im[-A - jB + (C + jD) ] =j(D - B)
;-------------------------------------------------
;
    	sub 	y0,A   x:(r1),x0	  y:(r5),B		;A=a-c=c',B=d,x0=b,
   	add	x0,B   					;B=d+b=b', 
	move	A,x:(r1)+ 	y:(r5),A			;A=d,PUT c' to x:b
    	sub	x0,A   x:(r0)+,B   B,y:(r4)+  	;A=d-b=d',B=a,PUT b' to y:c
    	add   y0,B   					;B=a+c=a',  
	move	x:(r0)-,A 	  A,y:(r5)+ 	   	;A=next a,PUT d'
	move	 B,x:(r0)+	  y:(r4),y0			;y0=next c, PUT a'
pass1

    	move  #idata,r0              		 	; r0 = ptr to a

	do #@cvi(@log(points)/@log(2)+0.5)-3,end_pass				;do all passes except first and last
	move 	n0,A					 	;half bflys per group
	nop
	lsr	A		r3,B				;double group per pass
	move 	r7,r2						;r2 points to real twiddle
	lsl	B		A,n0	
	move 	r2,r6						;r6 points to imag twiddle
	nop
	move	B,r3						;r3 is temp reg.	
    	lua	(r0)+n0,r1                 		;r1 = ptr to b
   	move  r0,r4						;r4 points to c 
    	move	r1,r5						;r5 points to d
	lua	(r3)-,n2     				;n2=group per pass -1   
   	move  x:(r0),A    y:(r4),y0			;A=a, y0=c 

    	do    n0,FirstGroupInPass			;first group in a pass 
    	sub 	y0,A   x:(r1),x0	  y:(r5),B        ;A=a-c=c',B=d,x0=b,
    	add	x0,B   					;B=d+b=b', 
	move	A,x:(r1)+	  y:(r5),A			;A=d,PUT c' to x:b
    	sub	x0,A   x:(r0)+,B	B,y:(r4)+  		;A=d-b=d',B=a,PUT b' to y:c
    	add   y0,B   					;B=a+c=a', 
	move	x:(r0)-,A   A,y:(r5)+    		;A=next a,PUT d'
	move	B,x:(r0)+ 	y:(r4),y0			;y0=next c, PUT a'
FirstGroupInPass

  	do 	n2,end_group  				;rest  groups in this pass
	move	r5,r0						;r0 ptr to next group a
	move	r0,r4						;r4 ptr to next group c
	nop
	nop
	lua	(r0)+n0,r1					;r1 ptr to next group b 
	move	r1,r5						;r5 ptr to next group d 

;    Intermediate Passes -- W(n) < 1
;
;    A---\     /---A'=  Re[ A + jC + (B - jD)W(k) ] = A+BWr+DWi=A+T1
;    B----\_|_/----B'=  Im[ A + jC - (B - jD)W(k) ] = C+DWr-BWi=T2+C
;    C----/ | \----C'=  Re[ A + jC - (B - jD)W(k) ] = A-(BWr+DWi)=A-T1
;    D---/     \---D'=  Im[-A - jC - (B - jD)W(k) ] = -C+DWr-BWi=T2-C
;   ______________________________  
  	move	x:(r2)+,x0	y:(r6)+,y0			;x0=Wi, y0=Wr
	nop
	nop
  	move	x:(r1)-,x1	y:(r5),y1 			;x1=b,y1=d
	move	x:(r1),B					;for pointer reason 

	do 	n0,end_bfly  				;n0 bfly in this group
	mpy 	-x1,x0,B	B,x:(r1)+		  	;B=-bWi,PUT c' to x:b
	mac	y0,y1,B	y:(r4),A		 	;B=dWr-bWi=T2, A=c
  	sub	A,B					  	;B=T2-c=d'
  	addl	B,A						;A=T2+c=b',
	move	x:(r1)+,B	B,y:(r5)+ 			;PUT d'
  	mpy	-x1,y0,B	x:(r0),A	A,y:(r4)+ 	;B=-bWr,A=a,PUT b' to y:c
  	mac	-x0,y1,B	x:(r1)-,x1 			;B=-bWr-dWi=-T1, x1=next b
  	sub	B,A						;A=a+T1=a'
  	addl	A,B 						;B=a-T1=c', 
	move	A,x:(r0)+  	y:(r5),y1			;y1=next d, PUT a'
end_bfly
	move 	B,x:(r1)+					;PUT last b'
end_group
     	move  #idata,r0               	 	;r0 = ptr to a
end_pass

;the last pass converts bergland order to normal order by calling bergtable
  	move 	r7,r2						;r2 points to real twiddle
  	move 	r2,r6						;r6 points to imag twiddle
	move	#bergtable,r3				;r3=pointer of bergland table
    	move  r0,r4						;r4 points to c 
	move 	#2,n4
	move	#(points/4)-1,n2				;n2=group per pass -1   
	move	x:(r3)+,r7					;get first index
	move	x:(r3)+,r1					;get second index

;first group in the last pass 
    	move	x:(r0)+,A   y:(r4)+,B			;A=a, B=c 
    	sub 	B,A   	x:(r0)+,x0	y:(r6)+,y0	;A=a-c=c',x0=b, y0=Wr for next bfly
    	addl	A,B   					;B=a+c=a',  
	move	A,x:(r1) 	y:(r4),A			;A=d,PUT c' to x:b
    	sub	x0,A   	B,x:(r7)			;A=d-b=d',PUT a' to x
	nop
	move	y:(r4)+,B					;B=d
    	add   x0,B		A,y:(r1)  		  	;B=d+b=b', A=next a,PUT d' 
	nop
	move	x:(r0)+,A	B,y:(r7)			;A=next a, PUT b'
  	move	x:(r2)+,x0	y:(r4)+,B			;x0=Wi,B=next c

  	do 	n2,end_lastg  				;rest  groups in the last pass

;    Intermediate Passes -- W(n) < 1
;
;    A---\     /---A'=  Re[ A + jC + (B - jD)W(k) ] = A+BWr+DWi=A+T1
;    B----\_|_/----B'=  Im[ A + jC - (B - jD)W(k) ] = C+DWr-BWi=T2+C
;    C----/ | \----C'=  Re[ A + jC - (B - jD)W(k) ] = A-(BWr+DWi)=A-T1
;    D---/     \---D'=  Im[-A - jC - (B - jD)W(k) ] = -C+DWr-BWi=T2-C
;   ______________________________  
	move	x:(r0)+,x1	y:(r4)-,y1			;x1=b, y1=d, r4 ptr back to c  		 
	mpy 	x1,y0,B	x:(r3)+,r7			;A=bWr,
	mac	x0,y1,B  x:(r3)+,r1			;B=bWr+dWi=T1, get first index 
  	sub	B,A						;A=a-T1=c', get second index
	nop
  	addl	A,B						;B=a+T1=a', PUT c' to x:b			
	move	A,x:(r1)
  	mpy	y1,y0,A	B,x:(r7)		 	;B=dWr, B=c,PUT a'		
  	mac	-x1,x0,A	y:(r4)+n4,B			;A=dWi-bWr=T2, B=c, r4 ptr to next c
  	sub	B,A		x:(r2)+,x0	y:(r6)+,y0	;A=T2-c=d',x0=next Wi, y0=next Wr
  	addl	A,B 						;B=T2+c=b', update r4, A=next a, PUT d'
	move	A,y:(r1)
	move	x:(r0)+,A	B,y:(r7)			;PUT b', A=next a
	move	y:(r4)+,B					;B=next c	
end_lastg
	endm

; Main program to call the rfft563b macro
;
reset   		equ   0
start   		equ   $100
points  		equ   32
idata   		equ   $000
odata   		equ   $400
bergtable	      equ   $600
twiddle	      equ   $800

        bergsincos	points,odata		;generate normal order twiddle factors with size of points/4
	  bergsiggen	points,idata			;generate input signal

        opt     mex
        org     p:reset
        jmp     start

        org     p:start
        movep   #$010000,X:$fffffb             ;Set BCR for 0 wait states

	  bergorder	points/4,bergtable,odata	;generates bergland table for twiddle factor
	  norm2berg	points/4,bergtable,twiddle
								;converting twiddle factor from normal order to bergland order
	  bergorder	points/2,bergtable,odata	;table for final output
	  rifft  points,idata,odata,twiddle,bergtable

	  outdata	points/2,odata
return
	  nop
        end


