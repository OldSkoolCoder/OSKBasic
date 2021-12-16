;*******************************************************************************
;* RPOINT Command                                                              *
;* This BASIC function that reads a dot in the Hi-Res Screen                   *
;* *****************************************************************************
;* Syntax : RPOINT or r Shifted P                                              *
;* Inputs : X (0->319) and Y (0 ->199)                                         *
;* *****************************************************************************
;* Output : either a 1 = pixel set or 0 = pixel clear                          *
;*******************************************************************************

; rpoint syntax : var=rpoint(x,y)
COM_RPOINT
    jsr bas_CHKCLOSE$ + 3

    jsr GETNo2      ; Get X Coords = 2 bytes
    sta COMM_XLo
    sty COMM_XHi

    jsr bas_CHKCOM$
    jsr bas_GETBYTC$
    stx COMM_Y

    jsr bas_CHKCLOSE$

    jsr PLACE           ; identify byte location of bit to be read

    lda 1
    and #%11111110          ; Paging out BASIC ROM
    sta 1

    ldx COMM_C
    ldy #0
    lda BYTEMASK,x
    and (STAL),y
    pha
    
    lda 1
    ora #%00000001          ; Paging in BASIC ROM
    sta 1

    pla
    cmp BYTEMASK,x
    bne RPOINT_RETURN1
    lda #0
    tay
    jmp bas_GIVAYF$         ; Return 0 in the Floating Point Accumulator

RPOINT_RETURN1
    lda #0
    ldy #1
    jmp bas_GIVAYF$         ; Return 1 in the Floating Point Accumulator
    
    
