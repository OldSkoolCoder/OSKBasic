;*******************************************************************************
;* OldSkoolCoder BASIC                                                         *
;*                                                                             *
;* Written By John C. Dale                                                     *
;*                                                                             *
;* Date 26th October 2020                                                      *
;*******************************************************************************
;*                                                                             *
;* Change History                                                              *
;* 26th Oct 2020  : Created new project for use in the new OSKBasic Twitch Sers*
;*  2nd Nov 2020  : Added BASIC Tokaniser and Lister functions for new commands*
;* 23rd Nov 2020  : Added BASIC Evaluator, Executioner, Graphic and Screen Code*
;*  7th Dec 2020  : Added Graphics Functions and BASIC Commands:PLOT and RPOINT*
;* 14th Dec 2020  : Added BASIC Commands:DRAW                                  *
;* 29th Dec 2020  : Updated BASIC Commands:DRAW to not use any BASIC Functions *
;*  6th Jan 2021  : Addes BASIC Commands: CIRCLE, COLOUR, ERASE                *
;* 24th Feb 2021  : Addes BASIC Commands: SHAPE                                *
;*  3rd Mar 2021  : Addes REVERSE, BOX and JOY                                 *
;* 10th Mar 2021  : Added CHAR, HCHAR and SPRITE                               *
;* 17th Mar 2021  : Added MOB, MOBCOL, FILL                                    *
;* 24th Mar 2021  : Added SPON,SPOFF,SPLACE, Redefine SPRITE, GDUMP, GLOAD,    *
;*                  GSAVE                                                      *
;* 31th Mar 2021  : Added VOICE, SOUND, CHANNEL, OFF                           *
;* 14th Apr 2021  : Added TRIANGLE, SAW, PULSE and NOISE, redeveloped SPRON/OFF*
;*                : Added CLG                                                  *
;* 21st Apr 2021  : Configure to be a Cartridge File                           *
;*                  cartconv -t normal -name "OSK Graphics Extension"          *
;*                             -i oskbasic.prg -o oskbasic.crt                 *
;*******************************************************************************

* = $8000           ; Cartridge start Code
CARTSTART = *

;*******************************************************************************
;* Includes                                                                    *
;*******************************************************************************

incasm "incCartInitiate.asm"
incasm "libROMRoutines.asm"
incasm "libBASICRoutines.asm"
incasm "libCharacterPETSCIIConst.asm"
incasm "libGraphicsRoutines.asm"
incasm "incBASICTokaniser.asm"
incasm "incBASICLister.asm"
incasm "incBASICEvalMy.asm"
incasm "incBASICByeBye.asm"
incasm "incVICChipLocations.asm"
incasm "incCIAChipLocations.asm"
*=$8400
    dcb $0400, $01

;*******************************************************************************
;* Extra BASIC Graphic Command                                                 *
;*******************************************************************************
*=$8800
incasm "incBASICErrorHandler.asm"
incasm "incGRAPHICCommand.asm"
incasm "incSCREENCommand.asm"
incasm "incPLOTCommand.asm"
incasm "incUtilities.asm"
incasm "incRPOINTCommand.asm"
incasm "incDRAWCommand.asm"
incasm "incCIRCLECommand.asm"
incasm "incCOLOURCommand.asm"
incasm "incERASECommand.asm"
incasm "incSHAPECommand.asm"
incasm "incREVERSECommand.asm"
incasm "incBOXCommand.asm"
incasm "incJOYCommand.asm"
incasm "incCHARCommand.asm"
incasm "incHCHARCommand.asm"
incasm "incSPLACECommand.asm"
incasm "incSPRITECommand.asm"
incasm "incMOBCOLCommand.asm"
incasm "incFILLCommand.asm"
;incasm "incSPONCommand.asm"
;incasm "incSPOFFCommand.asm"
incasm "incSPCommand.asm"
incasm "incGSAVECommand.asm"
incasm "incGLOADCommand.asm"
incasm "incGDUMPCommand.asm"
incasm "incSOUNDCommand.asm"
incasm "incVOICECommand.asm"
incasm "incOFFCommand.asm"
incasm "incCHANNELCommand.asm"
incasm "incTRIANGLECommand.asm"
incasm "incSAWCommand.asm"
incasm "incPULSECommand.asm"
incasm "incNOISECommand.asm"
incasm "incCLGCommand.asm"

;*******************************************************************************
;* Variables                                                                   *
;*******************************************************************************

