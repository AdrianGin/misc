;
; This program originally available on the Motorola DSP bulletin board.
; It is provided under a DISCLAMER OF WARRANTY available from
; Motorola DSP Operation, 6501 Wm. Cannon Drive W., Austin, Tx., 78735.
;
; Last Update Feb.25,98   Version 1.0
;
;single X doubble mac 
;*******************************************************************

;Function description:
;    several number such as five number:a1-a5 (double presion 48 bit)
;    several number such as five number:b1-b5 (single presion 24 bit)
;    result = a1*b1 + a2*b2 .... + a5*b5
;    default value:a1..a5 = $000001000001
;                  b1..b5 = 000010
;       result should be:
;        000000 000014 000000 000014     

;____________________________________
;input number:  x:(r2)   x:(r1)         y:(r6)
;                           msp          lsp            single
;have such Ncnt number.place in memery in sequence
;output number:x:(r0+1)   y:(r0+1)   x:(r0)
;              24bit       24bit          24bit   
;____________________________________

Ncnt      equ $5
sdmac   macro
;          move #$10,r1                 ;; pointer to x lsp
;          move #$20,r2                 ;; pointer to x msp
;          move #$120,r6                 ;; pointer to y msp (single)
;          move #$120,m6                ;; to restore y pointer before second rep
;          move #$80,r0                 ;; pointer to products
	  clr a #0,y0
	  move x:(r1)+,x0 y:(r6)+,y1    ;; load y and lsp of x
	  rep #Ncnt
	  mac  x0,y1,a  x:(r1)+,x0 y:(r6)+,y1        ;; load y and lsp of x
	  nop
	  nop
		  move m6,r6                                    ;restore y pointer       
		  nop
		  nop
		  move a0,x:(r0)+                               ;to save the lsp of the result.
		  move x:(r2)+,x1 y:(r6)+,y1    ;; load y and lsp of x
		  nop
		  dmacss  y1,x1,a                       ;; msp*msp -> a, lsp of result -> x:(r0)+
	  move x:(r2)+,x1 y:(r6)+,y1     ;; load y and lsp of x
	  rep  #Ncnt-1
	  mac  y1,x1,a  x:(r2)+,x1 y:(r6)+,y1        ;; load y and lsp of x
		  nop    
	  move a,l:(r0)-               ;; result msp
		  endm
