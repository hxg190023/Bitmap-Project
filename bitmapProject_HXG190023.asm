#---------------------------------------------------------------------------#
# Name:					Harsh Gopalan (NET ID: HXG190023)
# Professor/Instructor: 		Dr. Karen Mazidi
# Class and Section Number: 		CS 2340. 003
# Date Started/Finised Assignment:    	10/18/2021 - 11/07/2021
# Assignment Title: 			Bitmap Project

# Info. About Program: 			1132 Lines Without Comments & Whitespace
#---------------------------------------------------------------------------#

#################################
# The width and height of the pixel is set.
#################################
.eqv 	WIDTH 	64
.eqv 	HEIGHT 	64
#################################

#################################
# The MEM address is set. 
#################################
.eqv 	MEM 	0x10010000 	  	# (0,0)
#################################

#################################
# The colors that will be used in the program. 
#################################
.eqv 	RED 	0x00FF0000
.eqv	BLUE	0x000000FF
.eqv 	MAGENTA 0x00FF00FF
.eqv 	WHITE 	0x00FFFFFF
.eqv 	YELLOW	0x00FFFF00
.eqv 	CYAN 	0x0000FFFF
.eqv	GREEN 	0x0000FF00
.eqv 	ORANGE 	0x00FFA533
.eqv 	PURPLE	0x008D33FF
.eqv 	GRAY	0x00808080
.eqv 	MAROON	0x00800000
#################################

.data
openingStatement:	.asciiz 	"Welcome to The T-T-T Game! \n\nPlease make sure to follow the instructions carefully.\nPlease read all the instructions first and then begin playing the game.\nDetailed instructions with images and snippets of the code are in the report, and it is best to review the report and the following instructions before playing.\n\n"
settingUpGame:		.asciiz		"Set both the Unit Width and Unit Height in Pixels to 4. \nSet both the Display Width and Display Height to 256. \nSet the Base address for display as static data. \nMake sure to connect the Bitmap Display and the Keyboard & Display MMIO Simulator to MIPS.\nOnce you set both of these up, you can assemble and run the program.\n\n"
instructions1: 		.asciiz		"Once the program has been assembled and the run program button is clicked, the gameboard will be drawn.\nPlease wait till the entire gameboard is drawn until you begin playing the game.\nMake sure to turn the volume up when the program starts, as there is a unique sound effect when the shapes are drawn.\n\nOnce the game board is fully drawn, the first player can start by picking a box to draw their shape.\nThe boxes are labeled 1-9, horizontally. (1-3) first row, (4-6) second row, (7-9), third row.\nMake sure to select the box number first.\nOnce the box number is selected, do not click enter or any other key as this will mess up the program.\nContinue reading the instructions once the box number is selected.\n\nNext, select one of the colors listed below by clicking the correct key on keyboard: \n"
listingColors: 		.asciiz		"Red: r    Blue: b    Magenta: m    White: w \nYellow: y    Cyan: c    Green: g    Orange: o \nPurple: u    Gray: i    Maroon: n\n\nOnce again continue reading the instructions once the color is selected and do not press enter or any other key until you read the next set of instructions.\n\n"
instructions2: 		.asciiz		"Finnaly, select one of the shapes listed below: \nPlus Sign: p    Minus Sign: s    Square Box: o    X-Shape: x Smiley Face Shape: f\n\n"
instructions3: 		.asciiz		"Once this is done, your selected shape will be drawn in your chosen color at your chosen box. \nMake sure to do the steps in that order, as the program will not work if it is not done in that order. \nOnce the first player has finished their turn, the next can go, and the game can be played until the game ends. \nThe program will not let the user know who won, but looking at the game-board, this can be figured out.\n\n"
instructions4:		.asciiz		"To exit the game, press the spacebar.\n\n"
exitMessage: 		.asciiz		"The program will now exit!"
currentTurn:		.asciiz		"Playing Turn Queue: \n\n"
player2Message: 	.asciiz		"Player 2 Go.\n\n"
player1Message: 	.asciiz		"Player 1 Go.\n\n"
pickBoxMessage:		.asciiz		"Box.\n\n"
pickColorMessage:	.asciiz		"Color.\n\n"
pickShapeMessage:	.asciiz		"Shape. \n\n\n\n"
newLine:		.asciiz		"\n\n"

.text
main:
	# The program instructions are printed on the console for the user.
	# Series of string syscalls.
	li 	$v0, 4
	la	$a0, openingStatement
	syscall
	
	# The setting up of the game - instructions is printed.
	li 	$v0, 4
	la	$a0, settingUpGame
	syscall
	
	# Lets the user know that they need to start once the gameboard is fully drawn.
	li 	$v0, 4
	la	$a0, instructions1
	syscall
	
	# The colors that are available for the user are printed for the user.
	li 	$v0, 4
	la	$a0, listingColors
	syscall
	
	# The shapes that are available for the user are printed for the user.
	li 	$v0, 4
	la	$a0, instructions2
	syscall
	
	# Lets the user know that the second player can go after the first player.
	li 	$v0, 4
	la	$a0, instructions3
	syscall
	
	# Lets the user know that they can click the space bar to exit the program.
	li 	$v0, 4
	la	$a0, instructions4
	syscall
	
	# Prints the Turn Queue Message.
	li 	$v0, 4
	la	$a0, currentTurn
	syscall
	
	#################################
	# Register Usage (Registers used throughout the Program): 
	# $a0: Used for the x-coordinate of the pixel
	# $a1: Used for the y-coordinate of the pixel
	# $a2: Used for the color of the pixel 
	# $t9: Used for maintaining count of which player can go (player count)
	# $t7, $t8: Used for the smaller functions to maintain the loop count
	# $t1, $t2, $t3, $t4, $t6, $s7: Temporary registers used to move before a series of marquee effect calls or calls made to the unique sound functions. 
	# $s1: Used in the big "loop" functions to check which branch to go to
	# $t5: Used for the loop inside the loop function
	#################################
	
	# Sets the initial height and width.
	# Will be made with color red.
	addi 	$a0, $0, WIDTH    # a0 = X = WIDTH/2
	sra 	$a0, $a0, 1
	addi 	$a1, $0, HEIGHT   # a1 = Y = HEIGHT/2
	sra 	$a1, $a1, 1
	addi 	$a2, $0, RED  	  # a2 = red (ox00RRGGBB)
	
	# Goes to the point to place the first coordinates to draw game board.
	# Left 13 pixels.
	addi 	$a0, $a0, -13
	addi 	$a1, $a1, -25
	
	# The count that represents the first player is loaded.
	li 	$t9, 1
	
	# jump to displayBoard
	j 	displayBoard
	
#################################
# Will display the game board.
#################################			
displayBoard:

	# Will jump to draw the vertical side of the board
	j 	drawVertical

#################################
# Will display the vertical lines of the gameboard. 
#################################			
drawVertical:

	# Will print 45 pixels in the vertical direction
	beq 	$t0, 45, setConditions
	
	# Moves by 1
	addi 	$a1, $a1, 1
	addi 	$t0, $t0, 1	
	
	# Has marquee effect
	move 	$t4, $a0
	jal 	marqueeEffect
	move	$a0, $t4
	jal 	drawPixel
	
	# Will loop, and will branch to setConditions
	j 	drawVertical
	
#################################
# Sets the conditions for the second vertical line gameboard.
#################################	
setConditions:

	# Moves pixel 25 to the right 
	addi 	$a0, $a0, 25
	
	# Count is 0, and pixel is drawn
	li	$t0, 0
	jal 	drawPixel
	
	# Will jump to drawVertical2
	j 	drawVertical2
	
#################################
# Will display the second vertical line of the gameboard. 
#################################	
drawVertical2:	
	# Will print 44 pixels in the vertical direction
	beq 	$t0, 44, setConditionsforHorizontal
	
	# Moves down by 1
	addi 	$a1, $a1, -1
	addi 	$t0, $t0, 1
	
	# Has marquee effect
	move 	$t4, $a0
	jal 	marqueeEffect
	move	$a0, $t4
			
	jal 	drawPixel
	
	# Will loop, and will branch to setConditionsforHorizontal
	j 	drawVertical2
	
