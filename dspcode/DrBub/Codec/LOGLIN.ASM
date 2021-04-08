;
; This program originally available on the Motorola DSP bulletin board.
; It is provided under a DISCLAMER OF WARRANTY available from
; Motorola DSP Operation, 6501 Wm. Cannon Drive W., Austin, Tx., 78735.
; 
; Companded CODEC to Linear PCM Data Conversion Macros
; 
; Last Update 12 Mar 1998   Version 1.0
;
loglin  ident   1,0
;
; These macros convert 8 bit companded data received from CODEC A/D
; converters used in telecommunications applications to 13 bit, linear
; fractional data.  The internal mu/a-law lookup tables in the DSP56001
; X data ROM are used to minimize execution time.  Three companded
; formats are supported for the Motorola MC14400 CODEC series and
; similar devices.
;
; Macro Calls:          smlin - sign magnitude to linear conversion
;                               with mu-law companding.
;                       mulin - mu-law companded to linear conversion.
;                       allin - a-law companded to linear conversion
;                               with CCITT (G7.12) format.
;
;                       No macro arguments are required.  However, these
;                       macros assume that the scaling modes are off
;                       (S1=0, S0=0).
;
; Input data is in the 8 most significant bits of a1.  The remaining
; bits of a are ignored.
;
;  -------------------------------------------------------
; | Sign |    Chord Number    |       Step Number         |
; | Bit  |                    |                           |
; |__23__|__22_____21_____20__|__19_____18_____17_____16__|
;
; Output data is in the 56 bit accumulator a.  The linear fraction is
; in the 13 most significant bits of a1 and the 11 least significant
; bits are zero.
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
; Latest Revision - April 15, 1987
; Tested and verified - April 20, 1987
;
; smlin - sign magnitude to linear conversion
;

smlin  macro
;
        move    a1,y1                   ;save input

;        bclr    #23,a1
        move    #$00302c,x0             ;get chord number
        clr     b
        extractu x0,a,b
        nop
        move    b0,x1                   ;save chord number
        move    #7,b1
        sub     x1,b
        asl #3,a,a                        ;produce 1****1 step number
        move    b1,x0
        
        bset    #23,a1
        nop
        bset    #18,a1


        move    #0,a2
        asr     x0,a,b                      ;produce result
        nop
        tfr    b,a

        move    y1,b
        neg     b                       ;invert sign bit
        asl     b
        ror     a                       ;get sign bit
        endm

;
; mulin - mu-law to linear conversion
;
mulin   macro
;
        not     a
        and     #$ff0000,a
        nop
        move    a1,y1                   ;save input

        move    #$00302c,x0             ;get chord number
        clr     b
        extractu x0,a,b
        move    #7,b1
        nop
        move    b0,x1                   ;save chord number
        sub     x1,b
        asl #3,a,a  
        move    b1,x0
        
        ;produce 1****1 step number
        bset    #23,a1
        nop
        bset    #18,a1
        
        move    #0,a2
        asr     x0,a,b                      ;produce result
        tfr    b,a

        btst    #23,y1
        ror     a                       ;get sign bit
        endm
;
; allin - a-law to linear conversion
;
allin   macro
;
        move    a1,y1                   ;save input
        eor     #$550000,a

        move    #$00302c,x0             ;get chord number
        clr     b
        extractu x0,a,b
        nop
        move    b0,x1                   ;save chord number
        move    #7,b1
        sub     x1,b
        asl #3,a,a                        ;produce 1****1 step number
        move    b1,x0
        
        bset    #23,a1
        nop
        bset    #18,a1
      
        move    #0,a2
        asr     x0,a,b                      ;produce result
        nop
        tfr    b,a

        move    y1,b
        neg     b
        asl     b
        ror     a                       ;get sign bit
        and     #$fff000,a
        endm
