;*****************************************************************
; DESCRIPTION:
; This file contains DTMF ROM tables
;
; REVISION HISTORY:
; Date          Change
; 03-12-1996    Initial placement
; 06-08-1998    Implementation on DSP56300
;*****************************************************************

	include "equx.asm"
	SECTION DTMF_ROM

	PAGE    132,60,2,5
	TITLE   'DTMF ROM tables'
	OPT     RC,MEX,NOMD,CEX,XR
	IDENT   1,1

f11     equ     697
f12     equ     770
f13     equ     852
f14     equ     941

f21     equ     1209
f22     equ     1336
f23     equ     1477
f24     equ     1633

fs      equ     8000
pi      equ     4.0*@atn(1.0)

c11     equ     @Cos(2*pi*f11/fs)
c12     equ     @Cos(2*pi*f12/fs)
c13     equ     @Cos(2*pi*f13/fs)       
c14     equ     @Cos(2*pi*f14/fs)       
		
c21     equ     @Cos(2*pi*f21/fs)       
c22     equ     @Cos(2*pi*f22/fs)       
c23     equ     @Cos(2*pi*f23/fs)       
c24     equ     @Cos(2*pi*f24/fs)       

c31     equ     @Cos(2*pi*2*f11/fs)
c32     equ     @Cos(2*pi*2*f12/fs)
c33     equ     @Cos(2*pi*2*f13/fs)     
c34     equ     @Cos(2*pi*2*f14/fs)     
		
c41     equ     @Cos(2*pi*2*f21/fs)     
c42     equ     @Cos(2*pi*2*f22/fs)     
c43     equ     @Cos(2*pi*2*f23/fs)     
c44     equ     @Cos(2*pi*2*f24/fs)     


	ORG     Y:
	equx    COM_DfTbl,*     ; Detector (frequency) table
				; Length = Max_ND

	dc      c11             ; f11 = 697
	dc      c12             ; f12 = 770
	dc      c13             ; f13 = 852     
	dc      c14             ; f14 = 941     
		   
	dc      c21             ; f21 = 1209    
	dc      c22             ; f22 = 1336    
	dc      c23             ; f23 = 1477    
	dc      c24             ; f24 = 1633    

	dc      c31             ; f11 = 697
	dc      c32             ; f12 = 770
	dc      c33             ; f13 = 852     
	dc      c34             ; f14 = 941     
		   
	dc      c41             ; f21 = 1209    
	dc      c42             ; f22 = 1336    
	dc      c43             ; f23 = 1477    
	dc      c44             ; f24 = 1633    

	ORG     X:
	equx    COM_maptbl,*    ; map table
	dc      c14,c22,$0      ; 0
	dc      c11,c21,$1      ; 1
	dc      c11,c22,$2      ; 2
	dc      c11,c23,$3      ; 3
	dc      c12,c21,$4      ; 4
	dc      c12,c22,$5      ; 5
	dc      c12,c23,$6      ; 6
	dc      c13,c21,$7      ; 7
	dc      c13,c22,$8      ; 8
	dc      c13,c23,$9      ; 9
	dc      c11,c24,$A      ; A
	dc      c12,c24,$B      ; B
	dc      c13,c24,$C      ; C
	dc      c14,c24,$D      ; D
	dc      c14,c21,$E      ; *
	dc      c14,c23,$F      ; #

	equx    COM_helpline,*  ; generated at startup (demo)
	dc      5,1,2,8,9,1,3,2,3,0
	ENDSEC