#################################
# Sets the conditions for the horizontal line gameboard.
#################################				
setConditionsforHorizontal:
	# Moves the pixel position to the top right position
	# up 15, right 13
	addi 	$a1, $a1, 15
	addi	$a0, $a0, 13
	li	$t0, 0
	jal 	drawPixel
	
	# Will jump to drawHorizontal
	j 	drawHorizontal	
	
#################################
# Draws the horizontal line gameboard.
#################################			
drawHorizontal: 
	# Will print 52 pixels in the horizontal direction
	beq 	$t0, 52, setConditionsforHorizontal2
	
	# Moves left by 1
	addi 	$a0, $a0, -1
	addi 	$t0, $t0, 1
	
	# Has marquee effect
	move 	$t4, $a0
	jal 	marqueeEffect
	move	$a0, $t4	
	jal 	drawPixel
	
	# Will loop, and will branch to setConditionsforHorizontal2
	j 	drawHorizontal	
	
#################################
# Sets the conditions for the second horizontal line gameboard.
#################################	
setConditionsforHorizontal2:
	# Moves the pixel position down by 15
	addi 	$a1, $a1, 15
	li	$t0, 0
	jal 	drawPixel
	j 	drawHorizontal2
	
#################################
# Draws the second horizontal line gameboard.
#################################	
drawHorizontal2:
	# Will print 52 pixels in the horizontal direction 
	beq 	$t0, 52, drawBorder
	
	# Moves right by 1
	addi 	$a0, $a0, 1
	addi 	$t0, $t0, 1
	
	# Has marquee effect
	move 	$t4, $a0
	jal 	marqueeEffect
	move	$a0, $t4	
	
	jal 	drawPixel
	j 	drawHorizontal2

#################################
# Sets the draw border conditions. 
#################################		
drawBorder:
	# The initial conditions for the border are set
	li 	$t7, 0 
	
	# Moves the pixel by 3 to the right
	addi 	$a0, $a0, 1
	addi 	$a0, $a0, 1
	addi 	$a0, $a0, 1
	jal 	drawPixel
	j 	drawRightBorder
	
#################################
# Draws the right side border. 
#################################	
drawRightBorder:
	# Will print 9 pixels in this direction 
	# Will go to setBottomBorder once done
	beq 	$t7, 9, setBottomBorder	
	
	# Moves up by 1
	addi 	$a1, $a1, 1
	
	# Marquee effect
	move 	$t4, $a0
	jal 	marqueeEffect
	move	$a0, $t4
	
	# Black Pixel
	li 	$a2, 0
	jal 	drawPixel
	
	# Red Colored pixel
	addi 	$a1, $a1, 1
	addi 	$a2, $0, RED
	jal 	drawPixel
	
	# Marquee effect
	move 	$t4, $a0
	jal 	marqueeEffect
	move	$a0, $t4
	
	addi 	$t7, $t7, 1
	
	# Will loop and then will branch to setBottomBorder
	j 	drawRightBorder
	
#################################
# Sets the conditions for the bottom side of the border. 
#################################	
setBottomBorder:
	# Sets to 0
	li 	$t7, 0
	
	# Jump to drawBottomBorder
	j 	drawBottomBorder
	
#################################
# Draws the bottom border. 
#################################	
drawBottomBorder:
	# Draws the bottom border animation, 29 pixels
	beq 	$t7, 29, setLeftBorder	
	addi 	$a0, $a0, -1
	
	# Marquee effect
	move 	$t4, $a0
	jal 	marqueeEffect
	move	$a0, $t4
	
	# The black pixel is drawn
	li 	$a2, 0
	jal 	drawPixel
	
	# The Red pixel is drawn
	addi 	$a0, $a0, -1
	addi 	$a2, $0, RED
	jal 	drawPixel
	
	# Marquee effect
	move 	$t4, $a0
	jal 	marqueeEffect
	move	$a0, $t4
	
	addi 	$t7, $t7, 1
	
	# Will loop and then branch to setLeftBorder
	j 	drawBottomBorder
	
#################################
# The conditions of the left side of the border is set. 
#################################	
setLeftBorder:
	li 	$t7, 0
	
	# jump to drawLeftBorder
	j 	drawLeftBorder
	
#################################
# The left side of the border is drawn. 
#################################	
drawLeftBorder:

	# Will loop 26 times
	beq 	$t7, 26, setTopBorder	
	addi 	$a1, $a1, -1
	
	# Marquee effect
	move 	$t4, $a0
	jal 	marqueeEffect
	move	$a0, $t4
	
	# Will draw a black pixel
	li 	$a2, 0
	jal 	drawPixel
	
	# Will draw a red pixel
	addi 	$a1, $a1, -1
	addi 	$a2, $0, RED
	jal 	drawPixel
	
	# Marquee effect
	move 	$t4, $a0
	jal 	marqueeEffect
	move	$a0, $t4
	
	addi 	$t7, $t7, 1
	
	# Will loop and the branch to setTopBorder
	j 	drawLeftBorder
	
#################################
# The conditions of the top side of the border is set. 
#################################	
setTopBorder:
	li 	$t7, 0
	
	# jump to drawTopBorder
	j 	drawTopBorder
	
#################################
# Will draw the top side of the border. 
#################################	
drawTopBorder:

	# Will loop 29 times
	beq 	$t7, 29, setFinishBorder	
	addi 	$a0, $a0, 1
	
	# Marquee effect
	move 	$t4, $a0
	jal 	marqueeEffect
	move	$a0, $t4
	
	# Draw black pixel
	li 	$a2, 0
	jal 	drawPixel
	
	# Draw red pixel
	addi 	$a0, $a0, 1
	addi 	$a2, $0, RED
	jal 	drawPixel
	
	# Marquee effect
	move 	$t4, $a0
	jal 	marqueeEffect
	move	$a0, $t4
	
	addi 	$t7, $t7, 1
	
	# Loop and the branch to setFinishBorder
	j 	drawTopBorder
	
#################################
# Will set the conditions for the remaining portions of 
# the border, to draw the rest. 
#################################	
setFinishBorder:
	li	$t7, 0
	
	# jump to drawFinishBorder
	j 	drawFinishBorder
	
#################################
# Will finish the remaining portions of the border. 
#################################	
drawFinishBorder:

	# Will loop 16 times 
	beq 	$t7, 16, setToEndOfBoard	
	addi 	$a1, $a1, 1
	
	# Marquee effect
	move 	$t4, $a0
	jal 	marqueeEffect
	move	$a0, $t4
	
	# Draw black pixel
	li 	$a2, 0
	jal 	drawPixel
	
	# Draw red pixel
	addi 	$a1, $a1, 1
	addi 	$a2, $0, RED
	jal 	drawPixel
	
	# Marquee effect
	move 	$t4, $a0
	jal 	marqueeEffect
	move	$a0, $t4
	
	addi 	$t7, $t7, 1
	
	# Loop and then branch to setToEndOfBoard
	j 	drawFinishBorder
	
#################################
# The end of board conditions is set, and will jump to set the
# conditions of the program logo. 
#################################	
setToEndOfBoard:

	# Sets the conditions for the title logo
	addi 	$a1, $a1, 2
	addi 	$a0, $a0, -3
	
	# jump to titleOfGameLogo
	j 	titleOfGameLogo
	
#################################
# The program logo conditions are set. 
#################################	
titleOfGameLogo:
	addi 	$a0, $0, WIDTH    # a0 = X = WIDTH/2
	sra 	$a0, $a0, 1
	addi 	$a1, $0, HEIGHT   # a1 = Y = HEIGHT/2
	sra 	$a1, $a1, 1
	addi 	$a2, $0, RED  	  # a2 = red (ox00RRGGBB)
	addi 	$a0, $a0, -10
	addi 	$a1, $a1, 26
	jal	drawPixel
	
	# jump to firstT
	j 	firstT

