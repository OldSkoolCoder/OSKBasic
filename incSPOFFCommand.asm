;*******************************************************************************
;* SPROFF Command                                                              *
;* This BASIC function to turn off a Sprite                                    *
;* *****************************************************************************
;* Syntax : SPROFF or spo Shifted F                                            *
;* Inputs : Sprite #                                                           *
;*******************************************************************************

; sproff : #
COM_SPROFF
    jsr GETSpriteNo
    stx COMM_AXLO

    jsr WorkOutSpriteBit
    lda BYTEMASK,x
    eor #%11111111
    and VICII_SPENA
    sta VICII_SPENA
    rts
