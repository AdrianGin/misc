;*****************************************************************
; DESCRIPTION:
; This file contains DTMF Generation module routines
;
; REVISION HISTORY:
; Date             Change
; 03-12-1996       Initial placement
; 06-08-1998       Implementation on DSP56300
;*****************************************************************


	SECTION GEN
	
	PAGE    132,60,2,5
	TITLE   'DTMF Generation module routines'
	OPT     RC,MEX,NOMD,CEX,XR
	IDENT   1,1
	NOLIST
	INCLUDE 'equx.asm'
	INCLUDE 'dsx.asm'
	INCLUDE 'DTMF_EQU.INC'
	INCLUDE 'GEN.INC'
	INCLUDE 'COM.INC'
	LIST
	XDEF    gen,gen_init
	ORG     P:
;*******************************************************************************
; Subroutine:   gen                                                            *
;                                                                              *
; Description:  This routine generates DTMF digits with on/off time as         *
;               specified by the user. A mapping rule converts the digits to   *
;               cos(freq) representation for use by a Chebyshev recursive      *
;               sinewave generator. The routine plays each digit a duration    *
;               of on time and pauses for a duration of off time. At the end   *
;               of the user defined digit buffer, zero is returned by gen.     *
;                                                                              *
;*******************************************************************************
output  equ     $ffff95
input   equ     $ffff98

gen     move    #>1,x0                  ;
	move    y:GEN_samp_cnt,b        ; decrement sample counter
	sub     x0,b  y:GEN_off_time,y0 ;
	jge     gen_upd                 ;

	clr     b       y:GEN_dig_cnt,a ; decrement digit counter
	sub     x0,a                    ;
	tst     a       y:GEN_ptr,r0    ; if (dig_cnt < 0)
	jlt     gen_end                 ;   goto gen_end

	move    a,y:GEN_dig_cnt         ; fetch new digit
;        move    x:(r0)+,a               ;
	movep    x:input,a               ;fetch number from input port
	move    r0,y:GEN_ptr            ;
	encode  a                       ; encode digit
	move    x0,y:GEN_cos1           ; store low freq cos
	move    x0,y:GEN_sn11           ; init low freq state(n-1)
	move    y0,y:GEN_cos2           ; store high freq cos
	move    y0,y:GEN_sn21           ; init high freq state(n-1)
	move    #$7fffff,a              ;
	move    a,y:GEN_sn12            ; init low freq state(n-1)
	move    a,y:GEN_sn22            ; init high freq state(n-1)
	move    y:GEN_off_time,y0       ;
	move    y:GEN_on_time,b         ;
	add     y0,b                    ; add off + on times
	nop
gen_upd move    b,y:GEN_samp_cnt        ; update sample counter
	cmp     y0,b                    ; if (samp_cnt > off_time)
	jle     gen_end                 ;   goto gen_end
	move    y:GEN_sn11,x0           ; generate low freq tone
	move    y:GEN_cos1,x1           ;
	mpy     x0,x1,a y:GEN_sn12,x1   ;
	asl     a       x0,y:GEN_sn12   ;
	sub     x1,a                    ;
	nop
	asr     a       a,y:GEN_sn11    ;

	move    y:GEN_sn21,x0           ; generate high freq tone
	move    y:GEN_cos2,x1           ;
	mpy     x0,x1,b y:GEN_sn22,x1   ;
	asl     b       x0,y:GEN_sn22   ;
	sub     x1,b                    ;
	nop
	addr    a,b     b,y:GEN_sn21    ;

gen_end move    b,y:GEN_yn              ; store output sample
	movep    b,x:output
	rts

;*******************************************************************************
; Subroutine:   gen_init                                                       *
;                                                                              *
; Description:  GEN module initialization block, executed once each time       *
;               DTMF restarts.                                                 *
;                                                                              *
;*******************************************************************************
gen_init
	move    #GEN_START,r1           ; set default parameter values
	move    #GEN_DEF,r4             ;   from "GEN.INC"
	do      #GEN_SIZE,init1         ;
	move    y:(r4)+,a               ;
	nop
	move    a,y:(r1)+               ;
init1   clr     a                       ;
	move    #GEN_dig_buf,r1         ;
	move    a,y:GEN_samp_cnt        ; samp_cnt = 0
	move    r1,y:GEN_ptr            ; dig_ptr = dig_buf
	move    #COM_helpline,r4        ;
	move    y:GEN_dig_num,b         ; dig_cnt = dig_num
	move    b,y:GEN_dig_cnt         ;
	do      #10,init2               ; init dig_buf
	move    x:(r4)+,a               ;
	nop
	move    a,x:(r1)+               ;
init2   nop                             ;
	rts

	ENDSEC
