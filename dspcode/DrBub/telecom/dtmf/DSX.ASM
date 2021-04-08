;       Macro for allocating memory and placing the def in global space.
;       Calling Parameters: Name = name of the mem location/first buffer
;       location; Num = number of locations to reserve.
dsx     MACRO   Name,Num
        XDEF    Name
Name    DS      Num
        ENDM
