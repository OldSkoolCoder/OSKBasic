;*******************************************************************************
;* CLG Routine                                                                 *
;* This clears the HiRes Screen                                                *
;* *****************************************************************************
;* Syntax : clg or                                                             *
;*******************************************************************************

COM_CLG
    lda #0
    sta RIBUF
    lda #>BITMAP_START
    sta RIBUF + 1

GRAP
    ldy #0
GRAP_Loop
    lda #0
    sta (RIBUF),y
    iny
    bne GRAP_Loop
    inc RIBUF + 1

    lda RIBUF + 1
    cmp #>BITMAP_END
    bne GRAP
    rts