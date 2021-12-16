;*******************************************************************************
;* SPRITE Command                                                              *
;* This BASIC function to set up a sprite on the system                        *
;* *****************************************************************************
;* Syntax : SPRITE or sp Shifted R                                             *
;* Inputs : Sprite No                                                          *
;*        : Sprite Pointer #                                                   *
;*        : Expanded X Enable / Disable                                        *
;*        : Expanded Y Enable / Disable                                        *
;*        : Background Priority Enable / Disable                               *
;*        : MultiColour Enable / Disable                                       *
;*******************************************************************************

; sprite : sprite no, xX, yY, background, multiCol
COM_SPRITE
    jsr GETSpriteNo
    stx COMM_AXLO

    jsr bas_CHKCOM$ ; Checks For a Comma
    jsr bas_GETBYTC$; Get Sprite Poointer#

    txa
    ldx COMM_AXLO   ; Sprite #
    sta SPRITE_POINTERS,x           ; Normal Text Mode
    sta SPRITE_POINTERS + $8000,x   ; Hi-Res Mode
    
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

;==============================================================================
; Get Sprite Number Bit Index
; Input  : COMM_AXLO
; Output : x Reg = Sprite Bit Number
;==============================================================================
WorkOutSpriteBit
    lda #7
    sec
    sbc COMM_AXLO
    tax
    rts