#################################
# The first T of the program logo is printed. 
#################################		
firstT:	

	# right by 1, and draw pixel
	addi	$a0, $a0, 1
	jal	drawPixel
	
	# Marquee effect
	move 	$t4, $a0
	jal 	marqueeEffect
	move	$a0, $t4
	
	# right by 1, and draw pixel
	addi 	$a0, $a0, 1
	jal	drawPixel
	
	# Marquee effect
	move 	$t4, $a0
	jal 	marqueeEffect
	move	$a0, $t4
	
	# right by 1, and draw pixel
	addi 	$a0, $a0, 1
	jal	drawPixel
	
	# Marquee effect
	move 	$t4, $a0
	jal 	marqueeEffect
	move	$a0, $t4
	
	# right by 1, and draw pixel
	addi 	$a0, $a0, 1
	jal	drawPixel
	
	# Marquee effect
	move 	$t4, $a0
	jal 	marqueeEffect
	move	$a0, $t4
	
	# left by 2, and down by 1, and draw pixel
	addi 	$a0, $a0, -2
	addi 	$a1, $a1, 1
	jal	drawPixel
	
	# Marquee effect
	move 	$t4, $a0
	jal 	marqueeEffect
	move	$a0, $t4
	
	# down by 2 and draw pixel
	addi 	$a1, $a1, 1
	jal	drawPixel
	addi 	$a1, $a1, 1
	jal	drawPixel
	
	# Marquee effect
	move 	$t4, $a0
	jal 	marqueeEffect
	move	$a0, $t4
	
	# down by 1 and draw pixel
	addi 	$a1, $a1, 1
	jal	drawPixel
	
	# Marquee effect
	move 	$t4, $a0
	jal 	marqueeEffect
	move	$a0, $t4
	
	# jump to setSecondT
	j 	setSecondT
	
#################################
# The second T of the program logo is set. 
#################################	
setSecondT:

	# initial positions are set for the secondT
	addi 	$a1, $a1, -2
	addi 	$a0, $a0, 4
	jal 	drawPixel
	
	# Marquee effect
	move 	$t4, $a0
	jal 	marqueeEffect
	move	$a0, $t4
	
	# right by 1, draw pixel
	addi 	$a0, $a0, 1
	jal 	drawPixel
	
	# Marquee effect
	move 	$t4, $a0
	jal 	marqueeEffect
	move	$a0, $t4
	
	# left by 3, up by 2, right by 5, draw pixel
	addi 	$a0, $a0, -3
	addi 	$a1, $a1, -2
	addi 	$a0, $a0, 5
	jal 	drawPixel
	
	# Marquee effect
	move 	$t4, $a0
	jal 	marqueeEffect
	move	$a0, $t4
	
	# jump to secondT
	j 	secondT
	
#################################
# The second T of the program logo is printed. 
#################################	
secondT:

	# right by 1, draw pixel 
	addi	$a0, $a0, 1
	jal	drawPixel
	
	# Marquee effect
	move 	$t4, $a0
	jal 	marqueeEffect
	move	$a0, $t4
	
	# right by 1, draw pixel 
	addi 	$a0, $a0, 1
	jal	drawPixel
	
	# Marquee effect
	move 	$t4, $a0
	jal 	marqueeEffect
	move	$a0, $t4
	
	# right by 1, draw pixel 
	addi 	$a0, $a0, 1
	jal	drawPixel
	
	# Marquee effect
	move 	$t4, $a0
	jal 	marqueeEffect
	move	$a0, $t4
	
	# right by 1, draw pixel 
	addi 	$a0, $a0, 1
	jal	drawPixel
	
	# Marquee effect
	move 	$t4, $a0
	jal 	marqueeEffect
	move	$a0, $t4
	
	# left by 2, up by 1, draw pixel 
	addi 	$a0, $a0, -2
	addi 	$a1, $a1, 1
	jal	drawPixel
	
	# Marquee effect
	move 	$t4, $a0
	jal 	marqueeEffect
	move	$a0, $t4
	
	# up by 1, draw pixel 
	addi 	$a1, $a1, 1
	jal	drawPixel
	
	# Marquee effect
	move 	$t4, $a0
	jal 	marqueeEffect
	move	$a0, $t4
	
	# up by 1, draw pixel 
	addi 	$a1, $a1, 1
	jal	drawPixel
	
	# up by 1, draw pixel 
	addi 	$a1, $a1, 1
	jal	drawPixel
	
	# Marquee effect
	move 	$t4, $a0
	jal 	marqueeEffect
	move	$a0, $t4
	
	# jump to setThirdT
	j 	setThirdT
	
#################################
# The conditions of the third T of the program logo is set. 
#################################	
setThirdT:

	# Initial position is set
	addi 	$a1, $a1, -2
	addi 	$a0, $a0, 4
	jal 	drawPixel
	
	# right by 1, draw pixel
	addi 	$a0, $a0, 1
	jal 	drawPixel
	
	# left by 3, up by 2, right by 5, draw pixel
	addi 	$a0, $a0, -3
	addi 	$a1, $a1, -2
	addi 	$a0, $a0, 5
	jal 	drawPixel
	
	# jump to thirdT
	j 	thirdT
	
#################################
# The third T of the program logo is printed. 
#################################	
thirdT:

	# right by 1, draw pixel
	addi	$a0, $a0, 1
	jal	drawPixel
	
	# Marquee effect
	move 	$t4, $a0
	jal 	marqueeEffect
	move	$a0, $t4
	
	# right by 1, draw pixel
	addi 	$a0, $a0, 1
	jal	drawPixel
	
	# Marquee effect
	move 	$t4, $a0
	jal 	marqueeEffect
	move	$a0, $t4
	
	# right by 1, draw pixel
	addi 	$a0, $a0, 1
	jal	drawPixel
	
	# Marquee effect
	move 	$t4, $a0
	jal 	marqueeEffect
	move	$a0, $t4
	
	# right by 1, draw pixel
	addi 	$a0, $a0, 1
	jal	drawPixel
	
	# Marquee effect
	move 	$t4, $a0
	jal 	marqueeEffect
	move	$a0, $t4
	
	# left  by 2, down 1, draw pixel
	addi 	$a0, $a0, -2
	addi 	$a1, $a1, 1
	jal	drawPixel
	
	# Marquee effect
	move 	$t4, $a0
	jal 	marqueeEffect
	move	$a0, $t4
	
	# down 1, draw pixel
	addi 	$a1, $a1, 1
	jal	drawPixel
	
	# Marquee effect
	move 	$t4, $a0
	jal 	marqueeEffect
	move	$a0, $t4
	
	# down 1, draw pixel
	addi 	$a1, $a1, 1
	jal	drawPixel
	
	# Marquee effect
	move 	$t4, $a0
	jal 	marqueeEffect
	move	$a0, $t4
	
	# down 1, draw pixel
	addi 	$a1, $a1, 1
	jal	drawPixel
	
	# jump to player1CanGoInitialMessge
	j 	player1CanGoInitialMessge
	
#################################
# The very first player 1 message is printed to the console. 
#################################	
player1CanGoInitialMessge: 

	# Prints the player 1 message
	li 	$v0, 4
	la	$a0, player1Message
	syscall
	
	# Increments the player count by 1
	addi	$t9, $t9, 1
	
	# jumps to displayPickBoxMessage
	j 	displayPickBoxMessage	
	
