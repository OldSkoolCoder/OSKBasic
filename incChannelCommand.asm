COM_CHANNEL
    jsr bas_GETBYTC$
    cpx #4
    bcc @NotIllegal

@VOICE_Illegal
    jmp bas_IQERR$

@NotIllegal
    cpx #0
    beq @VOICE_Illegal
    stx COMM_AY
    stx COMM_CY         ; VoiceNo

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

    cmp #TOKANISER_OFF
    bne @NextOption
    ldy COMM_CY
    lda COMM_VOICEGATES,y
    and #%11111110
    sta COMM_VOICEGATES,y
    jmp @ApplySIDValue

@NextOption
    cmp #TOKANISER_ON
    bne @NextOption
    ldy COMM_CY
    lda COMM_VOICEGATES,y
    ora #%00000001
    sta COMM_VOICEGATES,y

@ApplySIDValue
    lda COMM_VOICEGATES,y
    ldy COMM_AY
    sta $D404,y
    jmp bas_CHRGET$

