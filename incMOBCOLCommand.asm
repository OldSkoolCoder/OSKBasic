;*******************************************************************************
;* MOBCOL Command                                                              *
;* This BASIC function to set up the sprite multi colour options               *
;* *****************************************************************************
;* Syntax : MOBCOL or mo Shifted B                                             *
;* Inputs : MultiColour 1                                                      *
;*        : MultiColour 2                                                      *
;*******************************************************************************

; mobcol : multcol1, multicol2
COM_MOBCOL
    jsr bas_GETBYTC$; Get Colour #1
    cpx #16
    bcc @ValidColour1
    ; Illegal Qty Error
    jmp bas_IQERR$

@ValidColour1
    stx VICII_SPMC0

    jsr bas_CHKCOM$ ; Checks For a Comma
    jsr bas_GETBYTC$; Get Sprite Poointer#
    cpx #16
    bcc @ValidColour2
    ; Illegal Qty Error
    jmp bas_IQERR$

@ValidColour2
    stx VICII_SPMC1
    rts

    