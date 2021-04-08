;**************************************************************
; DESCRIPTION:
; FPINIT - FLOATING POINT LIBRARY INITIALIZATION SUBROUTINE
;
; REVISION HISTORY:
; Date           Change
; 10-05-1987     Initial placement
; 11-19-1998     Implementation on DSP56300 
;**************************************************************
;
fpinit  ident   1,0
;
;
; Entry point:  fpinit  Initialize address pointers for DSP56300 
;                       floating point subroutine library.
;
; Input variables:      none
;
; Output variables:
;
;       m0 = $ffff  (linear address modifier)
;
;       The X or Y data memory space (without the colon) used for the
;       shift constant table must be specified in single quotes by a
;       DEFINE directive for the global symbol "fp_space" and the base
;       address of the shift constant table must be specified for the
;       global symbol "fp_temp" via an EQU or similar directive.  An
;       example is given below.
;
;               define  fp_space        'x'
;       fp_temp equ     $0000
;
; Error conditions:     none
;
; Memory requirements:  8 locations in "fp_space" memory space
;
; Alters Address Registers
;               m0
;
; Alters Program Control Registers
;       pc      sr
;
; Uses 0 locations on System Stack
;
;
        org     fp_space:fp_temp
        ds      4       		;temporary storage locations
fp_23   dc      23      		;exponent delta limit
fp_ebias dc     $001fff 		;fixed point exponent bias
fp_emax dc      $003fff 		;maximum exponent
fp_m1   dc      $ffffff
;
        org p:
fpinit  move    fp_space:fp_m1,m0   ;initialize linear address modifier
        and     #$f3,mr         	;reset scaling modes (S1,S0)
        and     #$bf,ccr        	;reset overflow flag (L bit)
        rts
