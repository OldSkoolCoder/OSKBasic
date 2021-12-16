;*******************************************************************************
;* Library of Functions that will be used throughout the code.                 *
;*******************************************************************************

;*******************************************************************************
;* 16Bit Divide Function                                                       *
;* This function works out the binary fraction of two 16 bit numbers           *
;* *****************************************************************************
;* Inputs : Number (Number to be divided by)                                   *
;*        : Divsor (The Number To divide by)                                   *
;*******************************************************************************

;ResultFrac  = $13
;Result      = $14
;ResultHi    = $15

;Working     = $16
;WorkingHi   = $17

;Estimate    = $18
;EstimateHi  = $19

;Number      = $1A
;NumberHi    = $1B
;Divisor     = $1C
;DivisorHi   = $1D

Divide16Bit
; Reset All Variables
    lda #0
    sta ResultHi
    sta Result
    sta ResultFrac

    sta Working
    sta WorkingHi
    sta Estimate
    sta EstimateHi

    ;sta Number
    ;sta NumberHi
    ;sta Divisor
    ;sta DivisorHi

    lda Number
    sta Working
    lda NumberHi
    sta WorkingHi

; Load the Numbers to Divide
;    lda #22
;    sta Number
;    sta Working

;    lda #7
;    sta Divisor

; Start Divide Process
    ldy #0

@BitLevelLoop
    asl Working         ; Roll 0 into left hand side
    rol WorkingHi       ; Roll into Hi Byte To

    rol Estimate        ; Roll Result of Working Bit into Estimate
    rol EstimateHi

    lda EstimateHi
    cmp DivisorHi
    bcc @DivisorNotFit  ; EstimateHi < DivisorHi, So not fitting
    bne @DivisorFits    ; If Estimate <> Divisor then its greater than

    ; EstimateHi >= DivisorHi, so now Test Lo bytes
    lda Estimate
    cmp Divisor
    bcs @DivisorFits    ; The Estimate is bigger than Divisor

@DivisorNotFit
    asl ResultFrac      ; Estimate is still to small, roll in a Zero
    jmp @RotateRoundResult

@DivisorFits
    lda Estimate        ; Estimate is bigger than Divisor
    sec
    sbc Divisor         ; Subtract Divisor
    sta Estimate

    lda EstimateHi
    sbc DivisorHi
    sta EstimateHi

    sec                 ; Set the Carry
    rol ResultFrac      ; Roll in a One

@RotateRoundResult
    rol Result          ; Contine Roll for all Result Bytes
    rol ResultHi
    
@CheckRightNumDigits
    iny                 
    cpy #24             ; have we run thru all 24 bits (Frac/Lo/Hi)
    bne @BitLevelLoop   ; Nope, loop back round

    rts                 ; Yes then Stop
