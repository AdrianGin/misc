;This the test case for sdmac.asm

;____________________________________
;How to test this case
;Function :  double presion(48 bit) * single (24 bit) and acumulate
;input number :  x:(r2)+   x:(r1)+              y:(r6)+
;                           msp          lsp            single
;have such Ncnt number.place in memery in sequence
;output number:x:(r0+1)   y:(r0+1)   x:(r0)
;              24bit       24bit          24bit   
;____________________________________
	include  "sdmac.asm"
input   equ     $ffffff
output  equ     $fffffe

    org    p:$250       
Fmain:
		 move #$10,r1                 ;; pointer to x lsp
	  move #$20,r2                 ;; pointer to x msp
	  move #$120,r6                 ;; pointer to y msp (single)
	  move #$120,m6                ;; to restore y pointer before second rep
	  move #$80,r0                 ;; pointer to products

    do #5,l_read
    move   x:input,a0                                       ;input data1 lsp
    move   x:input,a1                                       ;input data1 msp
    move   a0,x:(r1)+                           ;lsp of number
    move   a1,x:(r2)+                                   ;msp of number
l_read

    do #5,l_read1
    move   x:input,a0                                       ;input data2 
    move   a0,y:(r6)+                           ; number 2
l_read1

;restore every point
	  move #$10,r1                 ;; pointer to x lsp
	  move #$20,r2                 ;; pointer to x msp
	  move #$120,r6                 ;; pointer to y msp (single)
	  move #$120,m6                ;; to restore y pointer before second rep
	  move #$80,r0                 ;; pointer to products


     sdmac

;write output
     move       x:(r0)+,x0
     movep      x0,x:output
     move       l:(r0)-,a
     movep      a0,x:output
     movep      a1,x:output

	nop
return
     stop       
