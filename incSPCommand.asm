;*******************************************************************************
;* SP Command                                                                  *
;* This BASIC function to turn on and off a Sprite                             *
;* *****************************************************************************
;* Syntax : SP or sp Shifted O                                                 *
;* Inputs : ON / OFF Sprite #                                                  *
;*******************************************************************************

; sp : on/off #
COM_SP
    ;jsr bas_CHRGET$
    pha
    jsr bas_CHRGET$
    jsr GETSpriteNo
    pla

    cmp #TOKANISER_OFF
    bne @NextOption

    ;jsr bas_CHRGET$
    ;jsr GETSpriteNo

    jsr WorkOutSpriteBit
    lda BYTEMASK,x
    eor #%11111111
    and VICII_SPENA
    sta VICII_SPENA
    rts

@NextOption
    cmp #TOKANISER_ON
    bne @InvalidCommand

    ;jsr bas_CHRGET$
    ;jsr GETSpriteNo

    jsr WorkOutSpriteBit
    lda VICII_SPENA
    ora BYTEMASK,x
    sta VICII_SPENA
    rts

@InvalidCommand
    pla
    pla
    jmp SYNTAX_ERROR

;==============================================================================
; Get Sprite Number From Basic
; Output : x Reg = Sprite Number
; Error  : Illegal Quantity
;==============================================================================
GETSpriteNo
    jsr bas_GETBYTC$; Get Sprite Number
    cpx #8
    bcc @ValidSpriteNo
@IllegalError
    pla
    pla
    ; Illegal Qty Error
    jmp bas_IQERR$

@ValidSpriteNo
    rts
