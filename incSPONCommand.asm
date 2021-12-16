;*******************************************************************************
;* SPRON Command                                                               *
;* This BASIC function to turn on a Sprite                                     *
;* *****************************************************************************
;* Syntax : SPON or sp Shifted O                                               *
;* Inputs : Sprite #                                                           *
;*******************************************************************************

; spron : #
COM_SPRON
    jsr GETSpriteNo
    stx COMM_AXLO

    jsr WorkOutSpriteBit
    lda VICII_SPENA
    ora BYTEMASK,x
    sta VICII_SPENA
    rts

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
