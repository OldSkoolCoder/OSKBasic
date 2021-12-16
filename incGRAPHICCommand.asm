;*******************************************************************************
;* Graphics Routine                                                            *
;* This sets up the VIC Chip into HiRes Graphic Mode                           *
;* *****************************************************************************
;* Syntax : graphic or g shifted R                                             *
;*******************************************************************************

; graphic : graphic
COM_GRAPHIC
;    lda #0
;    sta RIBUF
;    lda #$A0
;    sta RIBUF + 1

;GRAP
;    ldy #0
;GRAP_Loop
;    lda #0
;    sta (RIBUF),y
;    iny
;    bne GRAP_Loop
;    inc RIBUF + 1

;    lda RIBUF + 1
;    cmp #$C0
;    bne GRAP

    lda CIA2_DDRA
    ora #%00000011
    sta CIA2_DDRA

    lda CIA2_PRA
    and #255 - CIA2_PRA_VICBank_Mask
    ora #CIA2_PRA_VICBank_2 ; Change VIC Chip to Bank 2
    ;ora #CIA2_PRA_VICBank_3 ; Change VIC Chip to Bank 3
    sta CIA2_PRA

    lda VICII_VMCSB
    ora #%00001000                  ; Change VIC Chip Video Address
    ;and #%00000001
    ;ora #%00001010                  ; Change VIC Chip Video Address
    sta VICII_VMCSB

    lda VICII_SCROLY
    ora #VICII_SCROLY_ExtendedColourMode
    sta VICII_SCROLY

GRAP_ClearScreen
    ldy #0
    lda COMM_GRAPHIC_COLOUR
GRAP_BlankScreen
    sta $8400,y
    sta $8500,y
    sta $8600,y
    sta $8700,y
    iny
    bne GRAP_BlankScreen

    rts
