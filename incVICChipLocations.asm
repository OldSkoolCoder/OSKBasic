VICII   = $D000 ; Start Address Of The VIC II Chip
VICII_SP0X    = $D000 ; Sprite 0 Horizontal Position
VICII_SP0Y    = $D001 ; Sprite 0 Vertical Position
VICII_SP1X    = $D002 ; Sprite 1 Horizontal Position
VICII_SP1Y    = $D003 ; Sprite 1 Vertical Position
VICII_SP2X    = $D004 ; Sprite 2 Horizontal Position
VICII_SP2Y    = $D005 ; Sprite 2 Vertical Position
VICII_SP3X    = $D006 ; Sprite 3 Horizontal Position
VICII_SP3Y    = $D007 ; Sprite 3 Vertical Position
VICII_SP4X    = $D008 ; Sprite 4 Horizontal Position
VICII_SP4Y    = $D009 ; Sprite 4 Vertical Position
VICII_SP5X    = $D00A ; Sprite 5 Horizontal Position
VICII_SP5Y    = $D00B ; Sprite 5 Vertical Position
VICII_SP6X    = $D00C ; Sprite 6 Horizontal Position
VICII_SP6Y    = $D00D ; Sprite 6 Vertical Position
VICII_SP7X    = $D00E ; Sprite 7 Horizontal Position
VICII_SP7Y    = $D00F ; Sprite 7 Vertical Position
VICII_MSIGX   = $D010   ; Most Significant Bits of Sprites 0-7 Horizontal Position
                        ; Bit 0:  Most significant bit of Sprite 0 horizontal position
                        ; Bit 1:  Most significant bit of Sprite 1 horizontal position
                        ; Bit 2:  Most significant bit of Sprite 2 horizontal position
                        ; Bit 3:  Most significant bit of Sprite 3 horizontal position
                        ; Bit 4:  Most significant bit of Sprite 4 horizontal position
                        ; Bit 5:  Most significant bit of Sprite 5 horizontal position
                        ; Bit 6:  Most significant bit of Sprite 6 horizontal position
                        ; Bit 7:  Most significant bit of Sprite 7 horizontal position
VICII_MSGX_SP0Y_On = %00000001
VICII_MSGX_SP1Y_On = %00000010
VICII_MSGX_SP2Y_On = %00000100
VICII_MSGX_SP3Y_On = %00001000
VICII_MSGX_SP4Y_On = %00010000
VICII_MSGX_SP5Y_On = %00100000
VICII_MSGX_SP6Y_On = %01000000
VICII_MSGX_SP7Y_On = %10000000

VICII_SCROLY  = $D011   ; Vertical Fine Scrolling and Control Register
                        ; Bits 0-2:  Fine scroll display vertically by X scan lines (0-7)
                        ; Bit 3:  Select a 24-row or 25-row text display (1=25 rows, 0=24 rows)
                        ; Bit 4:  Blank the entire screen to the same color as the background
                        ;   (0=blank)
                        ; Bit 5:  Enable bitmap graphics mode (1=enable)
                        ; Bit 6:  Enable extended color text mode (1=enable)
                        ; Bit 7:  High bit (Bit 8) of raster compare register at 53266 ($D012)

VICII_SCROLY_FineScroll_Mask = %00000011
VICII_SCROLY_25Rw = %00000100
VICII_SCROLY_24Rw = 255 - VICII_SCROLY_25Rw   ; %11111011
VICII_SCROLY_RestoreScreen = %00001000
VICII_SCROLY_BlankScreen = 255 - VICII_SCROLY_RestoreScreen ; %11110111
VICII_SCROLY_GraphicsMode = %00010000
VICII_SCROLY_NormalMode = 255 - VICII_SCROLY_GraphicsMode ; %11101111
VICII_SCROLY_ExtendedColourMode = %00100000
VICII_SCROLY_NormalColourMode = 255 - VICII_SCROLY_ExtendedColourMode ; %11011111
VICII_SCROLY_RasterCompareMask = %11000000

VICII_RASTER  = $D012

VICII_LPENX   = $D013
VICII_LPENY   = $D014

VICII_SPENA   = $D015

VICII_SCROLX  = $D016

VICII_YXPAND  = $D017

VICII_VMCSB   = $D018

VICII_VICIRQ  = $D019

VICII_IRQMASK = $D01A

VICII_SPBGPR   = $D01B

VICII_SPMC    = $D01C

VICII_XXPAND  = $D01D

VICII_SPSPCL  = $D01E
VICII_SPBGCL  = $D01F

VICII_EXTCOL  = $D020
VICII_BGCOL0  = $D021          
VICII_BGCOL1  = $D022
VICII_BGCOL2  = $D023
VICII_BGCOL3  = $D024

VICII_SPMC0   = $D025
VICII_SPMC1   = $D026

VICII_SP0COL  = $D027
VICII_SP1COL  = $D028
VICII_SP2COL  = $D029
VICII_SP3COL  = $D01A
VICII_SP4COL  = $D01B
VICII_SP5COL  = $D01C
VICII_SP6COL  = $D01D
VICII_SP7COL  = $D01E
