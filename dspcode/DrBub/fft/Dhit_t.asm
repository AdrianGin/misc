;**********************************************************************************
; DESCRIPTION:
; DHIT_T.ASM	Hilbert Transform test program
;
; REVISION HISTORY:
; Date           Change
; 08-30-1988     Initial placement
; 11-18-1998     Implementation on Motorola DSP56300
;**********************************************************************************
;
;dhit_t	ident   1,0

        include 'dhit'

;
; Main program to call the Dhit macro
;
;       32 point complex Hilbert transform
;       Data starts at address 0
;


reset   equ     0
start   equ     $100
points  equ     32
data    equ     0          

        org     x:data			;generate input data in X & Y memory
angle   set     0.0
        dup     points
        dc      angle
angle   set     angle+0.01
        endm

        org     y:data
angle   set     0.9
        dup     points
	  dc	    angle	
angle   set     angle-0.01
        endm

        opt     mex
        org     p:reset
        jmp     start

        org     p:start
        movep   #$010000,X:$fffffb          ;Set BCR for 1 wait state
        dhit   points,data

;output data

	  move    #-1,m0			        ;linear addressing
	  move    #-1,m4			        ;linear addressing
	  move    #data,r0 		        ;initialize real input pointer
        move    #data,r4 		        ;initialize image input pointer
        do      #points,end_output
	  movep    x:(r0)+,y:$fffffd
	  movep    y:(r4)+,y:$fffffc
end_output
return
        end
