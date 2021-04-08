;
; This program originally available on the Motorola DSP bulletin board.
; It is provided under a DISCLAIMER OF WARRANTY available from
; Motorola DSP Operation, 6501 Wm. Cannon Drive W., Austin, Tx., 78735.
;
; Last Update Feb.25,98   Version 1.0
;
; sort1t.asm - test program to
; sort by straight selection 
; (most efficient for smaller arrays)
; 
;
;Function description:
;  Sort this list of items in x memory space
;                44,55,12,42,94,18,06,67
;  Result:
;                06,12,18,42,44,55,67,94

        page    132,66,3,3
        opt     nomd,mex,cre,cex,mu,rc


INPUT   equ     $ffffff
OUTPUT  equ     $fffffe

        include 'sort1.asm'

; sort this list of items in x memory space
        org     x:$0
;LIST    dc      44,55,12,42,94,18,06,67
LIST    dc      0,0,0,0,0,0,0,0

; main program to call SORT1 macro
        org     p:$140

;first to read LIST from input port
        move    #LIST,r0
        ;rep #8
        do      #8,l_read
        movep    x:INPUT,a1
        nop
        move    a1,x:(r0)+
l_read
        sort1   LIST,8          ;sort the list of 8 items

        move    #LIST,r0
        do      #8,l_write
        move    x:(r0)+,a1
        movep   a1,x:OUTPUT
l_write
        NOP
return
        end