#################################
# This is the big loop section. 
# Will always loop back to this section to get the next inptu for both players. 
#################################																																											
loop:
	lw  	$t5, 0xffff0000  #t1 holds if input available
    	beq 	$t5, 0, loop     #If no input, keep displaying
	lw 	$s1, 0xffff0004
	beq	$s1, 32, displayExitMessage  # input space
	beq	$s1, 49, box1 	# input 1
	beq	$s1, 50, box2 	# input 2
	beq	$s1, 51, box3 	# input 3
	beq 	$s1, 52, box4	# input 4
	beq 	$s1, 53, box5	# input 5
	beq 	$s1, 54, box6 	# input 6
	beq 	$s1, 55, box7 	# input 7
	beq 	$s1, 56, box8 	# input 8
	beq 	$s1, 57, box9	# input 9
	beq	$s1, 110, colorMaroon # input n
	beq	$s1, 105, colorGray # input i
	beq 	$s1, 117, colorPurple # input u
	beq 	$s1, 111, colorOrange # input o
	beq 	$s1, 114, colorRed # input r
	beq 	$s1, 109, colorMagenta # input m
	beq 	$s1, 103, colorGreen # input g
	beq 	$s1, 98, colorBlue # input b
	beq 	$s1, 119, colorWhite # input w
	beq 	$s1, 121, colorYellow # input y
	beq 	$s1, 99, colorCyan # input c
	beq 	$s1, 112, settingPlus # input p  # drawPlusShape  # Will draw a plus sign shape
	beq 	$s1, 115, settingMinus # input s   # Will draw a minus sign shape
	beq 	$s1, 113, drawBoxShape # input q
	beq 	$s1, 120, drawXShapeLeftDiagonal # input x
	beq 	$s1, 102, setSmileyFaceTop # input f
	
	# Will loop back
	j	loop	
	
#################################
# The initial conditions for the plus sign shape is set. 
#################################	
settingPlus:
	li 	$t8, 0
	
	# Will move to temp. registers
	move 	$t6, $a0
	move	$t3, $a1
	move	$t2, $a2
	move	$t1, $a3
	
	# jal call to soundForPlusShape
	jal 	soundForPlusShape
	
	# Will move back to original registers
	move 	$a0, $t6
	move	$a1, $t3
	move	$a2, $t2
	move	$a3, $t1
	
	# jump to drawPlusShape
	j 	drawPlusShape
	
#################################
# The unique sound for the plus sign shape is set. 
#################################	
soundForPlusShape:

	# These registers are for the volume, the sound effect, pitch, and instrument
	li 	$v0, 31
	la	$a0, 71
	la	$a1, 1000
	la	$a2, 63
	la	$a3, 100
	syscall
	
	# Will return back to after the jal call
	jr	$ra
	
#################################
# The plus sign shape is drawn. 
#################################																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																	
drawPlusShape:

	# Will loop 11 times
	beq 	$t8, 11, settingPlusSecond
	
	# Will move down by 1
	addi 	$a1, $a1, 1
	jal 	drawPixel
	
	# Marquee effect
	move 	$t4, $a0
	jal 	marqueeEffect
	move	$a0, $t4
	
	# Increment counter
	addi 	$t8, $t8, 1
	
	# loop and then branch to settingPlusSecond
	j 	drawPlusShape
	
#################################
# The conditions for the second line of the plus shape is set. 
#################################	
settingPlusSecond:

	# initial conditions for setting the second line of the plus sign shape	
	addi 	$a1, $a1, -5
	addi 	$a0, $a0, -5
	jal 	drawPixel
	
	# Marquee effect
	move 	$t4, $a0
	jal 	marqueeEffect
	move	$a0, $t4
	
	# resetting $t8, and jump to drawPlusShapeSecond
	li 	$t8, 0
	j 	drawPlusShapeSecond
	
#################################
# The second line of the plus shape is drawn. 
#################################	
drawPlusShapeSecond:

	# Will loop 9 times, then branch to displayEndOfTurnToUser
	beq 	$t8, 9, displayEndOfTurnToUser	
	
	# right by 1
	addi 	$a0, $a0, 1
	jal 	drawPixel
	
	# Marquee effect
	move 	$t4, $a0
	jal 	marqueeEffect
	move	$a0, $t4
	
	# Increment $t8, loop counter
	addi 	$t8, $t8, 1
	
	# loop back to drawPlusShapeSecond
	j 	drawPlusShapeSecond
	
#################################
# The counters to display the correct player can go message will be done here. 
# Will get inceremented after the shape is selected. 
#################################	
displayEndOfTurnToUser:

	# Depending on which user is playing, will branch to display the correct message
	beq	$t9, 10, displayExitMessage
	beq	$t9, 3, displayPlayer1Message
	beq	$t9, 5, displayPlayer1Message
	beq	$t9, 7, displayPlayer1Message
	beq	$t9, 9, displayPlayer1Message
	beq	$t9, 2, displayPlayer2Message
	beq	$t9, 4, displayPlayer2Message
	beq	$t9, 6, displayPlayer2Message
	beq	$t9, 8, displayPlayer2Message 
	
#################################
# The "player 1 can go" message is printed to the console. 
#################################	
displayPlayer1Message:

	# incerment player counter by 1
	addi 	$t9, $t9, 1
	
	li 	$v0, 4
	la	$a0, player1Message
	syscall
	
	# jump to displayPickBoxMessage
	j 	displayPickBoxMessage
	
#################################
# The "player 2 can go" message is printed to the console. 
#################################		
displayPlayer2Message:

	# incerment player counter by 1
	addi 	$t9, $t9, 1
	
	li 	$v0, 4
	la	$a0, player2Message
	syscall
	
	# jump to displayPickBoxMessage
	j 	displayPickBoxMessage
	
#################################
# The pick a box message is printed to the console. 
# Will print after the player message is printed to the console. 
#################################				
displayPickBoxMessage:
	li 	$v0, 4
	la	$a0, pickBoxMessage
	syscall	
	
	# jump to loop once displayed to console
	j 	loop	

#################################
# The initial conditions for the minus shape is set. 
#################################							
settingMinus:

	# Intial conditions are set for the minus shape
	addi 	$a1, $a1, 3
	addi 	$a0, $a0, 1
	addi 	$a1, $a1, 1
	addi 	$a0, $a0, 1
	addi 	$a1, $a1, 1
	addi 	$a0, $a0, -4
	jal 	drawPixel
	
	# Marquee effect
	move 	$t4, $a0
	jal 	marqueeEffect
	move	$a0, $t4
	
	# Moves to temp. regsiters
	move 	$t6, $a0
	move	$t3, $a1
	move	$t2, $a2
	move	$t1, $a3
	
	# jal call to soundForMinusShape
	jal 	soundForMinusShape
	
	# Move back to original registers
	move 	$a0, $t6
	move	$a1, $t3
	move	$a2, $t2
	move	$a3, $t1
	
	# jump to drawMinusShape
	j 	drawMinusShape
	
#################################
# The unique sound for the minus shape is set. 
#################################		
soundForMinusShape:

	# These registers are for the volume, the sound effect, pitch, and instrument
	li 	$v0, 31
	la	$a0, 65
	la	$a1, 1000
	la	$a2, 24
	la	$a3, 100
	syscall
	
	# Will return back to after the jal call
	jr	$ra	

#################################
# The minus shape is drawn. 
#################################		
drawMinusShape:	

	# right by 1
	addi 	$a0, $a0, 1
	jal 	drawPixel
	
	# Marquee effect
	move 	$t4, $a0
	jal 	marqueeEffect
	move	$a0, $t4
	
	# right by 1
	addi 	$a0, $a0, 1
	jal 	drawPixel
	
	# Marquee effect
	move 	$t4, $a0
	jal 	marqueeEffect
	move	$a0, $t4
	
	# right by 1
	addi 	$a0, $a0, 1
	jal 	drawPixel
	
	# Marquee effect
	move 	$t4, $a0
	jal 	marqueeEffect
	move	$a0, $t4
	
	# right by 1
	addi 	$a0, $a0, 1
	jal 	drawPixel
	
	# jump to displayEndOfTurnToUser
	j 	displayEndOfTurnToUser
	