Buffer      = 512
SCROLX      = $D016
RIBUF       = $F7
STAL        = $C1
MEMUSS      = $C3
INDEX       = $22
ROBUF       = $F9
LINNUM      = $14
SCREENRAM   = $0400         ; $0400
SPRITE_POINTERS = $07F8
BITMAP_START    = $A000     ; $A000
BITMAP_END      = $C000     ; $C000

;*******************************************************************************
;* Code                                                                        *
;*******************************************************************************

;*******************************************************************************
;* Storage Locations                                                           *
;*******************************************************************************
COMM_XLO             = $02A8
    ;brk 
COMM_XHI             = COMM_XLO + 1
    ;brk 
COMM_Y               = COMM_XHI + 1
    ;brk 
COMM_U               = COMM_Y + 1
    ;brk 
COMM_V               = COMM_U + 1
    ;brk 
COMM_SLO             = COMM_V + 1
    ;brk 
COMM_SHI             = COMM_SLO + 1
    ;brk 
COMM_R               = COMM_SHI + 1
    ;brk 
COMM_C               = COMM_R + 1
    ;brk 
COMM_X1LO            = COMM_C + 1
    ;brk 
COMM_X1HI            = COMM_X1LO + 1
    ;brk 
COMM_X2LO            = COMM_X1HI + 1
    ;brk
COMM_X2HI            = COMM_X2LO + 1
    ;brk 
COMM_Y1              = COMM_X2HI + 1
    ;brk
COMM_Y2              = COMM_Y1 + 1
    ;brk 
COMM_XDLO            = COMM_Y2 + 1
    ;brk 
COMM_XDHI            = COMM_XDLO + 1
    ;brk
COMM_XXLO            = COMM_XDHI + 1
    ;brk 
COMM_XXHI            = COMM_XXLO + 1
    ;brk 
COMM_YY              = COMM_XXHI + 1
    ;brk 
COMM_YD              = COMM_YY + 1
    ;brk 
COMM_XLLO            = COMM_YD + 1
    ;brk 
COMM_XLHI            = COMM_XLLO + 1
    ;brk 
COMM_YL              = COMM_XLHI + 1
    ;brk 
COMM_AXLO            = COMM_YL + 1
    ;brk 
COMM_AXHI            = COMM_AXLO + 1
    ;brk 
COMM_AY              = COMM_AXHI + 1
    ;brk 
COMM_RXLO            = COMM_AY + 1
    ;brk 
COMM_RXHI            = COMM_RXLO + 1
    ;brk 
COMM_RY              = COMM_RXHI + 1
    ;brk 
COMM_XRLO            = COMM_RY + 1
    ;brk 
COMM_XRHI            = COMM_XRLO + 1
    ;brk 
COMM_YR              = COMM_XRHI + 1
    ;brk 
COMM_START           = COMM_YR + 1
    ;text "aaaaaa
COMM_FINISH          = COMM_START + 6
    ;text "aaaaaa
COMM_INCR            = COMM_FINISH + 6
    ;text "aaaaaa

ResultFrac  = COMM_INCR + 6
Result      = ResultFrac + 1
ResultHi    = Result + 1

Working     = ResultHi + 1
WorkingHi   = Working + 1

Estimate    = WorkingHi + 1
EstimateHi  = Estimate + 1

Number      = EstimateHi + 1
NumberHi    = Number + 1
Divisor     = NumberHi + 1
DivisorHi   = Divisor + 1
                                        ; xxxx 3210
DrawingExecutionDriver = DivisorHi + 1  ; xxxx YYXX
                                        ;      XYXY 0 = Add, 1 = Subtract
                                        ;

COMM_XLFRAC = DrawingExecutionDriver + 1
COMM_YLFRAC = COMM_XLFRAC + 1
COMM_GRAPHIC_COLOUR = COMM_YLFRAC + 1
COMM_ERASE_ENABLED = COMM_GRAPHIC_COLOUR + 1

COMM_CXHI            = COMM_ERASE_ENABLED + 1
COMM_CXLO            = COMM_CXHI + 1
COMM_CY              = COMM_CXLO + 1

COMM_VOICEGATES      = COMM_CY + 1
COMM_NEXT_VAR        = COMM_VOICEGATES + 4

BYTEMASK
    BYTE $80, $40, $20, $10, $08, $04, $02, $01

*=$9FFF
    brk
;*=$A000
;incbin "basic.bin"
