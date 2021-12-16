;*******************************************************************************
;* Error Handler Routine                                                       *
;*******************************************************************************

ErrorHandlerLo = $22
ErrorHandlerHi = $23

VEC_ErrorHandler
    txa
    pha
    bpl @DisplayError
    pla
    jmp bas_ReadyPrompt$

@DisplayError
    cmp #31
    bcc @ROMError
    sec
    sbc #31
    asl
    tax
    lda ErrorCodeAddr,x
    sta ErrorHandlerLo
    lda ErrorCodeAddr + 1,x
    sta ErrorHandlerHi
    pla
    jmp bas_CustomError$

@ROMError
    jsr COM_SCREEN
    pla
    tax
    jmp bas_ROMError$ + 3

ErrorCodeADDR
    ; ToDo Add Error Codes
    WORD ERRORCODE_31
    WORD ERRORCODE_32
    WORD ERRORCODE_33

ERRORCODE_31
    TEXT "operationaL"

ERRORCODE_32
    TEXT "this is error thirty twO"

ERRORCODE_33
    TEXT "this is error thirty threE"
;******************************************************************************
;* Show Syntax Error                                                          *
;******************************************************************************

SYNTAX_ERROR
    lda #32
    sta 129
    ldx #11
    jmp (jmpvec_Error)