#################################
# The left diagonal of the x shape is drawn. 
#################################		
drawXShapeLeftDiagonal:

	# Sets the conditiosn for the left diagonal of X-Shape
	addi 	$a0, $a0, -2
	addi 	$a1, $a1, 3
	addi 	$a0, $a0, 1
	addi 	$a1, $a1, 1
	
	# Marquee effect
	move 	$t4, $a0
	jal 	marqueeEffect
	move	$a0, $t4
	jal 	drawPixel
	
	# Right by 1, down by 1
	addi 	$a0, $a0, 1
	addi 	$a1, $a1, 1
	
	# Marquee effect
	move 	$t4, $a0
	jal 	marqueeEffect
	move	$a0, $t4
	jal 	drawPixel
	
	# Right by 1, down by 1
	addi 	$a0, $a0, 1
	addi 	$a1, $a1, 1
	
	# Marquee effect
	move 	$t4, $a0
	jal 	marqueeEffect
	move	$a0, $t4
	jal 	drawPixel
	
	# Right by 1, down by 1
	addi 	$a0, $a0, 1
	addi 	$a1, $a1, 1
	
	# Marquee effect
	move 	$t4, $a0
	jal 	marqueeEffect
	move	$a0, $t4
	jal 	drawPixel
	
	# Right by 1, down by 1
	addi 	$a0, $a0, 1
	addi 	$a1, $a1, 1
	
	# Marquee effect
	move 	$t4, $a0
	jal 	marqueeEffect
	move	$a0, $t4
	jal 	drawPixel
	
	# jump to setXShapeAudio
	j 	setXShapeAudio
	
#################################
# The audio for the entire x shape is set. 
#################################		
setXShapeAudio:

	# Will move registers to temp. registers
	move 	$t6, $a0
	move	$t3, $a1
	move	$t2, $a2
	move	$t1, $a3
	
	# jal call to soundForXShape
	jal 	soundForXShape
	
	# Move back to original registers
	move 	$a0, $t6
	move	$a1, $t3
	move	$a2, $t2
	move	$a3, $t1
	
	# jump to drawXShapeRightDiagonal
	j 	drawXShapeRightDiagonal	
	
#################################
# The unique sound for the x shape is done. 
#################################		
soundForXShape:

	# These registers are for the volume, the sound effect, pitch, and instrument
	li 	$v0, 31
	la	$a0, 69
	la	$a1, 1000
	la	$a2, 10
	la	$a3, 100
	syscall
	
	# Will return back to after the jal call
	jr	$ra	
	
#################################
# The right diagonal of the x-shape is drawn. 
#################################	
drawXShapeRightDiagonal:

	# Sets the inital conditions 
	addi 	$a1, $a1, -5
	addi 	$a0, $a0, -1
	addi 	$a1, $a1, 1
	
	# Marquee effect
	move 	$t4, $a0
	jal 	marqueeEffect
	move	$a0, $t4
	jal 	drawPixel
	
	# Left by 1, up by 1
	addi 	$a0, $a0, -1
	addi 	$a1, $a1, 1
	
	# Marquee effect
	move 	$t4, $a0
	jal 	marqueeEffect
	move	$a0, $t4
	jal 	drawPixel
	
	# Left by 1, up by 1
	addi 	$a0, $a0, -1
	addi 	$a1, $a1, 1
	
	# Marquee effect
	move 	$t4, $a0
	jal 	marqueeEffect
	move	$a0, $t4
	jal 	drawPixel
	
	# Left by 1, up by 1
	addi 	$a0, $a0, -1
	addi 	$a1, $a1, 1
	
	# Marquee effect
	move 	$t4, $a0
	jal 	marqueeEffect
	move	$a0, $t4
	jal 	drawPixel
	
	# Left by 1, up by 1
	addi 	$a0, $a0, -1
	addi 	$a1, $a1, 1
	
	# Marquee effect
	move 	$t4, $a0
	jal 	marqueeEffect
	move	$a0, $t4
	jal 	drawPixel
	
	# Will jump to displayEndOfTurnToUser
	j 	displayEndOfTurnToUser
	
#################################
# The conditions for drawing the box shape at the middle of each box is set. 
#################################	
drawBoxShape:

	# Sets the conditions for the box shape
	addi 	$a0, $a0, -4
	addi 	$a1, $a1, 2
	
	# jump to setBoxTop
	j 	setBoxTop
	
#################################
# The condition for the top side of the box shape is set.   
#################################	
setBoxTop:
	li 	$t0, 0		  # count for the 7 colors in each side of box
	
	# Will move registers to temp. registers
	move 	$t6, $a0
	move	$t3, $a1
	move	$t2, $a2
	move	$t1, $a3
	
	# jal call to soundForBoxShape
	jal 	soundForBoxShape
	
	# Will move back to original registers
	move 	$a0, $t6
	move	$a1, $t3
	move	$a2, $t2
	move	$a3, $t1
	
	# jump to drawBoxTop
	j 	drawBoxTop
	
#################################
# The unique sound effect for the box shape will occur.  
#################################	
soundForBoxShape:
	
	# These registers are for the volume, the sound effect, pitch, and instrument
	li 	$v0, 31
	la	$a0, 64
	la	$a1, 1000
	la	$a2, 126
	la	$a3, 100
	syscall
	
	# Will return back to after the jal call
	jr	$ra	
	
#################################
# The top side of the box shape is drawn.  
#################################	
drawBoxTop:

	# Will loop 7 times
	beq 	$t0, 7, setBoxRight
	jal 	drawPixel
	
	# Marquee effect
	move 	$t4, $a0
	jal 	marqueeEffect
	move	$a0, $t4
	
	# Will move down by 1, and increment by 1
	addi 	$a0, $a0, 1
	addi 	$t0, $t0, 1
	
	# loop and then branch to setBoxRight
	j 	drawBoxTop
	
#################################
# The right side of the box shape is set.  
#################################	
setBoxRight:			
	li 	$t0, 0		  # count for the 7 colors in each side of box
	
	# jump to drawBoxRight
	j 	drawBoxRight
	
#################################
# The right side of the box shape is drawn.  
#################################	
drawBoxRight:

	# Will loop 7 times 	
	beq 	$t0, 7, setBoxBottom
	jal 	drawPixel
	
	# Marquee effect
	move 	$t4, $a0
	jal 	marqueeEffect
	move	$a0, $t4
	
	# Will move down by 1, and increment by 1
	addi 	$a1, $a1, 1
	addi 	$t0, $t0, 1
	
	# loop and then branch to setBoxBottom
	j 	drawBoxRight
	
#################################
# The bottom side of the box shape is set.  
#################################	
setBoxBottom:
	li 	$t0, 0		  # count for the 7 colors in each side of box
	
	# jump to drawBoxBottom
	j 	drawBoxBottom
	
#################################
# The bottom side of the box shape is drawn.  
#################################	
drawBoxBottom:

	# Will loop 7 times
	beq 	$t0, 7, setBoxLeft
	jal 	drawPixel
	
	# Marquee effect
	move 	$t4, $a0
	jal 	marqueeEffect
	move	$a0, $t4
	
	# Will move left by 1, and increment by 1
	addi 	$a0, $a0, -1
	addi 	$t0, $t0, 1
	
	# Loop and then branch to setBoxLeft
	j 	drawBoxBottom
	
#################################
# The conditions of the left side of the box shape is set.  
#################################			
setBoxLeft:
	li 	$t0, 0		  # count for the 7 colors in each side of box
	
	# Will jump to drawBoxLeft
	j 	drawBoxLeft
	
#################################
# The left side of the box shape is drawn.  
#################################	
drawBoxLeft:

	# Will loop 7 times
	beq 	$t0, 7, displayEndOfTurnToUser
	jal 	drawPixel
	
	# Marqee effect
	move 	$t4, $a0
	jal 	marqueeEffect
	move	$a0, $t4
	
	# Will increment by 1 and move up by 1
	addi 	$a1, $a1, -1
	addi 	$t0, $t0, 1
	
	# loop and will branch to displayEndOfTurnToUser
	j 	drawBoxLeft
	
#################################
# Sets the conditions for the top side of the smiley face. 
#################################	
setSmileyFaceTop:
	li 	$t0, 0
	addi 	$a0, $a0, -3
	addi 	$a1, $a1, 1
	
	# Move to temporray registers before making jal call
	move 	$t6, $a0
	move	$t3, $a1
	move	$t2, $a2
	move	$t1, $a3
	
	# jal call to soundForSmileyFaceShape
	jal 	soundForSmileyFaceShape
	
	# Move back to original registers
	move 	$a0, $t6
	move	$a1, $t3
	move	$a2, $t2
	move	$a3, $t1
	
	# jump to drawSmileyFaceTop
	j 	drawSmileyFaceTop
	
