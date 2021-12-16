;*******************************************************************************
;* DRAW Command                                                                *
;* This BASIC function put a line on a Hi-Res Screen                           *
;* *****************************************************************************
;* Syntax : DRAW or d Shifted R                                                *
;* Inputs : X1 (0->319) and Y1 (0 ->199)                                       *
;*        : X2 (0->319) and Y2 (0 ->199)                                       *
;*******************************************************************************

; draw : draw x1,y1 to x2,y2
COM_DRAW
    jsr GetNo2      ; Get X1
    sta COMM_X1LO
    sty COMM_X1HI

    jsr bas_CHKCOM$ ; Checks For a Comma
    jsr bas_GETBYTC$; Get Y1
    stx COMM_Y1

    lda #164
    jsr bas_SYNCHR$ ; Check For the BASIC Command 'TO'

    jsr GetNo2      ; Get X2
    sta COMM_X2LO
    sty COMM_X2HI

    jsr bas_CHKCOM$ ; Checks For a Comma
    jsr bas_GETBYTC$; Get Y2
    stx COMM_Y2

DRAW_LINE_START
Draw_Eval_X
    lda COMM_X1HI
    cmp COMM_X2HI   ; Compare Hi Byte of X1 and X2
    beq @InXHi      ; X1Hi = X2Hi
    bcs @X1GTX2     ; X1Hi > X2Hi
    bcc @X1LTX2     ; X1Hi < X2Hi

@InXHi
    lda COMM_X1LO
    cmp COMM_X2LO   ; Compare Lo Byte of X1 and X2
    bcc @X1LTX2     ; X1Lo < X2Lo

@X1GTX2             ; X1 > X2
    sec
    lda COMM_X1LO
    sbc COMM_X2LO
    sta COMM_XDLO   ; Difference of X Lo byte

    lda COMM_X1HI
    sbc COMM_X2HI
    sta COMM_XDHI   ; Difference of X Hi byte

    lda #$38        ; SEC Instruction
    ldx #$e5        ; SBC ZeroPage Instruction
    jsr PREPAREXCALC; Alters X Draw Routine to "SUBTRACT"
    jmp DRAW_EVAL_Y

@X1LTX2             ; X1 < X2
    sec
    lda COMM_X2LO
    sbc COMM_X1LO
    sta COMM_XDLO   ; Difference of X Lo byte

    lda COMM_X2HI
    sbc COMM_X1HI
    sta COMM_XDHI   ; Difference of X Hi byte

    lda #$18        ; CLC Instruction
    ldx #$65        ; ADC ZeroPage Instruction
    jsr PREPAREXCALC; Alters X Draw Routine to "ADD"

DRAW_EVAL_Y
    lda COMM_Y1
    cmp COMM_Y2     ; Compare Y1 and Y2
    bcc @Y1LTY2     ; Y1 < Y2

    sec             ; Y1 >= Y2
    lda COMM_Y1
    sbc COMM_Y2
    sta COMM_YD     ; Difference of Y
    
    lda #$38        ; SEC Instruction
    ldx #$e5        ; SBC ZeroPage Instruction
    jsr PREPAREYCALC; Alters Y Draw Routine to "SUBTRACT"
    jmp DRAW_DeltaCalc

@Y1LTY2             ; Y1 < Y2
    sec
    lda COMM_Y2
    sbc COMM_Y1
    sta COMM_YD     ; Difference of Y
    
    lda #$18        ; CLC Instruction
    ldx #$65        ; ADC ZeroPage Instruction
    jsr PREPAREYCALC; Alters Y Draw Routine to "ADD"

