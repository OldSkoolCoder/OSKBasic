;*******************************************************************************
;* CHAR Command                                                                *
;* This BASIC function puts a string on a Hi-Res Screen                        *
;* *****************************************************************************
;* Syntax : CHAR or ch Shifted A                                               *
;* Inputs : X (0->319) and Y (0 ->199)                                         *
;*        : "text"                                                             *
;*******************************************************************************

; char : char x,y,"hello world"
COM_CHAR
    lda #0
    sta COMM_XLLO           ; Flag For Double Height Chars

COM_CHAR_START
    jsr GetNo2      ; Get X
    sta COMM_XRLO
    sty COMM_XRHI

    jsr bas_CHKCOM$ ; Checks For a Comma
    jsr bas_GETBYTC$; Get Y
    stx COMM_YR

    jsr bas_CHKCOM$ ; Checks For a Comma

    jsr bas_FRMEVL$
    jsr bas_FRESTR$

    tay
    lda INDEX       ; Address Of String
    sta ROBUF
    lda INDEX + 1   ; Address Of String
    sta ROBUF + 1
    sty COMM_RXLO   ; Length Of String

    sec
    jsr krljmp_PLOT$
    sty COMM_AY
    stx COMM_AXLO

    lda SCREENRAM
    sta COMM_START

    lda #CHR_Home
    jsr krljmp_CHROUT$

    ldy #0
CHAR_Looper
    lda (ROBUF),y
    cmp #CHR_Space
    bcs @NotSpace

    jsr krljmp_CHROUT$
    iny
    jmp CHAR_Looper

@NotSpace
    cmp #161
    bcs @ContinueChar
    cmp #128
    bcc @ContinueChar
    jsr krljmp_CHROUT$
    iny
    jmp CHAR_Looper

@ContinueChar
    jsr krljmp_CHROUT$
    lda #CHR_Home
    jsr krljmp_CHROUT$

    lda SCREENRAM
    sta LINNUM
    lda #0
    sta LINNUM + 1

    asl LINNUM      ; x 2
    rol LINNUM + 1

    asl LINNUM      ; x 4
    rol LINNUM + 1

    asl LINNUM      ; x 8
    rol LINNUM + 1

    clc
    lda LINNUM + 1
    adc #$D0
    sta LINNUM + 1

    sty COMM_YY
    ldy #0

CHAR_LINE_Looper       ; Char2
    ldx #0
CHAR_PIXEL_Looper
    lda $DC0E
    and #$FE    ; %1111 1110
    sta $DC0E

    lda 1
    and #$FB    ; %1111 1011
    sta 1

READCharRom_Looper
    lda (LINNUM),y
    pha
    
    lda 1
    ora #4      ; %0000 0100
    sta 1

    lda $DC0E
    ora #$01    ; %0000 0001
    sta $DC0E
    
    pla
    and BYTEMASK,x
    cmp BYTEMASK,x
    beq CHAR_PLACEDOT       ; Char4

CHAR_PixelLooper
    inx
    cpx #8
    bne CHAR_PIXEL_Looper
    iny
    cpy #8
    bne CHAR_LINE_Looper

    ldx COMM_YY
    inx
    stx COMM_YY
    cpx COMM_RXLO           ; String Length
    beq CHAR_Finished

    lda COMM_XRLO
    clc
    adc #8
    sta COMM_XRLO
    bcc @SkipINC
    inc COMM_XRHI
@SkipINC
    ldy COMM_YY
    jmp CHAR_Looper

CHAR_Finished
    lda COMM_START
    sta SCREENRAM

    clc
    ldy COMM_AY
    ldx COMM_AXLO
    jmp krljmp_PLOT$

CHAR_PLACEDOT
    stx COMM_X1LO
    sty COMM_Y1

    txa
    clc
    adc COMM_XRLO
    sta COMM_XLO
    lda COMM_XRHI
    adc #0
    sta COMM_XHI

    lda #7
    sec 
    sbc COMM_Y1
    clc
    adc COMM_YR
    sta COMM_Y

    jsr PLACE

    lda COMM_XLLO           ; Bit 7 = 0 = Normal Size Chars, 1 = Double Height
    bpl @PlotDot
    jsr HCHAR_ADDING_SECONDLINE
    jmp @ByPassDot

@PlotDot
    jsr DOT

@ByPassDot
    ldx COMM_X1LO
    ldy COMM_Y1
    jmp CHAR_PixelLooper