#################################
# The unique sound effect for the smiley face will occur. 
#################################	
soundForSmileyFaceShape:
	# These registers are for the volume, the sound effect, pitch, and instrument
	li 	$v0, 31
	la	$a0, 65
	la	$a1, 1000
	la	$a2, 121
	la	$a3, 100
	syscall
	
	# Will return back to after the jal call
	jr	$ra
	
#################################
# Will draw the top side of the smiley face. 
#################################			
drawSmileyFaceTop:
	
	# Will loop 7 times 
	beq	$t0, 7, drawSmileFaceTopRight
	jal 	drawPixel
	
	# Marquee effect
	move 	$t4, $a0
	jal 	marqueeEffect
	move	$a0, $t4
	
	addi 	$a0, $a0, 1
	addi 	$t0, $t0, 1
	
	# Will loop and then branch to drawSmileFaceTopRight
	j 	drawSmileyFaceTop
	
#################################
# Will draw the top right side of the smiley face. 
#################################	
drawSmileFaceTopRight:
	addi	$a1, $a1, 1
	jal 	drawPixel
	
	# Marquee effect
	move 	$t4, $a0
	jal 	marqueeEffect
	move	$a0, $t4
	
	# Move right by 1, and draw pixel
	addi	$a0, $a0, 1
	jal 	drawPixel
	
	# Marquee effect
	move 	$t4, $a0
	jal 	marqueeEffect
	move	$a0, $t4
	
	# Move down by 1, and draw pixel
	addi	$a1, $a1, 1
	jal 	drawPixel
	
	# Marquee effect
	move 	$t4, $a0
	jal 	marqueeEffect
	move	$a0, $t4
	
	# Move down by 1, and draw pixel
	addi	$a1, $a1, 1
	jal 	drawPixel
	
	# Marquee effect
	move 	$t4, $a0
	jal 	marqueeEffect
	move	$a0, $t4
	
	# Move right by 1, and draw pixel
	addi	$a0, $a0, 1
	jal 	drawPixel
	
	# Marquee effect
	move 	$t4, $a0
	jal 	marqueeEffect
	move	$a0, $t4
	
	# jump to setSmileyFaceRight
	j 	setSmileyFaceRight
	
#################################
# Will set the right side of the smiley face. 
#################################	
setSmileyFaceRight:
	li 	$t0, 0
	
	# Jump to drawSmileyFaceRight
	j 	drawSmileyFaceRight
	
#################################
# Will draw the right side of the smiley face. 
#################################	
drawSmileyFaceRight:
	beq	$t0, 7, drawSmileFaceBottomRight
	jal 	drawPixel
	
	# Marquee effect 
	move 	$t4, $a0
	jal 	marqueeEffect
	move	$a0, $t4
	
	# Move down by 1, and Increment by 1
	addi 	$a1, $a1, 1
	addi 	$t0, $t0, 1
	
	# Will loop and then will branch to drawSmileFaceBottomRight
	j 	drawSmileyFaceRight
	
#################################
# Will draw the bottom side of the smiley face. 
#################################	
drawSmileFaceBottomRight:
	jal 	drawPixel
	
	# Marquee effect 
	move 	$t4, $a0
	jal 	marqueeEffect
	move	$a0, $t4
	
	# Will move left by 1
	addi	$a0, $a0, -1
	jal 	drawPixel
	
	# Marquee effect 
	move 	$t4, $a0
	jal 	marqueeEffect
	move	$a0, $t4
	
	# Will move down by 1
	addi	$a1, $a1, 1
	jal 	drawPixel
	
	# Marquee effect 
	move 	$t4, $a0
	jal 	marqueeEffect
	move	$a0, $t4
	
	# Will move left by 1
	addi	$a0, $a0, -1
	jal 	drawPixel
	
	# Marquee effect 
	move 	$t4, $a0
	jal 	marqueeEffect
	move	$a0, $t4
	
	# Will move left by 1
	addi	$a0, $a0, -1
	jal 	drawPixel
	
	# Marquee effect 
	move 	$t4, $a0
	jal 	marqueeEffect
	move	$a0, $t4
	
	# Will jump to setSmileyFaceBottom
	j 	setSmileyFaceBottom
	
#################################
# Will set the bottom side of the smiley face. 
#################################	
setSmileyFaceBottom:
	li	$t0, 0
	
	# Will jump to drawSmileyFaceBottom
	j 	drawSmileyFaceBottom
	
#################################
# Will draw the bottom side of the smiley face. 
#################################			
drawSmileyFaceBottom:
	beq	$t0, 7, drawSmileFaceBottomLeft
	jal 	drawPixel
	
	# Marquee effect 
	move 	$t4, $a0
	jal 	marqueeEffect
	move	$a0, $t4
	
	addi 	$a0, $a0, -1
	addi 	$t0, $t0, 1
	
	# Will loop, and then branch to drawSmileFaceBottomLeft
	j 	drawSmileyFaceBottom
	
#################################
# Will draw the bottom left of the smiley face. 
#################################	
drawSmileFaceBottomLeft:
	jal 	drawPixel
	
	# Marquee effect 
	move 	$t4, $a0
	jal 	marqueeEffect
	move	$a0, $t4
	
	# Will move left by 1, and draw a pixel 
	addi	$a0, $a0, -1
	jal 	drawPixel
	
	# Marquee effect 
	move 	$t4, $a0
	jal 	marqueeEffect
	move	$a0, $t4
	
	# Will move up by 1, and draw a pixel 
	addi	$a1, $a1, -1
	jal 	drawPixel
	
	# Marquee effect 
	move 	$t4, $a0
	jal 	marqueeEffect
	move	$a0, $t4
	
	# Will move left by 1, and draw a pixel 
	addi	$a0, $a0, -1
	jal 	drawPixel
	
	# Marquee effect 
	move 	$t4, $a0
	jal 	marqueeEffect
	move	$a0, $t4
	
	# Will jump to setSmileyFaceLeft
	j 	setSmileyFaceLeft
	
#################################
# Sets the initial conditions of the left side of the smiley face. 
#################################	
setSmileyFaceLeft:
	li 	$t0, 0
	
	# Will jump to drawSmileyFaceLeft
	j 	drawSmileyFaceLeft
	
#################################
# Will draw the left side of the smiley face. 
#################################			
drawSmileyFaceLeft:
	beq	$t0, 8, drawSmileyFaceTopLeft
	jal 	drawPixel
	
	# Marquee effect 
	move 	$t4, $a0
	jal 	marqueeEffect
	move	$a0, $t4
	
	addi 	$a1, $a1, -1
	addi 	$t0, $t0, 1
	
	# Will jump to drawSmileyFaceLeft, and branch to drawSmileyFaceTopLeft
	j 	drawSmileyFaceLeft
	
#################################
# Will draw the top left side of the smiley face. 
#################################				
drawSmileyFaceTopLeft:

	# Will move down by 1, and draw a pixel 
	addi	$a1, $a1, 1
	jal 	drawPixel
	
	# Marquee effect
	move 	$t4, $a0
	jal 	marqueeEffect
	move	$a0, $t4
	
	# Will move right by 1, and draw a pixel 
	addi	$a0, $a0, 1
	jal 	drawPixel
	
	# Marquee effect
	move 	$t4, $a0
	jal 	marqueeEffect
	move	$a0, $t4
	
	# Will move up by 1, and draw a pixel 
	addi 	$a1, $a1, -1
	jal 	drawPixel
	
	# Marquee effect
	move 	$t4, $a0
	jal 	marqueeEffect
	move	$a0, $t4
	
	# Will move up by 1, and draw a pixel 
	addi 	$a1, $a1, -1
	jal 	drawPixel
	
	# Marquee effect
	move 	$t4, $a0
	jal 	marqueeEffect
	move	$a0, $t4
	
	# Will move down by 1, and draw a pixel 
	addi 	$a0, $a0, 1
	jal 	drawPixel
	
	# Marquee effect
	move 	$t4, $a0
	jal 	marqueeEffect
	move	$a0, $t4
	
	# Will jump to drawEyes
	j 	drawEyes
	
