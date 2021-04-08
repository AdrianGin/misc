;**********************************************************************************
; DESCRIPTION:
; FFTR2CC.ASM     Radix 2, In-Place, Decimation-In-Time FFT (fast).
;			Please refer to the file FFTR2CC.HLP for detailed information
;			 about this program.
;
; REVISION HISTORY:
; Date           Change
; 08-18-1988     Initial placement
; 10-29-1998     Implementation on Motorola DSP56300
;**********************************************************************************
;
fftr2cc  macro   points,data,coef
fftr2cc  ident   1,0
;
;    Complex input and output data
;        Real data in X memory
;        Imaginary data in Y memory
;    Normally ordered input data
;    Bit reversed output data
;       Coefficient lookup table
;        -Cosine values in X memory
;        -Sine values in Y memory
;
; Macro Call - fftr2cc   points,data,coef
;
;       points     number of points (16-32768, power of 2)
;       data       start of data buffer
;       coef       start of sine/cosine table
;
; Alters Data ALU Registers
;       x1      x0      y1      y0
;       a2      a1      a0      a
;       b2      b1      b0      b
;
; Alters Address Registers
;       r0      n0      m0
;       r1      n1      m1
;               n2
;
;       r4      n4      m4
;       r5      n5      m5
;       r6      n6      m6
;
; Alters Program Control Registers
;       pc      sr
;
; Uses 6 locations on System Stack
;
     move #data,r0            ;initialize input pointer
     move #points/4,n0        ;initialize input and output pointers offset
     move n0,n4               ;
     move n0,n6               ;initialize coefficient offset
     move #points-1,m0        ;initialize address modifiers
     move m0,m1               ;for modulo addressing
     move m0,m4
     move m0,m5
;
; Do first and second Radix 2 FFT passes, combined as 4-point butterflies
;
     move           x:(r0)+n0,x0
     tfr  x0,a      x:(r0)+n0,y1   

     do   n0,_twopass
     tfr  y1,b      x:(r0)+n0,y0
     add  y0,a      x:(r0),x1                     ;ar+cr
     add  x1,b      r0,r4                         ;br+dr
     add  a,b       (r0)+n0                       ;ar'=(ar+cr)+(br+dr)
     subl b,a       					  ;br'=(ar+cr)-(br+dr)
     move  b,x:(r0)+n0                   
     tfr  x0,a      a,x0           y:(r0),b
     sub  y0,a                     y:(r4)+n4,y0   ;ar-cr
     sub  y0,b      x0,x:(r0)                     ;bi-di
     add  a,b                      y:(r0)+n0,x0   ;cr'=(ar-cr)+(bi-di)
     subl b,a       					  ;dr'=(ar-cr)-(bi-di)
     move  b,x:(r0)                      
     tfr  x0,a      a,x0           y:(r4),b
     add  y0,a                     y:(r0)+n0,y0   ;bi+di
     add  y0,b      x0,x:(r0)+n0                  ;ai+ci
     add  b,a                      y:(r0)+,x0     ;ai'=(ai+ci)+(bi+di)
     subl a,b                      			  ;bi'=(ai+ci)-(bi+di)
     move  a,y:(r4)+n4    
     tfr  x0,a                     b,y:(r4)+n4
     sub  y0,a      x1,b                          ;ai-ci
     sub  y1,b      x:(r0)+n0,x0                  ;dr-br
     add  a,b       x:(r0)+n0,y1                  ;ci'=(ai-ci)+(dr-br)
     subl b,a                      			  ;di'=(ai-ci)-(dr-br)
     move  b,y:(r4)+n4    
     tfr  x0,a      a,y:(r4)+
_twopass
;
; Perform all next FFT passes except last pass with triple nested DO loop
;    
     move #points/8,n1        ;initialize butterflies per group
     move #4,n2               ;initialize groups per pass
     move #-1,m2              ;linear addressing for r2
     move #0,m6               ;initialize C address modifier for
                              ;reverse carry (bit-reversed) addressing

     do   #@cvi(@log(points)/@log(2)-2.5),_end_pass    ;example: 7 passes for 1024 pt. FFT
     move #data,r0                                     ;initialize A input pointer
     move r0,r1
     move n1,r2
     move r0,r4                                        ;initialize A output pointer
     move #coef,r6                                     ;initialize C input pointer
     move (r1)+n1                                      ;initialize B input pointer
     move r1,r5                                        ;initialize B output pointer
     lua  (r2)+,n0                                     ;initialize pointer offsets
     move n0,n4
     move n0,n5
     move (r2)-                                        ;butterfly loop count
     move           x:(r1),x1      y:(r6),y0           ;lookup -sine and -cosine values
     move           x:(r6)+n6,x0   y:(r0),b            ;update C pointer, preload data
     mac  x1,y0,b                  y:(r1)+,y1
     macr -x0,y1,b                 y:(r0),a

     do   n2,_end_grp
     do   r2,_end_bfy
     subl b,a       						;Radix 2 DIT butterfly kernel
     move	x:(r0),b       b,y:(r4)            
     mac  -x1,x0,b  x:(r0)+,a      a,y:(r5)
     macr -y1,y0,b  x:(r1),x1
     nop    
     subl b,a       b,x:(r4)+      y:(r0),b
     mac  x1,y0,b                  y:(r1)+,y1
     macr -x0,y1,b  a,x:(r5)+      y:(r0),a
_end_bfy
     move (r1)+n1
     subl b,a       x:(r0),b       b,y:(r4)
     nop    
     mac  -x1,x0,b  x:(r0)+n0,a    a,y:(r5)
     macr -y1,y0,b  x:(r1),x1      y:(r6),y0
     nop    
     subl b,a       b,x:(r4)+n4    y:(r0),b
     mac  x1,y0,b   x:(r6)+n6,x0   y:(r1)+,y1
     macr -x0,y1,b  a,x:(r5)+n5    y:(r0),a
_end_grp
     move n1,b1
     lsr  b    n2,a1     			;divide butterflies per group by two
     nop    
     lsl  a    b1,n1     			;multiply groups per pass by two
     nop    
     move a1,n2
_end_pass
;
; Do last FFT pass
;
;
        move    #2,n0           		;correct input pointer A offset for last pass
        move    #data,r0        		;initialize A input pointer
        move    r0,r4           		;initialize A output pointer
        move    n0,n1           		;correct input pointer B offset for last pass
        move    n0,n4           		;correct output pointer A offset for last pass
        lua     (r0)+,r1        		;initialize B input pointer
        move    #coef,r6        		;initialize C input pointer
        move    n0,n5           		;correct output pointer B offset for last pass
        lua     (r1)-n1,r5      		;initialize B output pointer
        move    x:(r1),x1       y:(r6),y0
        nop    
	  nop
        move    x:(r5),a        y:(r0),b

        do      n2,_lastpass    		;Radix 2 DIT butterfly kernel with one
        mac     x1,y0,b x:(r6)+n6,x0    y:(r1)+n1,y1    ;butterfly per group
        macr    -x0,y1,b        a,x:(r5)+n5     y:(r0),a
        subl    b,a     
	  move    x:(r0),b        b,y:(r4)
        mac     -x1,x0,b        x:(r0)+n0,a     a,y:(r5)
        macr    -y1,y0,b        x:(r1),x1       y:(r6),y0
        subl    b,a             
	  move    b,x:(r4)+n4     y:(r0),b
_lastpass
        move    a,x:(r5)+n5
        endm
