# GRAPHICS EXTENSION COMMANDS FOR THE COMMODORE 64
## RUNS IN THE 6K AT THE TOP OF BASIC MEMORY
## LOADS IN LOCATION 32768 – 38912
### WRITTEN FOR THE COMMODORE 64 BY JOHN C. DALE (aka OldSkoolCoder)
### (C) MARCH 1985 BY DALES♥FT 

This machine code program will provide 25 extra commands for your **COMMODORE 64**. The program will be placed in the top 6K of BASIC ram, but when you run it, it will protect itself.

The commands can be used in program mode and direct mode, but suing the commands in direct mode may result sometimes in a SYNTAX error. 

Pressing **RUN/STOP** and **RESTORE** keys together will reset the computer plus resetting the commands as well. When this happens a message will appear on the screen :-

### GRAPHICS EXTENSION FOR THE COMMODORE 64
### (C) MARCH 1985 BY DALES♥FT
This assures you that the commands are still active in the computer.

# THE COMMANDS AVAILABLE TO YOU
## BOX
The ***BOX*** command draws a box on the Hi-Res screen. The command parameters are two sets of co-ordinates. The first set (X1,Y1) is the lower left hand corner of the box, the second set (X2,Y2) is the top right hand corner of the box. From these co-ordinates the box is drawn.

	Format  :- 	BOX X1, Y1 TO X2, Y2
 
    Example :-	10 GRAPHIC
                20 FOR I = 0 TO 20 STEP 3
                30 BOX I, I TO 200-I, 200-I
                40 NEXT
## CHAR
The ***CHAR*** command put text onto the H-RES screen. The command parameters are the co-ordinates of the text (X,Y), and the text that is to be printed.

	Format  :-	CHAR X, Y, “TEXT”

	Example :-	10 GRAPHIC
			    20 A$ = “COMMANDS”
			    30 CHAR 0, 100, “GRAPHICS”
			    40 CHAR 72, 90, A$
## CIRCLE
The ***CIRCLE*** command draws a circle on the Hi-Res screen. The command parameters are the centre of the circle or ellipse (X,Y), the horizontal and vertical radii (Xrad, Yrad) and where to start and finish the circle (which measured in degrees).

	Format  :-	CIRCLE X, Y, Xrad, Yrad, Start°, Finish°

	Example :- 	10 GRAPHIC
			    20 CIRCLE 160, 100, 40, 0, 361
			    30 CIRCLE 100, 50, 25, 25, 180, 270
			    40 CIRCLE 160, 100, 100, 90, 90, 180
## COLOUR
The ***COLOUR*** command changes the screen and border colours, it also changes the extended background colours if the user wishes. Each Other setting can be between 0 to 255, but as you may know there are only sixteen colours, therefore the colour number must not exceed the value sixteen.

	Format  :- 	COLOUR Border, Screen [, Back, Back2, Back3]
				[…..] these parameters are optional.

	Example :- 	10 PRINT ”CLR”
			    20 FOR I = 0 to 255
			    30 POKE I+1024, I
			    40 POKE 55296+I, 0
			    50 NEXT : POKE 53265, PEEK(53265) OR 64
			    60 FOR COL = 0 to 16
			    70 COLOUR COL, COL+1, COL+2, COL+3, COL+4
			    80 FOR DE = 0 TO 100 : NEXT
			    90 COLOUR 14, 6
			    100 NEXT

**Note** : If you want to change the colour of the Hi-Res picture (not the background), then multiply the screen colour by what colour number you want the picture to be.

## DRAW
The ***DRAW*** command will draw a line on the Hi-Res screen. The command parameters are two sets of co-ordinates. The first set X1, Y1 points to where the line is to start, X2, Y2 points to where the line is to finish.

    Format  :-	DRAW X1, Y1, TO X2, Y2

	Example :-	10 GRAPHIC
			    20 FOR I = 0 TO 200 STEP 10
			    30 DRAW 0, 200-I TO I, 0
			    40 DRAW 319-I, 200 TO 319, I
			    50 DRAW 319-I, 0 TO 319, 200-I
			    60 DRAW 0, I TO I, 200
			    70 NEXT
## ERASE
The ***ERASE*** command puts erase mode on or off. The first time you use this in a program it will turn on erase mode, the second time will switch the mode off. The erase mode will erase any line (or point) on the screen, but if there is no line (or point) then the erase mode will temporarily switch off the erase mode and draw the line (or point), then the erase will switch back on.

	Format  :-	ERASE

	Example :-	10 GRAPHIC
			    20 DRAW 10, 10 TO 100, 100
			    30 ERASE : REM TURN ON ERASE
			    40 DRAW 10, 100 TO 100, 10
			    50 DRAW 10, 10 TO 100, 100
			    60 ERASE : REM TURN OFF ERASE
## FILL
The ***FILL*** command will fill any area in the Hi-Res screen. The command parameters are the co-ordinates of the area to fill. The command works well in areas which have no gaps.

	Format  :-	FILL X, Y

	Example :-	10 GRAPHIC
			    20 CIRCLE 160, 100, 80, 80, 0, 370
			    30 FILL 160, 100
## GRAPHIC
The ***GRAPHIC*** command will put the computer into Hi-Res mode for drawing. The dimensions of the Hi-Res screen are 0 to 319 on the horizontal axis and 0 to 200 on the vertical axis. If values outside these limits are used an ILLEGAL QUANTITY ERROR will result.

	Format  :-	GRAPHIC
