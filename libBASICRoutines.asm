;*******************************************************************************
;* Get Number From Command Line Routine                                        *
;* Output Variables :                                                          *
;*                    Accumulator has HiByte Value                             *
;*                    X Register has LoByte Value                              *
;*******************************************************************************

LineNumberLo    = $14
LineNumberHi    = $15

GetNumberFromCommandLine
    jsr bas_CHRGOT$
    bcs GNFCL_Return        ; No number on command line
    jsr bas_LineGet$        ; Get Integer Value From Command Line
    lda LineNumberHi        ; Stores Hi Integer Value
    ldx LineNumberLo        ; Stores Lo Integer Value
    clc

GNFCL_Return 
    rts

;*******************************************************************************
;* Print out a String                                                          *
;* Input Variables :                                                           *
;*                    Accumulator has LoByte Value                             *
;*                    y Register has HiByte Value                              *
;*******************************************************************************
ABIE
    sty 248
    sta 247

@ABIELooper
    ldy #0
    lda (247),y
    cmp #0
    beq @ABIE_EXIT
    jsr krljmp_CHROUT$
    inc 247
    bne @ABIE
    inc 248

@ABIE
    jmp @ABIELooper

@ABIE_EXIT
    jmp bas_ReadyPrompt$

;*******************************************************************************
;* GETNo2 Function                                                             *
;* This function gets a number from BASIC and returns the value in 2 bytes     *
;* *****************************************************************************
;* Inputs :                                                                    *
;*******************************************************************************
;* Outputs : LineNumberLo = Acc, LineNumberHi = Yreg                           *
;*******************************************************************************

GETNo2
    jsr bas_FRMNUM$
    jsr bas_GETADR$
    lda LineNumberLo
    ldy LineNumberHi
    rts

