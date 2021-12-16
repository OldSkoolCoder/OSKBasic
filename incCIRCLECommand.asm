;*******************************************************************************
;* CIRCLE Command                                                              *
;* This BASIC function to draw a circle on the screen                          *
;* *****************************************************************************
;* Syntax : CIRCLE or c Shifted I                                              *
;* Inputs : X (0->319) and Y (0 ->199)                                         *
;*        : XRad (0->310) and YRad (0->199)                                    *
;*        : Start Angle (In Degrees) and the Finish Angle (In Degrees)         *
;*******************************************************************************

; circle : circle x, y, xrad, yrad, start, finish
COM_CIRCLE
    jsr GetNo2      ; Get X
    sta COMM_RXLO
    sty COMM_RXHI

    jsr bas_CHKCOM$ ; Checks For a Comma
    jsr bas_GETBYTC$; Get Y
    stx COMM_RY

    jsr bas_CHKCOM$ ; Checks For a Comma
    jsr GetNo2      ; Get XRad
    sta COMM_XRLO
    sty COMM_XRHI

    jsr bas_CHKCOM$ ; Checks For a Comma
    jsr bas_GETBYTC$; Get YRad
    stx COMM_YR

    jsr bas_CHKCOM$ ; Checks For a Comma
    jsr GetNo2      ; Get Start Angle (In Degrees 0->360)
    jsr RadianConverter   ;(RADCON)

    jsr WORKOUT_X_COSINE
    sta COMM_AXLO
    stx COMM_AXHI

    jsr WORKOUT_Y_SINE
    sty COMM_AY

    jsr bas_CHKCOM$ ; Checks For a Comma
    jsr GetNo2      ; Get Start Angle (In Degrees 0->360)
    jsr RadianConverter
    ldx #<COMM_FINISH
    ldy #>COMM_FINISH
    jsr bas_MOVEFP1M$

    ldy #>INCREAMENT
    lda #<INCREAMENT
    jsr bas_MOVEMFP1$

    ldx #<COMM_INCR
    ldy #>COMM_INCR
    jsr bas_MOVEFP1M$
    
    jsr CIRCLE_CALC_NEXT_DEGREE_POINT    ;(Circle5)
    jmp CIRCLE_START_DRAWING             ; (Circle1)


INCREAMENT
    word $4c7d
    word $cccc
    byte $cd

RADIAN 
    word $6586
    word $e02e
    byte $d4

RadianConverter
    lda $15
    ldy $14
    jsr bas_GIVAYF$
    jsr bas_MOVEFP1FP2$
    ldy #>RADIAN
    lda #<RADIAN
    jsr bas_MOVEMFP1$
    lda $66
    eor $6E
    sta $6F
    lda $61
    jmp bas_FPDIV$          ; FP1 = FP2 (Angle in Degrees) / RADIAN Conversion


CIRCLE_START_DRAWING
    jsr WORKOUT_X_COSINE
    sta COMM_XLO
    stx COMM_XHI

    jsr WORKOUT_Y_SINE
    sty COMM_Y

    lda COMM_XHI
    cmp #1
    bcc CheckYAxis
    beq @CheckingXLo
    bcs CIRCLE_OUT_OF_BOUNDS

@CheckingXLo
    lda COMM_XLO
    cmp #64
    bcs CIRCLE_OUT_OF_BOUNDS

CheckYAxis
    lda COMM_Y
    cmp #201
    bcs CIRCLE_OUT_OF_BOUNDS
    bcc CIRCLE_DRAW_LINE

CIRCLE_OUT_OF_BOUNDS
    jmp CIRCLE_SWAP_NEWPOINT_TO_OLD

CIRCLE_DRAW_LINE
    lda COMM_XHI
    sta COMM_X2HI
    sta COMM_CXHI
    lda COMM_XLO
    sta COMM_X2LO
    sta COMM_CXLO
    lda COMM_Y
    sta COMM_Y2
    sta COMM_CY

    ;jsr PLACE       ; Works out the memory location to change
    ;jsr DOT         ; Sets the bit location odf the memory location
    lda COMM_AXLO
    sta COMM_X1LO
    lda COMM_AXHI
    sta COMM_X1HI
    lda COMM_AY
    sta COMM_Y1
    jsr DRAW_LINE_START

CIRCLE_SWAP_NEWPOINT_TO_OLD
    lda COMM_CXLO
    sta COMM_AXLO
    lda COMM_CXHI
    sta COMM_AXHI
    lda COMM_CY
    sta COMM_AY
    jsr CIRCLE_CALC_NEXT_DEGREE_POINT       ; Circle5
    lda #<COMM_FINISH
    ldy #>COMM_FINISH
    jsr bas_FCOMP$              ; Compare FP1 to Memory
    cmp #1
    beq CIRCLE_FINISH_DRAWING
    jmp CIRCLE_START_DRAWING

CIRCLE_FINISH_DRAWING
    rts

CIRCLE_MULTIPLY_FP1_BY_INTEGER
    sty COMM_XXLO
    sta COMM_XXHI
    jsr bas_MOVEFP1FP2$         ; Move FP1 -> FP2
    lda COMM_XXHI
    ldy COMM_XXLO
    jsr bas_GIVAYF$             ; Convert Int (A+Y) to FP1
    lda $66
    eor $6E
    sta $6f
    lda $61
    jsr bas_FMULTT$             ; FP1 = FP1 * FP2
    jmp bas_FACINX$             ; Converts FP1 -> Integer $14 $15

CIRCLE_CALC_NEXT_DEGREE_POINT
    lda #<COMM_START
    ldy #>COMM_START
    jsr bas_CONUPK$             ; Move Memory -> FP2
    lda #<COMM_INCR
    ldy #>COMM_INCR
    jsr bas_MOVEMFP1$           ; Move Memory to FP1
    lda $66
    eor $6E
    sta $6f
    lda $61
    jsr bas_FADDT$              ; FP1 = FP1 + FP2
    ldx #<COMM_START
    ldy #>COMM_START
    jmp bas_MOVEFP1M$           ; move FP1 -> Memory

WORKOUT_X_COSINE
    ; Return : Acc = Lo Byte X Coord
    ;        : X = Hi Byte X Coord
    ldx #<COMM_START
    ldy #>COMM_START
    jsr bas_MOVEFP1M$

    jsr os_COS$

    ldy COMM_XRLO
    lda COMM_XRHI
    jsr CIRCLE_MULTIPLY_FP1_BY_INTEGER ; Calculate the X Value for Plotting

    clc
    lda $65
    adc COMM_RXLO
    ;sta COMM_AXLO
    pha
    lda $64
    adc COMM_RXHI
    ;sta COMM_AXHI
    tax
    pla
    rts
    
WORKOUT_Y_SINE
    ; Return : Y = Y Coord
    lda #<COMM_START
    ldy #>COMM_START
    jsr bas_MOVEMFP1$

    jsr os_SIN$
    lda #0
    ldy COMM_YR
    jsr CIRCLE_MULTIPLY_FP1_BY_INTEGER

    lda $65
    clc
    adc COMM_RY
    tay
    rts

