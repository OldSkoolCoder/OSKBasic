;*******************************************************************************
;* PLOT Command                                                                *
;* This BASIC function put a dot in the Hi-Res Screen                          *
;* *****************************************************************************
;* Syntax : PLOT or p Shifted L                                                *
;* Inputs : X (0->319) and Y (0 ->199)                                         *
;*******************************************************************************

; plot : plot x,y
COM_POINT
    jsr GETNo2      ; Get X Coords = 2 bytes
    sta COMM_XLo
    sty COMM_XHi

    jsr bas_CHKCOM$
    jsr bas_GETBYTC$
    stx COMM_Y

    jsr PLACE       ; Works out the memory location to change
    jmp DOT         ; Sets the bit location odf the memory location

    