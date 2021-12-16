;*******************************************************************************
;* Cartridge Initialisation Routine                                            *
;*                                                                             *
;* Written By John C. Dale                                                     *
;*                                                                             *
;* Date 26th October 2020                                                      *
;*******************************************************************************

    word CART_RESET
    word CART_NMI

    TEXT "CBM80"

CART_RESET
    stx SCROLX
    jsr krljmp_IOINIT$      ; CIA IO Initialisation
    jsr krljmp_RAMTAS$      ; Perform RAM Test
    jsr krljmp_RESTOR$      ; Restore RAM Vectors
    jsr krljmp_PCINT$       ; Initialise Screen Editor and VIC Chip
    cli
    
    jsr $E453               ; Copy BASIC Vectors To RAM.
    jsr $E3BF               ; Initialise BASIC
    jsr $E422               ; Print BASIC StartUp Screen

    ldx #$FB                ; Load Stack Pointer Start Value
    txs                     ; Transfer To Stack Pointer
    jsr COPY_CART
    lda #<NMI_TEXT+1        ; Load Lo Byte of My Banner
    ldy #>NMI_TEXT          ; Load Hi Byte of My Banner
    jsr bas_PrintString$    ; Prints out My Banner
    jsr START               ; GoSub my Start Routine
    jmp NMI_EXIT            ; NMI Exit Point

NMI_TEXT
    BYTE CHR_ClearScreen
    BYTE CHR_CursorDown
    ;COLS"1234567890123456789012345678901234567890"
    TEXT "oldskoolcoder basic for the commodore 64"
    BYTE CHR_CursorDown
    TEXT "oskbasic v2.020a  (c) 2020 oldskoolcoder"
    brk 

CART_NMI
    jsr $F6BC               ; 
    jsr krljmp_STOP$        ; Check Stop Key
    beq @NMI
    jmp $FE72               ; NMI RS232 Handler

@NMI
    jsr krljmp_RESTOR$      ; Restore RAM Vectors
    jsr krljmp_IOINIT$      ; CIA IO Initialisation
    jsr krljmp_PCINT$       ; Initialise Screen Editor and VIC Chip
    jsr krljmp_CLRCHN$      ; Restore Input and Output Channels

    lda #$00
    sta $13
    jsr bas_CLRCommand$     ; Performing a BASIC CLR
    cli

    lda #<NMI_TEXT          ; Load Lo Byte of My Banner
    ldy #>NMI_TEXT          ; Load Hi Byte of My Banner
    jsr bas_PrintString$    ; Prints out My Banner
    jsr START               ; GoSub my Start Routine

NMI_EXIT
    ldx #128
    jmp (jmpvec_Error)

;*******************************************************************************
;* Start Routine                                                               *
;*******************************************************************************

START
    ldy #0
VEC
    lda MAP_VECTOR,y
    sta jmpvec_Error,y
    iny
    cpy #12
    bne VEC

    lda #>CARTSTART-1       ; Protects Graphics BASIC From BASIC Corruption
    sta 56
    sta 54
    sta 52

    lda #<CARTSTART
    sta 55
    sta 53
    sta 51

    lda #1
    sta COMM_GRAPHIC_COLOUR
    lda #0
    sta COMM_ERASE_ENABLED
    jmp $A663               ; Perform NEW Command

MAP_VECTOR
    ;word $e38B
    word VEC_ErrorHandler
    word $A483
    word VEC_TOKAN  ; Tokan Jump
    word VEC_LISTER
    word VEC_BYEBYE
    ;word $A7E4
    word VEC_EVALMY
    ;word $AE86

COPY_CART
    lda #0
    sta RIBUF
    lda #$80
    sta RIBUF + 1

GRAP
    ldy #0
GRAP_Loop
    lda (RIBUF),y
    sta (RIBUF),y
    iny
    bne GRAP_Loop
    inc RIBUF + 1

    lda RIBUF + 1
    cmp #$A0
    bne GRAP
    rts


