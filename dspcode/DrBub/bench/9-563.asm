;**********************************************************************
; Description:                                                        *
;  9-563.asm                                                          *
;        DSP56300                                                     *
;        Matrix Multiply, [3x3] times [3x1]                           *
;                                                                     * 
;**********************************************************************
;  REVISION HISTORY:                                                  *
;   Date           Change                                             *
;   June 30,1988    Initial placement                                 *
;   Aug  24,1998    Implementation on DSP56300 	                      * 
;**********************************************************************
;
;
;       This routine computes the product of a [3x3] matrix and a
;       [3x1] column vector for the DSP56000. 
;
;       Matrix a is in X memory, 
;       vector b is in Y memory, 
;       the resulting vector c is stored in Y memory. 
;
;       All matrices are in "row major" format.
;
;
;    X Memory         Y Memory
;
; |->| a33 |          |     |
; |  | a32 |          |     |
; |  | a31 |      |-->| b3  |
; |  | a23 |      |   | b2  |
; |  | a22 |      |-->| b1  |
; |  | a21 |       r4 |     |
; |  | a13 |          |     |
; |  | a12 |           
; |->| a11 |      |-->| c3  |
; r0 |     |      |   | c2  |
;    |     |      |-->| c1  |
;                  r5
;
;Note: the previous assumes that all immediate addressing is
;immediate short, i.e. all data is in internal memory.
;
;**************************************************************************



  
mata    equ     $10
vecb    equ     $10
vecc    equ     $20
start	equ	$000100
        org     x:mata
        dc      0.82
        dc     -0.22 
        dc     -0.77
        dc     -0.13
        dc      0.5
        dc      0.11
        dc      0.56
        dc      0.9
        dc      -0.88
       

        org     y:vecb
        dc      0.46
        dc      -0.92
        dc      0.03
        org     p:start
;*****************************************************************
        move #<mata,r0                          ;point to matrix a
        move #<vecb,r4                          ;point to vector b
        move #<2,m4                             ;address b modulo 3
stage1  move #<vecc,r5                          ;point to vector c
        nop
        nop
        move          x:(r0)+,x0  y:(r4)+,y0   ;initialize x0, y0
        mpy  x0,y0,a  x:(r0)+,x0  y:(r4)+,y0   ;a11*b1
        mac  x0,y0,a  x:(r0)+,x0  y:(r4)+,y0   ;+a12*b2
        macr x0,y0,a  x:(r0)+,x0  y:(r4)+,y0   ;+a13*b3->c1
        nop
        move                      a,y:(r5)+    ;store c1
        mpy  x0,y0,a  x:(r0)+,x0  y:(r4)+,y0   ;a21*b1
        mac  x0,y0,a  x:(r0)+,x0  y:(r4)+,y0   ;+a22*b2
        macr x0,y0,a  x:(r0)+,x0  y:(r4)+,y0   ;+a23*b3->c2
        nop
        move                      a,y:(r5)+    ;store c2
        mpy  x0,y0,a  x:(r0)+,x0  y:(r4)+,y0   ;a31*b11
        mac  x0,y0,a  x:(r0)+,x0  y:(r4)+,y0   ;+a32*b2
        macr x0,y0,a                           ;+a33*b3->c3
        nop
        move                      a,y:(r5)+    ;store c3
;**********************************************************
        end

