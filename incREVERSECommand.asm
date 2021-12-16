;*******************************************************************************
;* REVERSE Command                                                             *
;* This BASIC function will negative the screen                                *
;* *****************************************************************************
;* Syntax : REVERSE or re Shifted V                                            *
;* Inputs :                                                                    *
;*        :                                                                    *
;*******************************************************************************

; reverse : reverse
COM_REVERSE
    lda #$00
    sta RIBUF
    lda #$A0
    sta RIBUF + 1

    jsr BANK_OUT_ROM

@OuterLooper
    ldy #00
@InnerLooper
    lda (RIBUF),y
    eor #%11111111
    sta (RIBUF),y

    iny
    bne @InnerLooper
    
    inc RIBUF + 1
    lda RIBUF + 1
    cmp #$BF
    bne @OuterLooper

    jsr BANK_IN_ROM

    rts
    