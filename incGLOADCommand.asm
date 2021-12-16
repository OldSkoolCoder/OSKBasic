;*******************************************************************************
;* GSAVE Command                                                               *
;* This BASIC function to save the Graphics Screen (BitMap) to a device        *
;* *****************************************************************************
;* Syntax : GSAVE or s Shifted A                                               *
;* Inputs : FileName                                                           *
;*        : Device                                                             *
;*******************************************************************************

; gsave : "filename", device#
COM_GLOAD
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

    lda #0
    jmp krljmp_LOAD$
