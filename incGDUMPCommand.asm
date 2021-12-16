;*******************************************************************************
;* GDUMP Command                                                               *
;* This BASIC function to print the Graphics Screen to a printer               *
;* *****************************************************************************
;* Syntax : GDUMP or G Shifted U                                               *
;*******************************************************************************

; gdump :
COM_GDUMP
DUMP
    lda #4          ; Logical File Number
    tax             ; Device Number
    ldy #255        ; Secondary Address
    jsr krljmp_SETLFS$
    tya             ; Filename Location
    tax             ; "    "
    lda #0          ; Filename Length
    jsr krljmp_SETNAM$
    jsr krljmp_OPEN$

    ldx #4          ; Logical File Number
    jsr krljmp_CHKOUT$  ; Set Output to the above logical file#

    ;lda #200
    ;sta COMM_Y1
    ;lda #0
    ;sta COMM_Y2
    lda #1
    sta COMM_Yl

Dump_ColumnLooper
DUMP9
    lda #0
    sta COMM_XLLO
    sta COMM_XLHI
    sta COMM_Y2
    sta COMM_AXLO        ; Byte to be Printed
    lda #8              ; Setting Printer into GRAPHICS MODE
    jsr krljmp_CHROUT$

DUMP_VerticalByteLooper
DUMP4
    lda COMM_XLLO
    sta COMM_XLO
    lda COMM_XLHI
    sta COMM_XHI
    lda COMM_Y1
    sec 
    sbc COMM_Y2
    sta COMM_Y
    jsr PLACE
    lda $01
    and #$fe            ; Remove BASIC
    sta $01
    ldx COMM_C
    lda BYTEMASK,x
    ldy #0
    and (RIBUF),y
    cmp BYTEMASK,x
    beq dump3

DUMP6
    lda $01
    ora #1              ; ReInstate BASIC
    sta $01
    ldx COMM_Y2
    inx 
    stx COMM_Y2
    cpx #7
    bne dump4
    jmp dump5

DUMP_UpdatePrintByte
DUMP3
    lda #7
    sec 
    sbc COMM_Y2
    tax 
    lda BYTEMASK,x
    clc 
    adc COMM_AXLO
    sta COMM_AXLO
    jmp dump6

DUMP_PrintByte
DUMP5
    lda COMM_AXLO
    clc 
    adc #128
    sta COMM_AXLO
    jsr krljmp_CHROUT$
    inc COMM_XLLO
    bne @ByPassInc
    inc COMM_XLHI

@ByPassInc
    lda COMM_XLHI
    cmp #1
    beq @TestLoByteForHiByte1
    jmp dump11

@TestLoByteForHiByte1
    lda COMM_XLLO
    cmp #64
    beq @PrintLineComplete
    jmp dump11

@PrintLineComplete
    lda COMM_Y1
    sec 
    sbc #7
    sta COMM_Y1
    cmp #5
    bcc DUMP_EndPrinting

    lda #13             ; Print Enter
    jsr krljmp_CHROUT$
    jmp dump9

DUMP_EndPrinting
    jsr dump12
    lda #15             ; Set Printer ot Standard Mode
    jsr krljmp_CHROUT$
    lda #15
    jsr krljmp_CHROUT$
    lda #13             ; Print Enter
    jsr krljmp_CHROUT$
    jsr krljmp_CLRCHN$
    lda #4
    jmp krljmp_CLOSE$

DUMP_RESETForNextColumn
DUMP11
    lda #0
    sta COMM_AXLO
    sta COMM_Y2
    jmp dump4

DUMP_PrepareNextLine
DUMP12
    lda #0
    sta COMM_XLLO
    sta COMM_XLHI
    sta COMM_Y2
    sta COMM_AXLO
    lda #13             ; Print Enter
    jsr krljmp_CHROUT$
    lda #8              ; Set Printer into Graphics Mode
    jsr krljmp_CHROUT$

DUMP13
    lda COMM_XLLO
    sta COMM_XLO
    lda COMM_XLHI
    sta COMM_XHI
    lda COMM_Y1
    sec 
    sbc COMM_Y2
    sta COMM_Y
    jsr PLACE
    lda $01
    and #$fe            ; Remove BASIC
    sta $01
    ldx COMM_C
    lda BYTEMASK,x
    ldy #0
    and (RIBUF),y
    cmp BYTEMASK,x
    beq dump14

DUMP15
    lda $01
    ora #1              ; ReInstate BASIC
    sta $01
    ldx COMM_Y2
    inx 
    stx COMM_Y2
    cpx #5
    bne dump13
    jmp dump16

DUMP14
    lda #7
    sec 
    sbc COMM_Y2
    tax 
    lda BYTEMASK,x
    clc 
    adc COMM_AXLO
    sta COMM_AXLO
    jmp DUMP15

DUMP16
    lda COMM_AXLO
    clc 
    adc #128
    sta COMM_AXLO
    jsr krljmp_CHROUT$
    inc COMM_XLLO
    bne @ByPassInc
    inc COMM_XLHI

@ByPassInc
    lda COMM_XLHI
    cmp #1
    beq @TestLo
    jmp dump18

@TestLo
    lda COMM_XLLO
    cmp #64
    beq @GoEnd
    jmp dump18

@GoEnd
    rts 

DUMP18
    lda #0
    sta COMM_AXLO
    sta COMM_Y2
    jmp dump13