## HCHAR
The ***HCHAR*** command is just like the CHAR command but instead of plotting normal text, it puts double height text. The parameters are the co-ordinates of where the text is to be plotted.

	Format  :-	HCHAR X, Y, “TEXT”

	Example :-	10 GRAPHIC
    			20 A$ = “COMMANDS”
			    30 HCHAR 0, 100, “GRAPHICS”
			    40 HCHAR 72, 90, A$
## GDUMP
The ***GDUMP*** Command will read the Hi-Res screen and then print out the screen on the printer, if the user requires a hard copy of the picture. 
## SPRITE
The ***SPRITE*** command is used to set up the information about a sprite. The parameters are the sprite number (0 to 7), the pointer to where the data is stored for that sprite (0 to 255), whether the sprite is on or off, is the sprite expanded horizontally, is the sprite expanded vertically, has the background got priority over the sprite and is the sprite in multi-colour mode (all the information after the pointer is indicated by 0 for off, 1 for on).

	Format  :-	SPRITE Sprite#, Pointer, Exp X, Exp Y, Back, Mult

	Example :-	Look at sprite command example

## MOBCOL
The ***MOBCOL*** command is used to set up both the multi-colour elements of the sprite, when the sprite is in multi-colour mode.

    Format  :-	MOBCOL Col1, Col2

    Example :-	Look at Sprite Command Example
## PLOT
The ***PLOT*** command will plot one single point on a Hi-Res screen. The command parameters are the co-ordinates for the point to be plotted (X,Y).

	Format  :-	PLOT X, Y

	Example :-	10 GRAPHIC
    			20 FOR X = 0 TO 319
	    		30 Y = 100 + (70 * SIN (I / 64))
		    	40 PLOT X, Y
			    50 NEXT
## POLY
The ***POLY*** command will draw a multi sided polygon of the users choice. The command has the same parameters as the circle command, but also has an extra parameter which is the increment angle of the next side to be drawn (this is measured in degrees also). If you want a six sided polygon you work out the increment value by dividing three hundred and sixty degrees by the number of sides.

Therefor 360° / 6 = 60° so the increment angle is 60°.

	Format  :-	POLY X, Y, Xrad, Yrad, Start°, Finish°, Inc°

	Example :-	10 GRAPHIC
			    20 POLY 160, 100, 100, 80, 0, 370, 60
			    30 POLY 160, 100, 50, 50, 0, 370, 120
 
## GPUT
The ***GPUT*** Command will save the Hi-Res screen on the device specified with the filename of the users’ choice.

	Format  :-	GPUT “FILENAME”, Dev
## GPULL
The ***GPULL*** command will load a Hi-Res screen from a specified device, with the filename of the users’ choice.

	Format :-	GPULL “FILENAME”, Dev
## REVERSE
The ***REVERSE*** command makes the Hi-Res screen reverse on. I.e. all the black areas become white and all the white areas become black.

	Format :-	REVERSE
## RJOY
The ***RJOY*** Command will read either port one or port two depending on what is inside the brackets. The value of the joystick will be placed in the variable which the user specified.

	Format  :- 	RJOY ( 0 or 1)
If you put 0 in the brackets that is port two, 1 is port one.

	Example :-	10 A = RJOY(0) : B = RJOY(1)
			    20 PRINT A, B
			    30 GOTO 10
The values you can get from the joystick command is :-

		5    1    9
		 +   +   +
		  +  +  +
		   + + +
	   4 ++++++++++ 8	Fire = 16
		   + + +
		  +  +  +
		 +   +   +
		6    2    10
## RPDL
The ***RPDL*** command will read the paddle specified in the brackets and return that value in the specified variable.

	Format  :-	RPDL (0 or 1)

	Example :-	10 A = RPDL(0) : B = RPDL(1)
			    20 PRINT A, B
			    30 GOTO 10
## SPENABLE
The ***SPENABLE*** command will allow the user to enable a sprite.

    Format :-   SPENABLE Sprite#
## SPDISABLE
The ***SPDISABLE*** command will allow the user to disable a sprite.

    Format :-   SPDISABLE Sprite#
## SPLACE
The ***SPLACE*** command will allow the user to interact wit the sprites and allow the user to easily specify the x,y coordinates and the colour of the sprite too.

    Format :-   SPLACE Sprite#, X, Y, Colour

    Example :-  10 FOR I= 0 TO 62:READ A:POKE 12288 + I,A : NEXT
                20 SPRITE 0, 192, 1, 1, 0, 1
                30 MCOL 12,15
                40 SPLACE 0, 100, 100, 2
                50 SPENABLE 0
                60 GET A$ : IF A$="" THEN 60
                70 SPDISABLE
                1000 REM SPRITE DATA
                1010 DATA 16,0,18
                1020 DATA 8,126,28
                1030 DATA 5,255,204
                1040 DATA 6,16,54
                1050 DATA 15,159,240
                1060 DATA 8,146,16
                1070 DATA 8,243,240
                1080 DATA 8,242,16
                1090 DATA 8,244,8
                1100 DATA 31,254,24
                1110 DATA 32,1,244
                1120 DATA 32,0,164
                1130 DATA 39,128,188
                1140 DATA 39,192,164
                1150 DATA 31,255,252
                1160 DATA 13,60,176
                1170 DATA 25,195,152
                1180 DATA 49,0,140
                1190 DATA 48,0,12
                1200 DATA 120,0,30
                1210 DATA 204,0,51
                