DRAW_DeltaCalc
    lda COMM_XDHI
    cmp #1
    beq DRAW_ALONG_XAXIS; Is XDelta = 1 as Y will never be :(
    lda COMM_XDLO   ; XDelta <> 1
    cmp COMM_YD
    bcs DRAW_ALONG_XAXIS; X Delta >= Y Delta
    jmp DRAW_ALONG_YAXIS; X Delta < Y Delta

DRAW_ALONG_XAXIS
    lda COMM_YD
    cmp #0
    bne DRAW_WORK_OUT_XRATIO
    jsr DRAW_SETFPA1_TO_ZERO
    jmp DRAW_XAXIS_START
    
DRAW_WORK_OUT_XRATIO
    ldx COMM_YD
    ldy COMM_XDLO
    stx COMM_XXLO
    lda #0
    sta COMM_XXHI
    sty COMM_YY
    lda COMM_XDHI
    sta 246

    jsr DIVIDE_XX_BY_YY
    jsr DRAW_MOVE_FPA1_TO_MEMORY
    jmp DRAW_XAXIS_START

DIVIDE_XX_BY_YY
    lda COMM_XXHI
    ldy COMM_XXLO
    jsr bas_GIVAYF$ ; Converts XX into a Floating Point Value in FPA1
    jsr bas_MOVEFP1FP2$ ; Moves FPA1 -> FPA2
    lda 246
    ldy COMM_YY
    jsr bas_GIVAYF$ ; Converts YY into a Floating Point Value in FPA1
    lda $66
    eor $6E
    sta $6F
    lda $61
    jmp bas_FPDIV$  ; FPA1 = FPA2 / FPA1 ( XX / YY )

DRAW_SETFPA1_TO_ZERO
    lda #0
    tay
    jsr bas_GIVAYF$

DRAW_MOVE_FPA1_TO_MEMORY
    ldy #$02        ; Address Hi byte
    ldx #$F0        ; Address Lo byte
    jmp bas_MOVEFP1M$ ; Moves FPA1 to Memory

DRAW_XAXIS_START
    lda #$00
    sta COMM_XLLO   ; XLine Lo byte
    sta COMM_XLHI   ; XLine Hi Byte
    sta $65
    sta $64

DRAW_XAXIS_LOOP
    ldy COMM_XLLO
    ldx COMM_XLHI
    lda COMM_YD
    cmp #0
    beq DRAW_X_AS_YD_IS_ZERO
    jsr DRAW_WORKOUT_NEW_POINT

DRAW_X_AS_YD_IS_ZERO
    lda COMM_Y1

DRAW_WORKOUT_Y_FROM_AXISX
    clc
    adc $65
    sta COMM_Y
    lda COMM_X1LO

DRAW_WORKOUT_X_FROM_AXISX
    clc
    adc COMM_XLLO
    sta COMM_XLO
    lda COMM_X1HI
    adc COMM_XLHI
    sta COMM_XHI

    jsr Place
    jsr Dot

    inc COMM_XLLO
    bne @ByPassInc
    inc COMM_XLHI

@ByPassInc
    lda COMM_XLHI
    cmp COMM_XDHI
    bne DRAW_XAXIS_LOOP
    lda COMM_XLLO
    cmp COMM_XDLO
    bcc DRAW_XAXIS_LOOP
    rts

DRAW_WORKOUT_NEW_POINT
    txa
    jsr bas_GIVAYF$ ; Convert to Float in FPA1 (y = Lo, Acc = Hi)
    jsr bas_MOVEFP1FP2$ ; Move FPA1 -> FPA2
    
    ldy #$02
    lda #$F0            ; Getting the XX / YY Ratio From Memory
    jsr bas_MOVEMFP1$   ; Move Memory Float to FPA1

    lda $66
    eor $6e
    sta $6f
    lda $61
    jsr bas_FMULTT$     ; FPA1 = FPA1 * FPA2 = New Postion
    jmp bas_FACINX$     ; Converts FPA1 into Integer (Acc= Hi, Y= Lo [$64,$65])

PREPAREXCALC
    sta DRAW_WORKOUT_X_FROM_AXISY
    sta DRAW_WORKOUT_X_FROM_AXISX
    txa
    sta DRAW_WORKOUT_X_FROM_AXISY + 1
    sta DRAW_WORKOUT_X_FROM_AXISY + 9
    eor #8
    sta DRAW_WORKOUT_X_FROM_AXISX + 1
    sta DRAW_WORKOUT_X_FROM_AXISX + 10
    rts

PREPAREYCALC
    sta DRAW_WORKOUT_Y_FROM_AXISX
    sta DRAW_WORKOUT_Y_FROM_AXISY
    txa
    sta DRAW_WORKOUT_Y_FROM_AXISX + 1
    eor #8
    sta DRAW_WORKOUT_Y_FROM_AXISY + 1
    rts
   
DRAW_ALONG_YAXIS
    lda COMM_XDHI
    cmp #0
    bne DRAW_WORK_OUT_YRATIO
    lda COMM_XDLO
    cmp #0
    bne DRAW_WORK_OUT_YRATIO
    jsr DRAW_SETFPA1_TO_ZERO
    lda #255
    sta COMM_XDHI
    jmp DRAW_YAXIS_START

DRAW_WORK_OUT_YRATIO
    ldy COMM_YD
    ldx COMM_XDLO
    sty COMM_YY
    lda #0
    sta 246
    stx COMM_XXLO
    lda COMM_XDHI
    sta COMM_XXHI
    jsr DIVIDE_XX_BY_YY
    jsr DRAW_MOVE_FPA1_TO_MEMORY

DRAW_YAXIS_START
    lda #0
    sta COMM_YL
    sta $65
    sta $64

DRAW_YAXIS_LOOP
    ldy COMM_YL
    ldx #0
    lda COMM_XDHI
    cmp #255
    beq DRAW_Y_AS_XD_IS_ZERO
    jsr DRAW_WORKOUT_NEW_POINT

DRAW_Y_AS_XD_IS_ZERO
    lda COMM_X1LO

DRAW_WORKOUT_X_FROM_AXISY
    clc
    adc $65
    sta COMM_XLO
    lda COMM_X1HI
    adc $64
    sta COMM_XHI
    lda COMM_Y1

DRAW_WORKOUT_Y_FROM_AXISY
    clc
    adc COMM_YL
    sta COMM_Y
    jsr Place
    jsr Dot

    inc COMM_YL
    lda COMM_YL
    cmp COMM_YD
    bcc DRAW_YAXIS_LOOP
    rts
