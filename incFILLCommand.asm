;*******************************************************************************
;* FILL Command                                                                *
;* This BASIC function fills in an area on the hi-res screen                   *
;* *****************************************************************************
;* Syntax : FILL or f Shifted I                                                *
;* Inputs : X (0 -> 319)                                                       *
;*        : Y (0 -> 199)                                                       *
;*******************************************************************************

; fill : x,y
COM_FILL
    jsr GetNo2      ; Get X
    sta COMM_XRLO
    sty COMM_XRHI

    jsr bas_CHKCOM$ ; Checks For a Comma
    jsr bas_GETBYTC$; Get Y
    stx COMM_YR

    lda #1          ; Fill Up
    sta COMM_AY
    jsr FILL_START
    lda #$FF        ; Fill Down
    sta COMM_AY

FILL_START
    lda COMM_YR
    sta COMM_YY

FILL_LOOPER_ROW
FILL2
    lda COMM_XRLO
    sta COMM_XXLO
    lda COMM_XRHI
    sta COMM_XXHI

    jsr BANK_OUT_ROM

FILL_TESTING_LEFT
    jsr FILL_TESTPIXEL
    beq FILL_TESTING_RIGHT

    sec
    lda COMM_XXLO
    sbc #1
    sta COMM_XXLO
    bcs @ByPassDEC
    dec COMM_XXHI

@ByPassDEC
    lda COMM_XXHI
    cmp #0
    bne @Continue
    lda COMM_XXLO
    cmp #0
    beq FILL_TESTING_RIGHT
@Continue
    jmp FILL_TESTING_LEFT

FILL_TESTING_RIGHT
    lda COMM_XXLO
    sta COMM_X1LO
    lda COMM_XXHI
    sta COMM_X1HI
    lda COMM_XRLO
    sta COMM_XXLO
    lda COMM_XRHI
    sta COMM_XXHI

FILL5
    jsr FILL_TESTPIXEL
    beq FILL_DRAWLINE

    clc
    lda COMM_XXLO
    adc #1
    sta COMM_XXLO
    bcc @ByPassINC
    inc COMM_XXHI

@ByPassINC
    lda COMM_XXHI
    cmp #1
    bne @Continue
    lda COMM_XXLO
    cmp #64
    beq FILL_DRAWLINE
@Continue
    jmp FILL5
    
FILL_DRAWLINE
FILL6
    jsr BANK_IN_ROM

    lda COMM_XXLO
    sta COMM_X2LO
    lda COMM_XXHI
    sta COMM_X2HI
    lda COMM_YY
    sta COMM_Y2
    sta COMM_Y1
    jsr DRAW_LINE_START

    clc
    lda COMM_YY
    adc COMM_AY
    sta COMM_YY

    cmp #255
    bne @Continue
    jmp FILL_END
@Continue
    cmp #200
    bne @CanWeContinue
    jmp FILL_END

@CanWeContinue
    jsr BANK_OUT_ROM

    lda COMM_XRLO
    sta COMM_XLO
    lda COMM_XRHI
    sta COMM_XHI
    lda COMM_YY
    sta COMM_Y
    jsr FILL_PIXELTEST
    beq FILL_END
    jmp FILL_LOOPER_ROW

FILL_END
    jsr BANK_IN_ROM
    rts

FILL_TESTPIXEL
    lda COMM_XXLO
    sta COMM_XLO
    lda COMM_XXHI
    sta COMM_XHI

    lda COMM_YY
    sta COMM_Y

FILL_PIXELTEST
    jsr PLACE

    ldx COMM_C
    lda BYTEMASK,x
    ldy #0
    and (STAL),y
    cmp BYTEMASK,x
    rts
