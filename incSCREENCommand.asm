;*******************************************************************************
;* Screen Routine                                                              *
;* This sets up the VIC Chip into Text Mode                                    *
;*******************************************************************************
;* Syntax : screen or s shifted C                                              *
;*******************************************************************************

; screen : screen

COM_SCREEN
    lda CIA2_DDRA
    ora #%00000011          ; Set CIA 2 bits 0/1 to be output Bits
    sta CIA2_DDRA

    lda CIA2_PRA
    and #255 - CIA2_PRA_VICBank_Mask
    ora #CIA2_PRA_VICBank_0 ; Set to VIC Bank 0
    sta CIA2_PRA

    lda VICII_SCROLY
    and #VICII_SCROLY_NormalColourMode
    sta VICII_SCROLY        ; Back to Text Mode

    lda #21
    sta VICII_VMCSB         ; set video address to $0400
    rts


