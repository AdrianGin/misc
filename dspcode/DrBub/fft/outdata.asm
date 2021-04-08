;**********************************************************************************
; DESCRIPTION:
; OUTDATA.ASM
;  This macro outputs FFT results to specified files for test purpose.
;
; REVISION HISTORY:
; Date           Change
; 10-18-1998     Initial implementation on Motorola DSP56300
;**********************************************************************************
;
outdata   macro     points,data
;outdata   ident     1,1
;
; Complex input data
;        Real data in X memory
;        Imaginary data in Y memory
;
; Macro Call - outdata   points,data
;
;        points     number of points (2-32768, power of 2)
;        data       start of data buffer
;

	   move    #-1,m0        	;linear addressing
	   move    #-1,m4        	;linear addressing
	   move    #data,r0      	;initialize real input pointer
         move    #data,r4      	;initialize image input pointer
         do      #points,end_output
	   move    x:(r0)+,x0
	   move    y:(r4)+,y0
	   mpy	x0,x0,a
	   mac	y0,y0,a
;sqrt
; y  = double precision (48 bit) positive input number
; b  = 24 bit output root, a  = temporary storage
; x0 = guess, x1 = bit being tested, y1:y0 = input number

	  nop
	  move	a,y1
	  move	a0,y0
        clr     b    #<$40,x0           ; init root and guess
        move    x0,x1  			    ; init bit to test
        do      #23,_endl
                                        ;START OF LOOP
        mpy     -x0,x0,a                ; square and negate the guess
        add     y,a                     ; compare to double precision input
        tge     x0,b                    ; update root if input >= guess
        tfr     x1,a                    ; get bit to test
        asr     a                       ; shift to next bit to test
	  nop
        add     b,a      a,x1		    ; form new guess
	  nop
        move             a,x0		    ; save new guess
_endl                                   ;END OF LOOP

	  asl     #@cvi(@log(points)/@log(2)+0.5),b,b	;scale up the FFT results
        movep	b,y:$fffffd		
end_output
         endm



 