#################################
# Will draw the eyes of the smile face shape. 
#################################		
drawEyes:

	# Will move right by 2 and done by 4, and draw a pixel
	addi 	$a0, $a0, 1
	addi 	$a0, $a0, 1
	addi 	$a1, $a1, 4
	jal 	drawPixel
	
	# Marquee effect
	move 	$t4, $a0
	jal 	marqueeEffect
	move	$a0, $t4
	
	# Will move right by 4, and draw a pixel
	addi 	$a0, $a0, 4
	jal 	drawPixel
	
	# Marquee effect
	move 	$t4, $a0
	jal 	marqueeEffect
	move	$a0, $t4
	
	# Will jump to drawMouth
	j 	drawMouth
	
#################################
# Will draw the mouth of the smile face shape.
#################################		
drawMouth:

	# Will go down by 3 and draw a pixel
	addi 	$a1, $a1, 3
	jal 	drawPixel
	
	# Marquee effect 
	move 	$t4, $a0
	jal 	marqueeEffect
	move	$a0, $t4
	
	# Move down by 1 and draw a pixel 
	addi 	$a1, $a1, 1
	jal 	drawPixel
	
	# Marquee effect 
	move 	$t4, $a0
	jal 	marqueeEffect
	move	$a0, $t4
	
	# Move down by 1 and draw a pixel 
	addi	$a0, $a0, -1
	jal 	drawPixel
	
	# Marquee effect 
	move 	$t4, $a0
	jal 	marqueeEffect
	move	$a0, $t4
	
	# Move down by 1 and draw a pixel 
	addi	$a0, $a0, -1
	jal 	drawPixel
	
	# Marquee effect 
	move 	$t4, $a0
	jal 	marqueeEffect
	move	$a0, $t4
	
	# Move down by 1 and draw a pixel 
	addi	$a0, $a0, -1
	jal 	drawPixel
	
	# Marquee effect 
	move 	$t4, $a0
	jal 	marqueeEffect
	move	$a0, $t4
	
	# Up by 1
	addi	$a0, $a0, -1
	jal 	drawPixel
	
	# Move down by 1 and draw a pixel 
	move 	$t4, $a0
	jal 	marqueeEffect
	move	$a0, $t4
	
	# draw a pixel 
	jal 	drawPixel
	
	# Marquee effect 
	move 	$t4, $a0
	jal 	marqueeEffect
	move	$a0, $t4
	
	# Move down by 1 and draw a pixel 
	addi 	$a1, $a1, -1
	jal 	drawPixel
	
	# Marquee effect 
	move 	$t4, $a0
	jal 	marqueeEffect
	move	$a0, $t4
	
	# Will jump to displayEndOfTurnToUser
	j 	displayEndOfTurnToUser	
	
#################################
# Will display to the console that a color needs to be selected, 
# and move the pixel postion to box 1's position. 
#################################																						
box1:

	# Will jal to the color message to get printed
	jal 	displayPickAColorMessage
	
	# The inital conditions are set again to (0, 0)
	addi 	$a0, $0, WIDTH    # a0 = X = WIDTH/2
	sra 	$a0, $a0, 1
	addi 	$a1, $0, HEIGHT   # a1 = Y = HEIGHT/2
	sra 	$a1, $a1, 1
	
	# Will move to box 2 position 
	addi 	$a0, $a0, -21
	addi 	$a1, $a1, -23
	
	# Will jump to loop
	j 	loop
	
#################################
# Will display to the console that a color needs to be selected, 
# and move the pixel postion to box 8's position. 
#################################		
box2:

	# Will jal to the color message to get printed
	jal 	displayPickAColorMessage
	
	# The inital conditions are set again to (0, 0)
	addi 	$a0, $0, WIDTH    # a0 = X = WIDTH/2
	sra 	$a0, $a0, 1
	addi 	$a1, $0, HEIGHT   # a1 = Y = HEIGHT/2
	sra 	$a1, $a1, 1
	
	# Will move to box 2 position 
	addi 	$a1, $a1, -24
	
	# Will jump to loop
	j 	loop
	
#################################
# Will display to the console that a color needs to be selected, 
# and move the pixel postion to box 3's position. 
#################################		
box3: 

	# Will jal to the color message to get printed
	jal 	displayPickAColorMessage
	
	# The inital conditions are set again to (0, 0)
	addi 	$a0, $0, WIDTH    # a0 = X = WIDTH/2
	sra 	$a0, $a0, 1
	addi 	$a1, $0, HEIGHT   # a1 = Y = HEIGHT/2
	sra 	$a1, $a1, 1
	
	# Will move to box 3 position 
	addi 	$a0, $a0, 21
	addi 	$a1, $a1, -24
	
	# Will jump to loop
	j 	loop
	
#################################
# Will display to the console that a color needs to be selected, 
# and move the pixel postion to box 4's position. 
#################################		
box4: 

	# Will jal to the color message to get printed
	jal 	displayPickAColorMessage
	
	# The inital conditions are set again to (0, 0)
	addi 	$a0, $0, WIDTH    # a0 = X = WIDTH/2
	sra 	$a0, $a0, 1
	addi 	$a1, $0, HEIGHT   # a1 = Y = HEIGHT/2
	sra 	$a1, $a1, 1
	
	# Will move to box 4 position 
	addi 	$a0, $a0, -21
	addi 	$a1, $a1, -8
	
	# Will jump to loop
	j 	loop
	
#################################
# Will display to the console that a color needs to be selected, 
# and move the pixel postion to box 5's position. 
#################################		
box5:

	# Will jal to the color message to get printed
	jal 	displayPickAColorMessage
	
	# The inital conditions are set again to (0, 0)
	addi 	$a0, $0, WIDTH    # a0 = X = WIDTH/2
	sra 	$a0, $a0, 1
	addi 	$a1, $0, HEIGHT   # a1 = Y = HEIGHT/2
	sra 	$a1, $a1, 1
	
	# Will move to box 5 position 
	addi 	$a1, $a1, -8
	
	# Will jump to loop
	j 	loop
	
#################################
# Will display to the console that a color needs to be selected, 
# and move the pixel postion to box 6's position. 
#################################		
box6:

	# Will jal to the color message to get printed
	jal 	displayPickAColorMessage
	
	# The inital conditions are set again to (0, 0)
	addi 	$a0, $0, WIDTH    # a0 = X = WIDTH/2
	sra 	$a0, $a0, 1
	addi 	$a1, $0, HEIGHT   # a1 = Y = HEIGHT/2
	sra 	$a1, $a1, 1
	
	# Will move to box 6 position 
	addi 	$a0, $a0, 20
	addi 	$a1, $a1, -8
	
	# Will jump to loop
	j 	loop
	
#################################
# Will display to the console that a color needs to be selected, 
# and move the pixel postion to box 7's position. 
#################################		
box7:

	# Will jal to the color message to get printed
	jal 	displayPickAColorMessage
	
	# The inital conditions are set again to (0, 0)
	addi 	$a0, $0, WIDTH    # a0 = X = WIDTH/2
	sra 	$a0, $a0, 1
	addi 	$a1, $0, HEIGHT   # a1 = Y = HEIGHT/2
	sra 	$a1, $a1, 1
	
	# Will move to box 7 position 
	addi 	$a0, $a0, -21
	addi 	$a1, $a1, 7
	
	# Will jump to loop
	j 	loop
	
#################################
# Will display to the console that a color needs to be selected, 
# and move the pixel postion to box 8's position. 
#################################		
box8:

	# Will jal to the color message to get printed
	jal 	displayPickAColorMessage
	
	# The inital conditions are set again to (0, 0)
	addi 	$a0, $0, WIDTH    # a0 = X = WIDTH/2
	sra 	$a0, $a0, 1
	addi 	$a1, $0, HEIGHT   # a1 = Y = HEIGHT/2
	sra 	$a1, $a1, 1
	
	# Will move to box 8 position 
	addi 	$a1, $a1, 8
	
	# Will jump to loop
	j 	loop
	
