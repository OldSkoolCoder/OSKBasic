;*******************************************************************************
;* SHAPE Command                                                               *
;* This BASIC function to draw a polygon on the screen                         *
;* *****************************************************************************
;* Syntax : SHAPE or s Shifted H                                               *
;* Inputs : X (0->319) and Y (0 ->199)                                         *
;*        : XRad (0->310) and YRad (0->199)                                    *
;*        : Start Angle (In Degrees) and the Finish Angle (In Degrees)         *
;*        : Increment Angle                                                    *
;*******************************************************************************

; shape : circle x, y, xrad, yrad, start, finish, inc
COM_SHAPE
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

    jsr bas_CHKCOM$ ; Checks For a Comma
    jsr GetNo2      ; Get Increment Angle (In Degrees 0->360)
    jsr RadianConverter
    ldx #<COMM_INCR
    ldy #>COMM_INCR
    jsr bas_MOVEFP1M$

    jsr CIRCLE_CALC_NEXT_DEGREE_POINT    ;(Circle5)
    jmp CIRCLE_START_DRAWING             ; (Circle1)
