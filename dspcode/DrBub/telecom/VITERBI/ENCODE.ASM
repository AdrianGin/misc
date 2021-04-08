;**************************************************************
; DESCRIPTION:
; This is a convolutional encoder for the V.32 which takes
; it's input from a file and and tests the output for all
; states as well as well as inputs. 
;
; REVISION HISTORY:
; Date           Change
; 12-09-1994     Initial placement
; 07-11-1998     Implementation on DSP56300 
;**************************************************************

locate  equ     $ee
statemem        equ     60
output  equ     50
input   equ     40
start   equ     $100
	org     p:start
	move    #statemem,r3
	do      #104,code
	move    #locate,r6
	move    #output,r5
	move    #input+3,r2   
	move    #>$1,x0
	move    y:(r6),a
	do      #4,loop
	and     x0,a    a,x1
	nop
	move    a1,x:(r2)-
	move    x1,a
	asr     a
	nop
loop
	jsr     encode
	move    #locate+1,r6
	move    #input,r2
	clr     b
	clr     a       y:(r4),b0
	addl    b,a
	do      #4,loop2
	move    x:(r2)+,b0
	addl    b,a
loop2
	nop
	move    a0,y:(r6)
code
return
	nop

encode
	move    #statemem,r1
	move    #input,r0
	move    #output,r4
	nop
	move    x:(r1)+,a
	move    x:(r0)+,x1
	and     x1,a    x:(r0),x0 a,y:(r4)
	move    x:(r1)-,b
	eor     x0,b    a,y0
	nop
	eor     y0,b    b,y1 
	nop
	move    b,x:(r1)+       y:(r4),b
	and     y1,b    x0,a
	move    (r1)+
	eor     x1,a    x:(r1),x0
	eor     x0,a    y:(r4),y1
	move    b,y0
	eor     y0,a    y1,x:(r1)-
	nop
	move    a,x:(r1)+
	rts
	
	end




	

