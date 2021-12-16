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

;    lda #$38        ; SEC Instruction
;    ldx #$e5        ; SBC ZeroPage Instruction
;    jsr PREPAREXCALC; Alters X Draw Routine to "SUBTRACT"

    lda DrawingExecutionDriver
    and #%00000101
    ora #%00001010
    sta DrawingExecutionDriver

    jmp DRAW_EVAL_Y

@X1LTX2             ; X1 < X2
    sec
    lda COMM_X2LO
    sbc COMM_X1LO
    sta COMM_XDLO   ; Difference of X Lo byte

    lda COMM_X2HI
    sbc COMM_X1HI
    sta COMM_XDHI   ; Difference of X Hi byte

;    lda #$18        ; CLC Instruction
;    ldx #$65        ; ADC ZeroPage Instruction
;    jsr PREPAREXCALC; Alters X Draw Routine to "ADD"

    lda DrawingExecutionDriver
    and #%00000101
    sta DrawingExecutionDriver

DRAW_EVAL_Y
    lda COMM_Y1
    cmp COMM_Y2     ; Compare Y1 and Y2
    bcc @Y1LTY2     ; Y1 < Y2

    sec             ; Y1 >= Y2
    lda COMM_Y1
    sbc COMM_Y2
    sta COMM_YD     ; Difference of Y
    
;    lda #$38        ; SEC Instruction
;    ldx #$e5        ; SBC ZeroPage Instruction
;    jsr PREPAREYCALC; Alters Y Draw Routine to "SUBTRACT"

    lda DrawingExecutionDriver
    and #%00001010
    ora #%00000101
    sta DrawingExecutionDriver

    jmp DRAW_DeltaCalc

@Y1LTY2             ; Y1 < Y2
    sec
    lda COMM_Y2
    sbc COMM_Y1
    sta COMM_YD     ; Difference of Y
    
;    lda #$18        ; CLC Instruction
;    ldx #$65        ; ADC ZeroPage Instruction
;    jsr PREPAREYCALC; Alters Y Draw Routine to "ADD"

    lda DrawingExecutionDriver
    and #%00001010
    sta DrawingExecutionDriver

DRAW_DeltaCalc
    lda COMM_XDHI
    cmp #1
    beq DRAW_ALONG_XAXIS; Is XDelta = 1 as Y will never be :(
    lda COMM_XDLO   ; XDelta <> 1
    cmp COMM_YD
    bcs DRAW_ALONG_XAXIS; X Delta >= Y Delta
    jmp DRAW_ALONG_YAXIS; X Delta < Y Delta

DRAW_ALONG_XAXIS
    lda COMM_XDLo
    sta Divisor
    lda COMM_XDHI
    sta Divisor + 1

    lda COMM_YD
    sta Number
    lda #0
    sta Number + 1

    jsr Divide16Bit

    lda #$00
    sta COMM_XXLO   ; XLine Lo byte
    sta COMM_XXHI   ; XLine Hi Byte
    sta COMM_YLFRAC
    sta COMM_XLFRAC
    
    lda COMM_Y1
    sta COMM_YL

    lda COMM_X1LO
    sta COMM_XLLO
    lda COMM_X1HI
    sta COMM_XLHI

DRAW_XAXIS_LOOP
    lda DrawingExecutionDriver
    and #%00000001
    bne WORKOUT_YONX_SUB
; WORKOUT_YONX_ADD
    clc
    lda COMM_YLFRAC
    adc ResultFrac 
    sta COMM_YLFRAC
    lda COMM_YL
    adc Result
    sta COMM_YL
    jmp WORKOUT_XONX

WORKOUT_YONX_SUB
    sec
    lda COMM_YLFRAC
    sbc ResultFrac 
    sta COMM_YLFRAC
    lda COMM_YL
    sbc Result
    sta COMM_YL

WORKOUT_XONX
    lda DrawingExecutionDriver
    and #%00000010
    bne WORKOUT_XONX_SUB
;WORKOUT_XONX_ADD
    lda COMM_XLLO
    clc
    adc #1
    sta COMM_XLLO
    bcc @SkipIncAdd
    inc COMM_XLHI
@SkipIncAdd
    jmp DRAW_WORKOUT_Y_FROM_AXISX

WORKOUT_XONX_SUB
    lda COMM_XLLO
    sec
    sbc #1
    sta COMM_XLLO
    bcs @SkipIncAdd
    dec COMM_XLHI
@SkipIncAdd

DRAW_WORKOUT_Y_FROM_AXISX
    lda COMM_YL
    sta COMM_Y

    lda COMM_XLLO
    sta COMM_XLO
    lda COMM_XLHI
    sta COMM_XHI

    jsr Place
    jsr Dot

    inc COMM_XXLO
    bne @ByPassInc
    inc COMM_XXHI

@ByPassInc
    lda COMM_XXHI
    cmp COMM_XDHI
    bne DRAW_XAXIS_LOOP
    lda COMM_XXLO
    cmp COMM_XDLO
    bcs @Exit
    jmp DRAW_XAXIS_LOOP
@Exit
    rts

DRAW_ALONG_YAXIS
    lda COMM_YD
    sta Divisor
    lda #0
    sta Divisor + 1
    sta COMM_YLFRAC
    sta COMM_XLFRAC


    lda COMM_XDLo
    sta Number
    lda COMM_XDHI
    sta Number + 1

    jsr Divide16Bit

    lda #$00
    sta COMM_YY
    
    lda COMM_Y1
    sta COMM_YL

    lda COMM_X1LO
    sta COMM_XLLO
    lda COMM_X1HI
    sta COMM_XLHI

DRAW_YAXIS_LOOP
    lda DrawingExecutionDriver
    and #%00000100
    bne WORKOUT_YONY_SUB
; WORKOUT_YONY_ADD
    clc
    lda COMM_YL
    adc #1
    sta COMM_YL
    jmp WORKOUT_XONY

WORKOUT_YONY_SUB
    sec
    lda COMM_YL
    sbc #1
    sta COMM_YL

WORKOUT_XONY
    lda DrawingExecutionDriver
    and #%00001000
    bne WORKOUT_XONY_SUB
;WORKOUT_XONY_ADD
    clc
    lda COMM_XLFRAC
    adc ResultFrac
    sta COMM_XLFRAC
    lda COMM_XLLO
    adc Result
    sta COMM_XLLO
    lda COMM_XLHI
    adc ResultHi
    sta COMM_XLHI
    jmp DRAW_WORKOUT_X_FROM_AXISY

WORKOUT_XONY_SUB
    sec
    lda COMM_XLFRAC
    sbc ResultFrac
    sta COMM_XLFRAC
    lda COMM_XLLO
    sbc Result
    sta COMM_XLLO
    lda COMM_XLHI
    sbc ResultHi
    sta COMM_XLHI

DRAW_WORKOUT_X_FROM_AXISY
    lda COMM_YL
    sta COMM_Y

    lda COMM_XLLO
    sta COMM_XLO
    lda COMM_XLHI
    sta COMM_XHI

    jsr Place
    jsr Dot

    inc COMM_YY

@ByPassInc
    lda COMM_YY
    cmp COMM_YD
    beq @Exit
    jmp DRAW_YAXIS_LOOP
@Exit
    rts
