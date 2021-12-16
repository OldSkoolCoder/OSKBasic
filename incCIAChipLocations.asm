CIA1    = $DC00

CIA1_PRA  = $DC00

CIA1_PRA_Joystick2_Up       = %00000001
CIA1_PRA_Joystick2_Down     = %00000010
CIA1_PRA_Joystick2_Left     = %00000100
CIA1_PRA_Joystick2_Right    = %00001000
CIA1_PRA_Joystick2_Fire     = %00010000

CIA1_PRA_Paddle1_Fire       = %00000100
CIA1_PRA_Paddle2_Fire       = %00001000

CIA1_PRA_Keyboard_Col5      = %00010000
CIA1_PRA_Keyboard_Col6      = %00100000
CIA1_PRA_Keyboard_Col7      = %01000000

CIA1_PRB  = $DC01

CIA1_PRB_Joystick1_Up       = %00000001
CIA1_PRB_Joystick1_Down     = %00000010
CIA1_PRB_Joystick1_Left     = %00000100
CIA1_PRB_Joystick1_Right    = %00001000
CIA1_PRB_Joystick1_Fire     = %00010000

CIA1_PRB_Paddle1_Fire       = %00000100
CIA1_PRB_Paddle2_Fire       = %00001000

CIA1_PRB_Keyboard_Col5      = %00010000
CIA1_PRB_Keyboard_Col6      = %00100000
CIA1_PRB_Keyboard_Col7      = %01000000

CIA1_DDRA  = $DC02

CIA_DDR_Bit0_Direction_Output  = %00000001
CIA_DDR_Bit0_Direction_Input  = 255 - CIA_DDR_Bit0_Direction_Output ; %11111110
CIA_DDR_Bit1_Direction_Output  = %00000010
CIA_DDR_Bit1_Direction_Input  = 255 - CIA_DDR_Bit1_Direction_Output ; %11111101
CIA_DDR_Bit2_Direction_Output  = %00000100
CIA_DDR_Bit2_Direction_Input  = 255 - CIA_DDR_Bit2_Direction_Output ; %11111011
CIA_DDR_Bit3_Direction_Output  = %00001000
CIA_DDR_Bit3_Direction_Input  = 255 - CIA_DDR_Bit3_Direction_Output ; %11110111
CIA_DDR_Bit4_Direction_Output  = %00010000
CIA_DDR_Bit4_Direction_Input  = 255 - CIA_DDR_Bit4_Direction_Output ; %11101111
CIA_DDR_Bit5_Direction_Output  = %00100000
CIA_DDR_Bit5_Direction_Input  = 255 - CIA_DDR_Bit5_Direction_Output ; %11011111
CIA_DDR_Bit6_Direction_Output  = %01000000
CIA_DDR_Bit6_Direction_Input  = 255 - CIA_DDR_Bit6_Direction_Output ; %10111111
CIA_DDR_Bit7_Direction_Output  = %10000000
CIA_DDR_Bit7_Direction_Input  = 255 - CIA_DDR_Bit7_Direction_Output ; %01111111

CIA1_DDRB  = $DC03

CIA1_TIMALO  = $DC04
CIA1_TIMAHI  = $DC05

CIA1_TIMBLO  = $DC06
CIA1_TIMBHI  = $DC07

CIA1_TODTEN  = $DC08
CIA1_TODSEC  = $DC09
CIA1_TODMIN  = $DC0A
CIA1_TODHRS  = $DC0B

CIA1_SDR  = $DC0C

CIA1_ICR  = $DC0D

CIA1_CRA  = $DC0E

CIA1_CRB  = $DC0F

CIA2    = $DD00

CIA2_PRA  = $DD00
CIA2_PRA_VICBank_Mask = %00000011
CIA2_PRA_VICBank_0  = %00000011
CIA2_PRA_VICBank_1  = %00000010
CIA2_PRA_VICBank_2  = %00000001
CIA2_PRA_VICBank_3  = %00000000

CIA2_PRB  = $DD01

CIA2_DDRA  = $DD02
CIA2_DDRB  = $DD03

CIA2_TI2ALO  = $DD04
CIA2_TI2AHI  = $DD05

CIA2_TI2BLO  = $DD06
CIA2_TI2BHI  = $DD07

CIA2_TO2TEN  = $DD08
CIA2_TO2SEC  = $DD09
CIA2_TO2MIN  = $DD0A
CIA2_TO2HRS  = $DD0B

CIA2_SDR  = $DD0C

CIA2_ICR  = $DD0D

CIA2_CRA  = $DD0E
CIA2_CRB  = $DD0F
