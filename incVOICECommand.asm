;*******************************************************************************
;* VOICE Command                                                               *
;* This BASIC function to set up the Voice Channel                             *
;* *****************************************************************************
;* Syntax : VOICE Voice#, Continue/Not, Volumn                                 *
;* Inputs :                                                                    *
;*        :                                                                    *
;*******************************************************************************

; sound : Voice# (0-3), (0-255), (0-15)

COM_VOICE
    jsr bas_GETBYTC$
    cpx #4
    bcc @NotIllegal

@VOICE_Illegal
    jmp bas_IQERR$

@NotIllegal
    cpx #0
    beq @VOICE_Illegal
    stx COMM_AY             ; VOICE Offset
    stx COMM_CY             ; VOICE No

    lda #$F9
    ldy #0

@VoiceLooper
    clc
    adc #$07
    iny
    cpy COMM_AY
    bne @VoiceLooper
    sta COMM_AY

    jsr bas_CHRGOT$
    cmp #44             ; Comma
    bne VOICE_EXIT
    jsr bas_CHRGET$
    jsr GetVoiceType
    ; jsr bas_GETBYTC$
;    cpx #2
;    bcc @NotIllegal2
;    jmp bas_IQERR$

;@NotIllegal2
    txa
    ldy COMM_CY
    sta COMM_VOICEGATES,y

    jsr bas_CHRGET$
    cmp #44             ; Comma
    bne VOICE_EXIT
    jsr bas_CHRGET$
    jsr bas_GETBYTC$
    cpx #$10
    bcc @NotIllegal3
    jmp bas_IQERR$

@NotIllegal3
    stx $D418

VOICE_EXIT
    rts

GetVoiceType
    cmp #TOKANISER_TRIANGLE
    bne @IsItSAWTooth
    ldx #$10
    rts

@IsitSAWTooth
    cmp #TOKANISER_SAW
    bne @IsItPulse
    ldx #$20
    rts

@IsItPulse
    cmp #TOKANISER_PULSE
    bne @IsItNoise
    ldx #$40
    rts

@IsItNoise
    cmp #TOKANISER_NOISE
    bne @Error
    ldx #$80
    rts

@Error
    pla         ; Pull this JSR Return
    pla
    pla         ; Pull Basic JSR Return
    pla
    jmp SYNTAX_ERROR
