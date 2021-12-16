;*******************************************************************************
;* COLOUR Command                                                              *
;* This BASIC function Set the background colours                              *
;* *****************************************************************************
;* Syntax : COLOUR or co Shifted L                                             *
;* Inputs : Border Colour (0->15)                                              *
;*        : Background Colour (0 ->15)                                         *
;*        : Background Colour1 (0 ->15)  (optional)                            *
;*        : Background Colour2 (0 ->15)  (optional)                            *
;*        : Background Colour3 (0 ->15)  (optional)                            *
'*******************************************************************************

; colour : colour a, b, (c, d, e)
COM_COLOUR
    jsr bas_GETBYTC$
    stx VICII_EXTCOL
    jsr bas_CHKCOM$ ; Checks For a Comma

    jsr bas_GETBYTC$
    stx VICII_BGCOL0
    stx COMM_GRAPHIC_COLOUR

    cmp #44
    bne COLOUR_END
    jsr bas_CHRGET$
    jsr bas_GETBYTC$
    stx VICII_BGCOL1

    cmp #44
    bne COLOUR_END
    jsr bas_CHRGET$
    jsr bas_GETBYTC$
    stx VICII_BGCOL2

    cmp #44
    bne COLOUR_END
    jsr bas_CHRGET$
    jsr bas_GETBYTC$
    stx VICII_BGCOL3

COLOUR_END
    jmp GRAP_ClearScreen