;*******************************************************************************
;* SOUND Command                                                               *
;* This BASIC function to set up the Voice Envelope                            *
;* *****************************************************************************
;* Syntax : SOUND Freq, Pulse, Attack, Decay, Sustain, Release                 *
;* Inputs :                                                                    *
;*        :                                                                    *
;*******************************************************************************

; sound : Freq......

COM_SOUND
    lda #$00
    ldy COMM_AY         ; Voice OffSet V1 = 0, V2 = 7, V3 = 14
    sta $D400,y
    sta $D401,y
    sta $D402,y
    sta $D403,y
    ;sta $D404,y
    sta $D405,y
    sta $D406,y

    jsr GETNO2
    ldx COMM_AY
    sta $D400,x
    tya
    sta $D401,x

    jsr bas_CHKCOM$
    jsr GETNO2
    cpy #$10
    bcc @NotIllegal
    jmp bas_IQERR$

@NotIllegal
    ldx COMM_AY
    sta $D402,x
    tya
    sta $D403,x
    jsr GetSoundOneByte     ; Attack
    asl
    asl
    asl
    asl
    ldx COMM_AY
    sta $D405,x
    jsr GetSoundOneByte     ; Decay
    ldx COMM_AY
    ora $D405,x
    sta $D405,x

    jsr GetSoundOneByte     ; Sustain
    asl
    asl
    asl
    asl
    ldx COMM_AY
    sta $D406,x
    jsr GetSoundOneByte     ; Release
    ldx COMM_AY
    ora $D406,x
    sta $D406,x
    rts

GetSoundOneByte
    jsr bas_CHRGOT$
    jsr bas_CHKCOM$
    jsr bas_GETBYTC$
    cpx #$10
    bcc @NotIllegal
    jmp bas_IQERR$

@NotIllegal
    txa
    and #%00001111
    rts


