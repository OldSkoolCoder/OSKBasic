;*******************************************************************************
;* ERASE Command                                                               *
;* This BASIC function Erases Lines and shapes                                 *
;* *****************************************************************************
;* Syntax : ERASE or e Shifted R                                               *
;* Inputs :                                                                    *
;*******************************************************************************

; erase : erase
COM_ERASE
    lda COMM_ERASE_ENABLED
    eor #$80
    sta COMM_ERASE_ENABLED
    rts