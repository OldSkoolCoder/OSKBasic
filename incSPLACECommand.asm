;*******************************************************************************
;* SPLACE Command                                                              *
;* This BASIC function to move a sprite around the screen                      *
;* *****************************************************************************
;* Syntax : SPLACE or sp Shifted L                                             *
;* Inputs : Sprite No                                                          *
;*        : X (0->319) and Y (0 ->199)                                         *
;*        : Sprite Colour                                                      *
;*******************************************************************************

; sprite : sprite no,x,y,col
COM_SPLACE
    jsr GETSpriteNo
    stx COMM_AXLO

    jsr bas_CHKCOM$ ; Checks For a Comma
    jsr GetNo2      ; Get X
    
    cpy #1
    bcc @StoreXPos
    beq @TestingXLo
@IllegalError
    jmp bas_IQERR$

@TestingXLo
    cmp #144
    bcs @IllegalError
@StoreXPos
    sta COMM_XLO
    sty COMM_XHI

    jsr bas_CHKCOM$ ; Checks For a Comma
    jsr bas_GETBYTC$; Get Sprite Y
    stx COMM_Y1

    lda COMM_AXLO
    asl
    tay
    lda COMM_XLO
    sta VICII_SP0X,y
    lda COMM_Y1
    sta VICII_SP0Y,y

    jsr WorkOutSpriteBit
    lda BYTEMASK,x
    eor #%11111111
    and VICII_MSIGX
    sta VICII_MSIGX

    lda COMM_XHI
    beq @SpriteColour
    lda VICII_MSIGX
    ora BYTEMASK,x
    sta VICII_MSIGX

@SpriteColour
    jsr bas_CHKCOM$ ; Checks For a Comma
    jsr bas_GETBYTC$; Get Sprite Colour
    cpx #16
    bcc @SetColour
    jmp bas_IQERR$

@SetColour
    txa
    ldx COMM_AXLO
    sta VICII_SP0COL,x
    rts
    

    