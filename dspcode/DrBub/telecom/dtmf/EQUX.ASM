;       Macro for defining a logical equate and placing the def in global space.
;       Calling Parameters: Name = name of the equ ; Val = Value of the equate.
equx    MACRO   Name,Val
        XDEF    Name
Name    EQU     Val
        ENDM
