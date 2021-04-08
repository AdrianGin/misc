;This the test case for dmac.asm 
;-----------------------------------------------------
;The input data place here
;         r1 points to an arry of dubble precision numbers     x space
;         r5 points to an arry of dubble precision numbers     y space

;The result place here
;           HH            HL            LH          LL
;         x:(r2+1)      y(r2+1)        x:(r2)      y:(r2)
;-----------------------------------------------------
        include "dmac.asm"
input   equ     $ffffff
output  equ     $fffffe
    org    p:$250       

Fmain:
    move   #$100,r1
    move   #$200,r5
    move   #$400,r0
    move   #$500,r2 

    move   x:input,a0                                       ;input data1 lsp
    move   x:input,a1                                       ;input data1 msp
    nop
    move   a0,x:(r1)+                           ;lsp of number
    move   a1,x:(r1)-                                   ;msp of number

    move   x:input,a0                                       ;input data2 lsp
    move   x:input,a1                                       ;input data2 msp

    nop
    move   a0,y:(r5)+                           ;lsp of number
    move   a1,y:(r5)-                                   ;msp of number

;***********************************

    dmac

;***********************************
    move   l:(r2)+,a10
    movep  a0,x:output
    movep  a1,x:output

    move   l:(r2)-,a10
    movep  a0,x:output
    movep  a1,x:output
    nop
return
     stop       
