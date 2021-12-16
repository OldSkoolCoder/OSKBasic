;*******************************************************************************
;* Library of Graphic Functions that will be used throughout the code.         *
;*******************************************************************************

;*******************************************************************************
;* PLACE Function                                                              *
;* This function works out the byte location of the memory address to modify   *
;* *****************************************************************************
;* Inputs : X = Pixel Column location, Y = Pixel Row Location                  *
;*******************************************************************************

PLACE
    clc
    lda COMM_Y          ; Get Y Pixel Row location
    cmp #200            ; Maximum number of rows + 1
    bcs @PLACE_ERROR
    lda COMM_XHI        ; Get X Pixel Column Location (HiByte)
    cmp #2
    bcs @PLACE_ERROR    ; 2 or Above = ERROR
    cmp #1
    bne WORK_PLACEOUT   ; this is Zero.... so it is legal
    lda COMM_XLo
    cmp #64
    bcc WORK_PLACEOUT

@PLACE_ERROR
    jmp bas_IQERR$

WORK_PLACEOUT
    ; Rw = (200 - Y) / 8
    lda #199
    sec
    sbc COMM_Y
    clc
    lsr             ; Div 2
    lsr             ; Div 2 = 4
    lsr             ; Div 2 = 8
    sta COMM_U      ; Row Number

    ; Cl = X / 8
    lda COMM_XHi    ; this is either 1 or 0
    lsr             ; populate the carry flag
    lda COMM_XLo    ; 0-255

    ; C BBBBBBBB
    ; 1 10101011
    ; > 11010101 > 1
    ror             ; Div 2
    lsr             ; Div 2 = 4
    lsr             ; Div 2 = 8
    sta COMM_V      ; Column Number

    ; pRw = Rw * 320   (S = U * 320)
    ldy COMM_U
    lda #0
    sta COMM_SLO
    sta COMM_SHI
    cpy #0
    beq WORK_OUT_COL

@RowMultiplier
    lda COMM_SLO
    clc
    adc #64
    sta COMM_SLO
    lda COMM_SHI
    adc #1
    sta COMM_SHI
    dey
    bne @RowMultiplier

WORK_OUT_COL
    ; pRw = 7 - (Y - (Rw*8))
    ; pRw = 7 - (Y and 7)          (R = 7- (Y and 7))
    lda COMM_Y
    and #7
    sta COMM_R
    sec
    lda #7
    sbc COMM_R
    sta COMM_R

    ; pixel = X And 7                 (C = X and 7)
    lda COMM_XLO
    and #7
    sta COMM_C

    ; Memory Location 
    ; BASE + pRw + (cl * 8) + pRw     ($A000 + S + (V*8) + R)
    lda #0
    sta STAL
    lda #>BITMAP_START
    sta STAL + 1
    clc
    lda STAL
    adc COMM_SLO
    sta STAL
    lda STAL + 1
    adc COMM_SHI
    sta STAL + 1

    lda #0
    asl COMM_V      ; Mult 2
    asl COMM_V      ; Mult 2 = 4
    asl COMM_V      ; Mult 2 = 8
    rol
    clc
    adc STAL + 1
    sta STAL + 1

    clc
    lda COMM_V
    adc STAL
    sta STAL

    bcc @ByPassInc
    inc STAL + 1
    
@ByPassInc
    clc
    lda COMM_R
    adc STAL
    sta STAL
    bcc @ByPassIncAgain
    inc STAL + 1

@ByPassIncAgain
    rts

;*******************************************************************************
;* DOT Function                                                                *
;* This function sets the pixel in the memory locations set by PLACE           *
;* *****************************************************************************
;* Inputs : ZP : C1 and C2, COMM_C                                             *
;*******************************************************************************

DOT
    jsr BANK_OUT_ROM

    ldx COMM_C
    ldy #0
    lda BYTEMASK,x
    pha

SETDOT
    lda COMM_ERASE_ENABLED
    bmi ERASEDOT
    pla
    ora (STAL),y
    jmp Continue
ERASEDOT
    pla
    eor (STAL),y
Continue
    sta (STAL),y

    jsr BANK_IN_ROM
    rts

BANK_OUT_ROM
    sei
    lda 1
    and #%11111110          ; Paging out BASIC ROM
    ;and #%11111101          ; Paging out KERNAL ROM
    sta 1
    rts

BANK_IN_ROM
    lda 1
    ora #%00000001          ; Paging in BASIC ROM
    ;ora #%00000010          ; Paging in KERNAL ROM
    sta 1
    cli
    rts

