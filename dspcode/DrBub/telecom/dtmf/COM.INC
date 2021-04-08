;--- encode macro ----
; syntax: encode <register>
; input:  digit (0-15)
; output: x0=low freq cos
;         y0=high freq cos
; use:    r7,n7,x0,y0
encode  macro   dig
        move    #COM_maptbl,r7
        move    dig,n7
        nop
        nop
        nop

        move    (r7)+n7
        move    (r7)+n7
        move    (r7)+n7
        move    x:(r7)+,x0
        move    x:(r7)+,y0
        endm

;--- decode macro ----
; syntax: decode <reg1,reg2>
; input:  low freq cos, high freq cos
; output: a=digit (0-15)
; use:    r7,x0,x1,y0,a
decode  macro   cc1,cc2
        move    #COM_maptbl,r7
        move    cc1,x0
        move    cc2,y0
        do      #16,_xx
        move    x:(r7)+,a
        cmp     x0,a    x:(r7)+,x1
        jne     _no
        tfr     x1,a
        cmp     y0,a
        jne     _no
        enddo
        nop
_no     move    x:(r7)+,a
_xx     nop
xixi    nop
        endm
