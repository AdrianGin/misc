;
; This program originally available on the Motorola DSP bulletin board.
; It is provided under a DISCLAMER OF WARRANTY available from
; Motorola DSP Operation, 6501 Wm. Cannon Drive W., Austin, Tx., 78735.
; 
; Binary to Gray Coded Value Test Program
; 
; Last Update 21 May 1998   Version 1.0
;
bingrayt        ident   1,0
;
;       binary value to gray coded value test program
;
        opt     cex
        page    132,66,0,0
        
        include 'bingray.asm'
output  equ     x:$ee
        org     p:$100
start
        clr     b       #>1,x1          ;clear count, load increment
;        move    #0,r0                   ;pointer to memory
        move    #-1,m0                  ;linear addressing
        do      #64,_endtest
        tfr     b,a                     ;value to convert
        nop
        bingray                         ;convert a1 to gray code (uses x0)
        nop
        add     x1,b  a1,x:output        ;inc b, save result in memory
_endtest
        nop
return
        end
