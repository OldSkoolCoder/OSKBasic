;*******************************************************************************
;* Lister Routine                                                              *
;*******************************************************************************

VEC_LISTER
    php             ; Push Status To Stack
    cmp #255        ; Compare with 255
    beq LEXIT       ; Is 255 then Exit
    bit $0F         ; Test against $0f
    bmi LEXIT       ; if negative then Exit
    cmp #$CC        ; 
    bcc LEXIT       ; <$CC (start of our BASIC Commands) then EXIT
    plp             ; restore status
    sec
    sbc #$CB        ; subtract $CB to find our command index number
    tax
    sty $49         ; store away Y for now
    ldy #$FF        ; Start Y

RESLP1
    dex             ; Decrement Command Number by 1
    beq RESPRT      ; Found it ;)

RESLP2
    iny             ; increase command character counter
    lda Command_LIST,y  ; 
    bpl RESLP2      ; command char
    bmi RESLP1      ; end of command char

RESPRT
    iny             ; move chart index
    lda Command_LIST,y  ; get command char
    bmi RESEXT      ; exit if SHIFTED
    jsr krljmp_CHROUT$  ; print
    bne RESPRT      ; go round for next char

RESEXT
    jmp $A6EF       ; jump to BASIC Lister 

LEXIT
    plp
    jmp bas_UNCRUNCH$ + 3   ; Jump to Normal Basic Lister