;*******************************************************************************
;* GSAVE Command                                                               *
;* This BASIC function to save the Graphics Screen (BitMap) to a device        *
;* *****************************************************************************
;* Syntax : GSAVE or s Shifted A                                               *
;* Inputs : FileName                                                           *
;*        : Device                                                             *
;*******************************************************************************

; gsave : "filename", device#
COM_GSAVE
    jsr bas_FRMEVL$
    jsr bas_FRESTR$
    tay 
    sty COMM_RXLO
    lda INDEX
    sta RIBUF
    lda INDEX + 1
    sta RIBUF + 1
    jsr bas_CHRGOT$
    jsr bas_CHKCOM$
    jsr bas_GETBYTC$
    lda #1              ; Logical FileNumber
    ldy #1              ; Logical Secondary Address
    jsr krljmp_SETLFS$
    lda COMM_RXLO       ; Length Of Filename
    ldx RIBUF           ; Pointer to File Name Text
    ldy RIBUF + 1
    jsr krljmp_SETNAM$
    lda $01
    and #$fe            ; Turn Off BASIC
    sta $01
    lda #$a0            ; Set Start Address of Memory Save
    sta ROBUF + 1
    lda #$00
    sta ROBUF
    lda #ROBUF          ; Start Address ZP Index
    ldx #$00            ; End Address Of Memory Save
    ldy #$c0            ; "                   "
    jsr krljmp_SAVE$
    lda $01
    ora #1              ; restore BASIC ROM
    sta $01
    rts 
    