;*******************************************************************************
;* MOB Command                                                                 *
;* This BASIC function to set up a sprite on the system                        *
;* *****************************************************************************
;* Syntax : MOB or m Shifted O                                                 *
;* Inputs : Sprite No                                                          *
;*        : Sprite Pointer #                                                   *
;*        : Enable / Disable                                                   *
;*        : Expanded X Enable / Disable                                        *
;*        : Expanded Y Enable / Disable                                        *
;*        : Background Priority Enable / Disable                               *
;*        : MultiColour Enable / Disable                                       *
;*******************************************************************************

; mob : sprite no, enable, xX, yY, background, multiCol
COM_MOB
    jsr bas_GETBYTC$; Get Sprite Number
    cpx #8
    bcc @ValidSpriteNo
    ; Illegal Qty Error
    jmp bas_IQERR$

@ValidSpriteNo
    stx COMM_AXLO

    jsr bas_CHKCOM$ ; Checks For a Comma
    jsr bas_GETBYTC$; Get Sprite Poointer#

    txa
    ldx COMM_AXLO   ; Sprite #
    sta SPRITE_POINTERS,x           ; Normal Text Mode
    sta SPRITE_POINTERS + $8000,x   ; Hi-Res Mode
    
    lda VICII_SPENA
    jsr MOBPARAMGET
    sta VICII_SPENA

    lda VICII_XXPAND
    jsr MOBPARAMGET
    sta VICII_XXPAND

    lda VICII_YXPAND
    jsr MOBPARAMGET
    sta VICII_YXPAND

    lda VICII_SPBGPR
    jsr MOBPARAMGET
    sta VICII_SPBGPR

    lda VICII_SPMC
    jsr MOBPARAMGET
    sta VICII_SPMC
    rts

MOBPARAMGET
    sta COMM_AY
    jsr bas_CHRGOT$
    jsr bas_CHKCOM$     ; Get Comma

    jsr bas_GETBYTC$    ; Get # 0->255
    cpx #2
    bcc @ValueOK
    jmp bas_IQERR$
@ValueOK
    cpx #0
    beq @Disable
    jsr WorkOutSpriteBit
    lda COMM_AY
    ora BYTEMASK,x
    rts

@Disable
    jsr WorkOutSpriteBit
    lda BYTEMASK,x
    eor #%11111111
    and COMM_AY
    rts

WorkOutSpriteBit
    lda #7
    sec
    sbc COMM_AXLO
    tax
    rts