#################################
# Will display to the console that a color needs to be selected, 
# and move the pixel postion to box 9's position. 
#################################	
box9:

	# Will jal to the color message to get printed
	jal 	displayPickAColorMessage
	
	# The inital conditions are set again to (0, 0)
	addi 	$a0, $0, WIDTH    # a0 = X = WIDTH/2
	sra 	$a0, $a0, 1
	addi 	$a1, $0, HEIGHT   # a1 = Y = HEIGHT/2
	sra 	$a1, $a1, 1
	
	# Will move to box 9 position 
	addi 	$a0, $a0, 20
	addi 	$a1, $a1, 8
	
	# Will jump to loop
	j 	loop
	
#################################
# Will display to the console that a color needs to be selected. 
#################################	
displayPickAColorMessage:
	li 	$v0, 4
	la	$a0, pickColorMessage
	syscall
	
	# Will return back to after the jal call
	jr	$ra
	
#################################
# Will display to the console that a shape needs to be selected, and
# the color Green will be selected to draw at the user's point of choice. 
#################################										
colorGreen:

	# Will display the shape message
	move	$s6, $a0
	jal 	displayPickAShapeMessage
	move	$a0, $s6
	
	# Will display new line
	move	$s7, $a0
	jal 	newLineMessage
	move	$a0, $s7
	
	# Green is set as color
	addi 	$a2, $0, GREEN
	
	# Will jump back to loop
	j 	loop
	
#################################
# Will display to the console that a shape needs to be selected, and
# the color Yellow will be selected to draw at the user's point of choice. 
#################################		
colorYellow:

	# Will display the shape message
	move	$s6, $a0
	jal 	displayPickAShapeMessage
	move	$a0, $s6
	
	# Will display new line
	move	$s7, $a0
	jal 	newLineMessage
	move	$a0, $s7
	
	# Yellow is set as color
	addi 	$a2, $0, YELLOW
	
	# Will jump back to loop
	j 	loop
	
#################################
# Will display to the console that a shape needs to be selected, and
# the color Blue will be selected to draw at the user's point of choice. 
#################################		
colorBlue:

	# Will display the shape message
	move	$s6, $a0
	jal 	displayPickAShapeMessage
	move	$a0, $s6
	
	# Will display new line
	move	$s7, $a0
	jal 	newLineMessage
	move	$a0, $s7
	
	# Blue is set as color
	addi 	$a2, $0, BLUE
	
	# Will jump back to loop
	j 	loop
	
#################################
# Will display to the console that a shape needs to be selected, and
# the color Cyan will be selected to draw at the user's point of choice. 
#################################		
colorCyan:

	# Will display the shape message
	move	$s6, $a0
	jal 	displayPickAShapeMessage
	move	$a0, $s6
	
	# Will display new line
	move	$s7, $a0
	jal 	newLineMessage
	move	$a0, $s7
	
	# Cyan is set as color
	addi 	$a2, $0, CYAN
	
	# Will jump back to loop
	j 	loop
	
#################################
# Will display to the console that a shape needs to be selected, and
# the color White will be selected to draw at the user's point of choice. 
#################################		
colorWhite:

	# Will display the shape message 
	move	$s6, $a0
	jal 	displayPickAShapeMessage
	move	$a0, $s6
	
	# Will display new line
	move	$s7, $a0
	jal 	newLineMessage
	move	$a0, $s7
	
	# White is set as color
	addi 	$a2, $0, WHITE
	
	# Will jump back to loop
	j 	loop
	
#################################
# Will display to the console that a shape needs to be selected, and
# the color Magenta will be selected to draw at the user's point of choice. 
#################################		
colorMagenta:

	# Will display the shape message 
	move	$s6, $a0
	jal 	displayPickAShapeMessage
	move	$a0, $s6
	
	# Will display new line
	move	$s7, $a0
	jal 	newLineMessage
	move	$a0, $s7
	
	# Magenta is set as color
	addi 	$a2, $0, MAGENTA
	
	# Will jump back to loop										
	j 	loop
	
#################################
# Will display to the console that a shape needs to be selected, and
# the color Red will be selected to draw at the user's point of choice. 
#################################		
colorRed:

	# Will display the shape message 
	move	$s6, $a0
	jal 	displayPickAShapeMessage
	move	$a0, $s6
	
	# Will display new line
	move	$s7, $a0
	jal 	newLineMessage
	move	$a0, $s7
	
	# Red is set as color
	addi 	$a2, $0, RED
	
	# Will jump back to loop										
	j 	loop
	
#################################
# Will display to the console that a shape needs to be selected, and
# the color Orange will be selected to draw at the user's point of choice. 
#################################				
colorOrange:

	# Will display the shape message 
	move	$s6, $a0
	jal 	displayPickAShapeMessage
	move	$a0, $s6
	
	# Will display new line
	move	$s7, $a0
	jal 	newLineMessage
	move	$a0, $s7
	
	# Orange is set as color
	addi 	$a2, $0, ORANGE
	
	# Will jump back to loop										
	j 	loop
	
#################################
# Will display to the console that a shape needs to be selected, and
# the color Purple will be selected to draw at the user's point of choice. 
#################################		
colorPurple:

	# Will display the shape message 
	move	$s6, $a0
	jal 	displayPickAShapeMessage
	move	$a0, $s6
	
	# Will display new line
	move	$s7, $a0
	jal 	newLineMessage
	move	$a0, $s7
	
	# Purple is set as color
	addi 	$a2, $0, PURPLE	
	
	# Will jump back to loop								
	j 	loop
	
#################################
# Will display to the console that a shape needs to be selected, and
# the color Gray will be selected to draw at the user's point of choice. 
#################################				
colorGray:

	# Will display the shape message 
	move	$s6, $a0
	jal 	displayPickAShapeMessage
	move	$a0, $s6
	
	# Will display new line
	move	$s7, $a0
	jal 	newLineMessage
	move	$a0, $s7
	
	# Gray is set as color
	addi 	$a2, $0, GRAY	
	
	# Will jump back to loop								
	j 	loop
	
#################################
# Will display to the console that a shape needs to be selected, and
# the color Maroon will be selected to draw at the user's point of choice. 
#################################	
colorMaroon:

	# Will display the shape message 
	move	$s6, $a0
	jal 	displayPickAShapeMessage
	move	$a0, $s6
	
	# Will display new line
	move	$s7, $a0
	jal 	newLineMessage
	move	$a0, $s7
	
	# Maroon is set as color
	addi 	$a2, $0, MAROON	
	
	# Will jump back to loop								
	j 	loop	
	
#################################
# Will display to the console that a shape needs to be selected. 
#################################	
displayPickAShapeMessage:
	li 	$v0, 4
	la	$a0, pickShapeMessage
	syscall
	
	# Will return back to after the jal call
	jr	$ra
	
#################################
# Will print a new line after the current statement.
# Will specifically be used in the shape string syscall.
#################################			
newLineMessage:
	li 	$v0, 4
	la	$a0, newLine
	syscall
	
	# Will return back to after the jal call
	jr	$ra
	
#################################
# Will print an exit message to the console. 
# Will jump to the exit function once the statement is printed.
#################################			
displayExitMessage:
	li 	$v0, 4
	la	$a0, exitMessage
	syscall
	
	# Will jump to exit function
	j 	exit	
	
#################################
# Will exit the program. 
#################################			
exit:	
	li	$v0, 10
	syscall
	
#################################
# Will have a marquee effect at that pixel point
# with a 10 ms delay. 
#################################	
marqueeEffect: 
	li 	$v0, 32
	li 	$a0, 10
	syscall	
	
	# Will return back to after the jal call		
	jr 	$ra	
	
#################################
# Will be called by each respective function.
# Will draw the pixel at that position.
#################################	
drawPixel:
	mul	$s1, $a1, WIDTH   # y * WIDTH
	add	$s1, $s1, $a0	  # add X
	mul	$s1, $s1, 4	  # multiply by 4 to get word offset
	add	$s1, $s1, MEM	  # add to base address
	sw	$a2, 0($s1)	  # store color at memory location
	
	# Will return back to after the jal call
	jr 	$ra