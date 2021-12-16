;*******************************************************************************
;* BOX Command                                                                 *
;* This BASIC function put a box on a Hi-Res Screen                            *
;* *****************************************************************************
;* Syntax : BOX or b Shifted O                                                 *
;* Inputs : X1 (0->319) and Y1 (0 ->199)                                       *
;*        : X2 (0->319) and Y2 (0 ->199)                                       *
;*******************************************************************************

; box : box x1,y1 to x2,y2

COM_BOX
    jsr GetNo2      ; Get X1
    sta COMM_AXLO
    sty COMM_AXHI

    jsr bas_CHKCOM$ ; Checks For a Comma
    jsr bas_GETBYTC$; Get Y1
    stx COMM_AY

    lda #164
    jsr bas_SYNCHR$ ; Check For the BASIC Command 'TO'

    jsr GetNo2      ; Get X2
    sta COMM_RXLO
    sty COMM_RXHI

    jsr bas_CHKCOM$ ; Checks For a Comma
    jsr bas_GETBYTC$; Get Y2
    stx COMM_RY

    ; X1 = AX, Y1 = AY
    ; X2 = RX, Y2 = RY
    ; Bottom Line of Box
    ; X1,Y1 -> X2,Y1
    lda COMM_AXLO
    sta COMM_X1LO
    lda COMM_AXHI
    sta COMM_X1HI
    lda COMM_AY
    sta COMM_Y1

    lda COMM_RXLO
    sta COMM_X2LO
    lda COMM_RXHI
    sta COMM_X2HI
    lda COMM_AY
    sta COMM_Y2
    
    jsr DRAW_LINE_START

    ; Right Side Line of Box
    ; X2,Y1 -> X2,Y2
    lda COMM_RXLO
    sta COMM_X1LO
    lda COMM_RXHI
    sta COMM_X1HI
    lda COMM_AY
    sta COMM_Y1

    lda COMM_RXLO
    sta COMM_X2LO
    lda COMM_RXHI
    sta COMM_X2HI
    lda COMM_RY
    sta COMM_Y2
    
    jsr DRAW_LINE_START

    ; Top Line of Box
    ; X2,Y2 -> X1,Y2
    lda COMM_RXLO
    sta COMM_X1LO
    lda COMM_RXHI
    sta COMM_X1HI
    lda COMM_RY
    sta COMM_Y1

    lda COMM_AXLO
    sta COMM_X2LO
    lda COMM_AXHI
    sta COMM_X2HI
    lda COMM_RY
    sta COMM_Y2
    
    jsr DRAW_LINE_START

    ; Left Side Line of Box
    ; X1,Y2 -> X1,Y1
    lda COMM_AXLO
    sta COMM_X1LO
    lda COMM_AXHI
    sta COMM_X1HI
    lda COMM_RY
    sta COMM_Y1

    lda COMM_AXLO
    sta COMM_X2LO
    lda COMM_AXHI
    sta COMM_X2HI
    lda COMM_AY
    sta COMM_Y2
    
    jsr DRAW_LINE_START

    rts

    