;*******************************************************************************
;* JOY Command                                                                 *
;* This BASIC function reads the Joystick Port                                 *
;* *****************************************************************************
;* Syntax : JOY or j Shifted O                                                 *
;* Inputs : Joystick 0 = Joy Port 2, 1 = Joy Port 1                            *
;*******************************************************************************

; joy : joy(#)
COM_JOY
    jsr bas_GETBYTC$; Get Joystick Port
    cpx #2
    bcc @ReadJoyPort
    jmp bas_IQERR$

@ReadJoyPort
    jsr bas_CHKCLOSE$

    lda CIA1_PRA,x
    and #%00011111
    ;pha
    ;lda #0
    sta COMM_Y
;    ldx #$07

;@JOY1
;    pla
;    pha
;    and BYTEMASK,x
;    cmp BYTEMASK,x
;    bne @JOY2

;@JOY3
;    dex
;    cpx #3
;    bne @JOY1
;    pla
    ldy COMM_Y
    lda #0
    jmp bas_GIVAYF$

;@JOY2
;    lda COMM_Y
;    clc
;    adc BYTEMASK,x  ; <------ Y John Jnr ??
;    sta COMM_Y
;    jmp @JOY3

    