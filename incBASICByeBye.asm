;*******************************************************************************
;* ByeBye Routine                                                              *
;*******************************************************************************

VEC_BYEBYE
    jsr bas_CHRGET$             ; Get next character
    cmp #$CC                    ; lower that our "Program" command range
    bcc BYERTS
    cmp #$FE                    ; Above our "Program" command range
    bcs BYERTS
    jsr BYEGO                   ; Execute our Command
    jmp bas_NewStatement$       ; Got to gext BASIC Statement

BYEGO
    sbc #$CB                    ; subtract out Tokan Base Value
    asl                         ; x 2
    tay                         ; transfer to index
    lda Command_ADDR + 1,y      ; Command Hi Location
    pha
    lda Command_ADDR,y          ; Command Lo Location
    pha
    jmp bas_CHRGET$             ; Get Next Character

BYERTS
    jsr bas_CHRGOT$             ; Get Current Character
    jmp bas_GONE$ + 3           ; BASIC Execution system
