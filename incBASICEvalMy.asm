;*******************************************************************************
;* EvalMy Routine                                                              *
;*******************************************************************************

VEC_EVALMY
    lda #0
    sta $0D             ; reset variable type data
    jsr bas_CHRGET$     ; get next character
    cmp #$CC            ; lower than our "Direct" command range
    bcc EVALLV
    cmp #$CE            ; above our command "Direct" range
    bcs EVALLV
    jmp BYEGO           ; Execute our Command

EVALLV
    lda $7A             ; reset ChrGet Pointer
    bne EVALRT
    dec $7B

EVALRT
    dec $7A
    jmp bas_EVAL$ + 3   ; Jump to BASIC Rom Eval Routine
