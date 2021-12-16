;*******************************************************************************
;* Tokaniser Routine                                                           *
;*******************************************************************************

VEC_TOKAN
    jsr bas_CRUNCH$ + 3
    ldy #5
LOOPOT
    lda Buffer-5,y
    beq CNCHRT
    cmp #CHR_Quote
    beq LOOPQT
    cmp #"a"
    bcc LOOPBK
    cmp #"["
    bcs LOOPBK
    sty $B1
    ldx #$00
    stx $0B
    cmp #128
    bcc LOOPIN
    eor #128

LOOPIN
    sec
    sbc Command_LIST,x
    beq NEXT
    cmp #128
    beq DONE

LOOPNO
    lda Command_LIST,x
    beq LOOPBK
    bmi CONTLP
    inx
    bne LOOPNO

CONTLP
    inc $0B
    ldy $B1
    byte $A9

NEXT
    iny
    lda Buffer-5,y
    inx
    bne LOOPIN

DONE
    ldx $B1
    lda $0B
    clc
    adc #$CC
    sta Buffer-5,x

LOOPC
    iny
    inx
    lda Buffer-5,y
    sta Buffer-5,x
    bne LOOPC
    
    ldy $B1

LOOPBK
    iny
    bne LOOPOT

LOOPQT
    iny
    lda Buffer-5,y
    beq CNCHRT
    cmp #CHR_Quote
    bne LOOPQT
    beq LOOPBK

CNCHRT
    lda #0
    sta Buffer-5,y
    rts
;    lda #0
;    sta $0B
;    sta $7A
;    jmp bas_CRUNCH$ + 3

;******************************************************************************
;* Command List                                                               *
;******************************************************************************

Command_LIST
    text "graphiC"
    text "screeN"
    text "rploT"
    text "ploT"
    text "draW"
    text "circlE"
    text "colouR"
    text "erasE"
    text "shapE"
    text "reversE"
    text "boX"
    text "joY"
    text "chaR"
    text "hchaR"
    text "mobcoL"
    text "splacE"
;    text "spdisablE"
;    text "spenablE"
    text "spritE"
    text "sP"
    text "filL"
    text "gpuT"
    text "gpulL"
    text "gdumP"
    text "sounD"
    text "voicE"
    text "ofF"
    text "channeL"
    text "trianglE"
    text "saW"
    text "pulsE"
    text "noisE"
    text "clG"
    brk

;******************************************************************************
;* Command Address                                                            *
;******************************************************************************

TOKANISER_ON                        = $91
TOKANISER_OFF                       = $E4
TOKANISER_TRIANGLE                  = $E6
TOKANISER_SAW                       = $E7
TOKANISER_PULSE                     = $E8
TOKANISER_NOISE                     = $E9

Command_ADDR
    ; Direct & Program Commands
    word COM_GRAPHIC - 1            ; Tokan $CC
    word COM_SCREEN - 1             ; Tokan $CD
    word COM_RPOINT - 1             ; Tokan $CE
    word COM_POINT - 1              ; Tokan $CF
    word COM_DRAW - 1               ; Tokan $D0
    word COM_CIRCLE - 1             ; Tokan $D1
    word COM_COLOUR - 1             ; Tokan $D2
    word COM_ERASE - 1              ; Tokan $D3
    word COM_SHAPE - 1              ; Tokan $D4
    word COM_REVERSE - 1            ; Tokan $D5
    word COM_BOX - 1                ; Tokan $D6
    word COM_JOY - 1                ; Tokan $D7
    word COM_CHAR - 1               ; Tokan $D8
    word COM_HCHAR - 1              ; Tokan $D9
    word COM_MOBCOL - 1             ; Tokan $DA
    word COM_SPLACE - 1             ; Tokan $DB
;    word COM_SPROFF - 1             ; Tokan $DC
;    word COM_SPRON - 1              ; Tokan $DD
    word COM_SPRITE - 1             ; Tokan $DC
    word COM_SP - 1                 ; Tokan $DD
    word COM_FILL - 1               ; Tokan $DE
    word COM_GSAVE - 1              ; Tokan $DF
    word COM_GLOAD - 1              ; Tokan $E0
    word COM_GDUMP - 1              ; Tokan $E1
    word COM_SOUND - 1              ; Tokan $E2
    word COM_VOICE - 1              ; Tokan $E3
    word COM_OFF - 1                ; Tokan $E4
    word COM_CHANNEL - 1            ; Tokan $E5
    word COM_TRIANGLE - 1           ; Tokan $E6
    word COM_SAW - 1                ; Tokan $E7
    word COM_PULSE - 1              ; Tokan $E8
    word COM_NOISE - 1              ; Tokan $E9
    word COM_CLG - 1                ; Tokan $EA
    
    ; Program Commands Only

