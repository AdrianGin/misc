linlog  ident   1,1
;
; This program, originally available on the Motorola DSP bulletin board,
; is provided under a DISCLAIMER OF WARRANTY available from Motorola DSP
; Operation, 6501 William Cannon Drive, West, Austin, Texas  78735-8598.
;
;
; Linear PCM to Companded CODEC Data Conversion Macros
;
; These macros convert 13 bit, linear fractional data into 8 bit companded
; data suitable for transmission to CODEC D/A converters used in
; telecommunications applications.  Four companded formats are
; supported for the Motorola MC14400 CODEC series and similar devices.
;
; Macro Calls:          linsm - linear to sign magnitude conversion
;                               with mu-law companding.
;                       linmu - linear to mu-law companded conversion
;                               without zero code suppression.
;                       lind3d4 - linear to mu-law companded conversion
;                               with D3/D4 format zero code suppression.
;                       linal - linear to a-law companded conversion
;                               with CCITT (G7.12) format.
;
;                       No macro arguments are required.  However, these
;                       macros assume that the scaling modes are off
;                       (S1=0, S0=0).
;
; Input data is a 56 bit number in accumulator a.  Although any 56 bit
; number may be used, the 13 bit linear fraction is assumed to be in
; the most significant bits of a1.  Values outside this fractional range
; are automatically converted to a maximum positive or negative companded
; value (dynamic range limiting).
;
; Output data is in the 8 most significant bits of a1.  The 16 LSB's
; of a1 are zero.
;
;  -------------------------------------------------------
; | Sign |    Chord Number    |       Step Number         |
; | Bit  |                    |                           |
; |__23__|__22_____21_____20__|__19_____18_____17_____16__|
;
; Alters Data ALU Registers
;       x1      x0
;       a2      a1      a0      a
;       b2      b1      b0      b
;
; Alters Address Registers
;       r0
;
; Alters Program Control Registers
;       pc      sr
;
; Uses 0 locations on System Stack
;
; Latest Revision - Mar 12, 1998
; Tested and verified - Mar 12, 1998
;
; linsm - linear to sign magnitude conversion
;
linsm   macro
_bias   equ     $008400         ;absolute bias = 33
;

	move a,y1                      ;save input sign
	move a,a                        ;limit input data

	abs     a       #_bias,x0       ;form input magnitude, get bias
	add     x0,a    #7,r0   ;add bias to magnitude, get chord bar
	nop
	move            a,a             ;limit again
	tst     a                               ;set CCR for norm instruction


	clb a,b                             ;find chord number by normalizing
	normf b1,a                      ; biased magnitude to get step number
	add #7,b

	asl     #2,a,a                  ;isolate step number
					;and limit input again

	move b1,a2                      ;get chord number
	asr     #3,a,a                  ;combine chord and step

	move y1,b
	neg b                           ;invert sign bit
	asl     b                               ;get sign bit

	ror     a       #<$ff,x0        ;combine sign, chord and step
	and     x0,a                    ;clear 16 LSB's

	endm



;
; linmu - linear to mu-law conversion
;
linmu   macro
_bias   equ     $008400                 ;absolute bias = 33
;
	move a,y1                      ;save input sign
	move a,a                        ;limit input data

	abs     a       #_bias,x0       ;form input magnitude, get bias
	add     x0,a    #7,r0   ;add bias to magnitude, get chord bar
	nop
	move            a,a             ;limit again
	tst     a                               ;set CCR for norm instruction

	clb a,b                         ;find chord number by normalizing
	normf b1,a                      ; biased magnitude to get step number
	add #7,b

	asl     a                               ;isolate step number
	asl     a                               ;limit input again
	
	move b1,a2

	asr     #3,a,a                  ;combine chord and step
	not     a                               ;invert 7 LSB's for mu-law
	move    y1,b
	neg     b
	asl     b                               ;get sign bit
	ror     a       #<$ff,x0        ;combine sign, chord and step
	and     x0,a                    ;clear 16 LSB's
	endm
;
; lind3d4 - linear to mu-law conversion with zero code suppression
;
lind3d4 macro
_bias   equ     $008400                 ;absolute bias = 33
;
	move a,y1                      ;save input sign
	move a,a                        ;limit input data

	abs     a       #_bias,x0       ;form input magnitude, get bias
	add     x0,a    #7,r0   ;add bias to magnitude, get chord bar
	nop
	move            a,a             ;limit again
	tst     a                               ;set CCR for norm instruction

	clb a,b                         ;find chord number by normalizing
	normf b1,a                      ; biased magnitude to get step number
	add #7,b

	asl     a                               ;isolate step number
	asl     a                               ;limit input again
	
	move  b1,a2                     ; get chord number
	asr     #3,a,a                  ;combine chord and step
	not     a                               ;invert 7 LSB's for mu-law

	move y1,b
	neg b                           ;invert sign bit
	asl     b                               ;get sign bit
	ror     a       #<$ff,x0        ;combine sign, chord and step
	and     x0,a    #<$02,x0 ;clear 16 LSB's
	teq     x0,a                    ;suppress zero code
	endm
;
; linal - linear to a-law conversion
;
linal   macro
	move a,y1                      ;save input sign
	move a,a                        ;limit input data

	move            #1,a0   ;force to non-zero value
	abs     a                       ;form input magnitude, get chord bar
	clb a,b                         ;find chord number by normalizing
	cmp     #-6,b
	jge     <_ok
	move    #-6,b

	normf   b1,a
	add     #6,b
	jmp     xixi
_ok     normf b1,a                      ; biased magnitude to get step number
	add #7,b
xixi
	nop
	asl     a  b1,r0                 ;isolate step number
	asl     a  y1,b                              ;limit input again

	neg     b  r0,a2                      ;invert sign bit
	asr     #3,a,a                  ;combine chord and step
	asl     b                               ;get sign bit
	ror     a       #<$ff,x0        ;combine sign, chord and step
	and     x0,a    #<$55,x0 ;clear 16 LSB's
	eor     x0,a                    ;invert odd bits for a-law
	endm
