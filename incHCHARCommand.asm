;*******************************************************************************
;* HCHAR Command                                                               *
;* This BASIC function put a string on a Hi-Res Screen                         *
;* *****************************************************************************
;* Syntax : HCHAR or h Shifted C                                               *
;* Inputs : X (0->319) and Y (0 ->199)                                         *
;*        : "text"                                                             *
;*******************************************************************************

; hchar : hchar x,y,"hello world"
COM_HCHAR
    lda #%10000000
    sta COMM_XLLO
    jmp COM_CHAR_START

HCHAR_ADDING_SECONDLINE
    lda COMM_Y1
    asl     ; x 2
    sta COMM_Y

    lda #14
    sec
    sbc COMM_Y
    clc
    adc COMM_YR
    sta COMM_Y

    lda COMM_X1LO
    clc
    adc COMM_XRLO
    sta COMM_XLO
    lda COMM_XRHI
    adc #0
    sta COMM_XHI
    jsr PLACE
    jsr DOT
    inc COMM_Y
    lda COMM_X1LO
    clc
    adc COMM_XRLO
    sta COMM_XLO
    lda COMM_XRHI
    adc #0
    sta COMM_XHI
    jsr PLACE
    jmp DOT
