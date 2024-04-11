; Ali Asif 
; 22i-1019 
; D

INCLUDE Irvine32.inc
INCLUDE Macros.inc

BUFFER_SIZE = 5000
.data
    
	; Coin Collection
    horizontalCoinLayout3 DB 18 dup(1)
						  DB 18 dup(1)
						  DB 18 dup(1)
						  DB 18 dup(1)
						  DB 18 dup(1)
						  DB 18 dup(1)
						  DB 18 dup(1)
						  DB 18 dup(1)

    verticleCoinLayout1 DB 18 dup(1)
						DB 18 dup(1)
						DB 18 dup(1)
						DB 18 dup(1)

    horizontalCoinLayout1 DB 124 dup(1)
						  DB 124 dup(1)

	horizontalCoinLayout2 DB 84 dup(1)
						  DB 78 dup(1)
						  DB 65 dup(1)
						  DB 72 dup(1)
						  DB 84 dup(1)

    verticleCoinLayout2 DB 11 dup(1)
						DB 3  dup(1)
						DB 7  dup(1)
						DB 15 dup(1)

	; Welcome Screen
	strPacMan DB 'Welcome to PacMan', 0
	enterName DB 'Username : ', 0

	; Game Result
	strResult DB 'Game Result', 0
	strUsername DB 'Username : ', 0
	strLevelWhich DB 'Level : ', 0

	; Menu Screen
	strMenu DB 'Menu', 0
	strPlay DB '1. Play', 0
	strInstructions DB '2. Instructions', 0
	strPreferences DB '3. Preferences', 0

	; Instructions Screen
	strInstructions2 DB 'Instructions', 0
	strGeneral1 DB '-> Use simple movement controls to navigate through each maze, collecting as many coins as possible along the way.', 0
	strGeneral2 DB '   Avoid all types of Ghosts. Collision with a Ghost decrements your life.', 0
	strGeneral3 DB '   There are 3 levels to complete in 3 lives each.', 0

	strMVup DB '-> Move Up    : W', 0
	strMVleft DB '   Move Left  : A', 0
	strMVdown DB '   Move Down  : S', 0
	strMVright DB '   Move Right : D', 0

	strOtherCTRLs1 DB '-> Pause  : P', 0
	strOtherCTRLs2 DB '   Resume : R', 0
	strOtherCTRLs3 DB '   Quit   : X', 0

	; Preferences Screen
	strPreferences2 DB 'Preferences', 0
	strChoosePacman DB 'Choose your PacMan : ', 0
	strChooseGhost DB 'Choose your Ghost  : ', 0

	; Frame
	vFrameElement DB '|', 0
    ground BYTE '-------------------------------------------------------------------------------------------------------------------------------------', 0
	mazeRectangle DB '------------------------------', 0
	dash DB '-', 0
	l2h1 DB '------------------------------------------------------------------------------------------', 0
	l2h2 DB '------------------------------------------------------------------------------------', 0
	l2h3 DB '------------------------------------------------------------------------------', 0
	l2h4 DB '------------------------------------------------------------------------', 0
	l2h5 DB '------------------------------------------------------------------', 0
	l3Horizontals DB '--------------------', 0
	
	; Coins
	coins DB '...........................................................................................................................', 0
	dot DB '.', 0

	coins84 DB '....................................................................................', 0
	coins78 DB '..............................................................................', 0
	coins72 DB '........................................................................', 0
	coins65 DB '...............................................................', 0
	coins18 DB '..................', 0

	; Score
    strScore BYTE 'Score : ', 0
    score DD 0
	l3Score DD 0
	l2Score DD 0
	l1Score DD 0

	; Lives
	strLives DB 'Lives : ', 0
	lives DD 3

	; Game Result
	gameLost DB 'Game Over', 0
	strYouWin DB 'You Win!', 0

	; Exit
	strExit DB "Press 'x' to Exit Game", 0

	; Levels
	strLevel1 DB 'Level 1', 0
	strLevel2 DB 'Level 2', 0
	strLevel3 DB 'Level 3', 0
	strLevel4 DB 'Level 4', 0
	strLevel1Complete DB 'Level 1 Completed', 0
	strLevel2Complete DB 'Level 2 Completed', 0
	strLevel3Complete DB 'Level 3 Completed', 0

	; Paused
	strPause DB 'Game Paused', 0
	strResume DB "Press 'R' to Resume", 0
	strRemovePause DB '                   ', 0

	; Player
	Player DB 'O', 0
    xPos BYTE 2
    yPos BYTE 28

	; Ghost
	currGhostX DB 127
	currGhostY DB 6
	Ghost DB 'G', 0
    xPosGhost BYTE 127
    yPosGhost BYTE 6
	updown DB 0

	Pinky DB 'P', 0
	xPosPinky DB 127
	yPosPinky DB 6

	Inky DB 'I', 0
	xPosInky DB 80
	yPosInky DB 15
	leftRight DB 0

	Clyde DB 'C', 0
	xPosClyde DB 110
	yPosClyde DB 15

	; Bonus
	xPosSB DB ?
	yPosSB DB ?
	isScoreSpawned DB 0
	
	xPosGE DB ?
	yPosGE DB ?
	isGhostEaterSpawned DB 0
	GEsteps DB 0
	isGhostEaten DB 0
	isGEeaten DB 0


	; Other
    inputChar BYTE ?, 0
	username DB 20 dup(0)
	UNlength DD 0

	filename BYTE "highScores.txt", 0
    fileHandle HANDLE ?
    stringLength DWORD ?
    bufferLastIndex DD ?
    
    str1 BYTE "Cannot create file ", 0
    Level DB 'l', '^', 0

    temp DD 0
    secondHalf DB Buffer_Size DUP(0)
    SHlength DB 0
    myString DB 100 DUP(0)
    myStrLength DB 0
    first DB 1

    buffer BYTE BUFFER_SIZE DUP(?)


.code
main PROC
	
    call PacMan
	
	exit
main ENDP


; ------------------------
;  Main Calling Functions
; ------------------------

PacMan PROC

	; Welcome Screen
	call WelcomeScreen
	call ClrScr

	; Menu Screen
	call MenuScreen
	call clrscr

	; Levels
	;call Level1
	cmp lives, 0
	jne L2
	mov al, '1'
	mov [Level + 1], al
	jmp gameResult

	L2:
	;call Level2
	cmp lives, 0
	jne L3
	mov al, '2'
	mov [Level + 1], al
	jmp gameResult

	L3:
	call Level3
	cmp lives, 0
	jne L4
	mov al, '3'
	mov [Level + 1], al
	jmp gameResult

	L4:
	call Level4
	mov al, '4'
	mov [Level + 1], al

	GameResult:
		call fileHandling
		call gameResultScreen


	ret
PacMan endp

; ---------
;  Level 3
; ---------

Level3 PROC

	call clrscr
	mov eax, 0
	mov ebx, 0
	mov edx, 0
	mov ecx, 0
	mov lives, 3
	mov xPos, 11
	mov yPos, 15
	mov currGhostX, 20
	mov currGhostY, 15
	mov xPosGhost, 20
	mov yPosGhost, 15
	mov xPosPinky, 50
	mov yPosPinky, 15

	; Gameplay
	call DrawFrame3
	call DrawPlayer
	call DrawGhost
	call DrawClyde
	call DrawPinky
	call DrawInky
	call Randomize

	gameloop:

		call displayUserInfo3
		call checkGhostCollision3
		call checkPinkyCollision3
		call checkClydeCollision3
		call checkInkyCollision3

		; Objective
		cmp l3Score, 80
		jae exitGame

		; get user key input:
		call ReadChar
		mov inputChar, al

		; exit game if user types 'x':
		cmp inputChar, 'x'
		je exitGame

		; Pause if 'P' is Pressed
		cmp inputChar, 'p'
		jne unPaused
		call PauseGame
		jmp GameLoop

		unPaused:
		
		mov eax, black + (black * 16)
		call SetTextColor

			; Move Player
			cmp inputChar,"w"
			je moveUp

			cmp inputChar,"s"
			je moveDown

			cmp inputChar,"a"
			je moveLeft

			cmp inputChar,"d"
			je moveRight

		moveUp:
			call UpdatePlayer
			dec yPos
			call wallsU

			; Border
			mov al, 2
			cmp yPos, al
			ja Next
			inc yPos

			Next:

			; Game Over
			cmp lives, 0
			jne Skipp
			call GameOver
			call ReadChar
			jmp exitGame2

			Skipp:
				; Move Ghost
				call randomGhostMovement3
				call movePinky3
				call moveLinearGhost3
				call moveLinearGhost4

			call DrawPlayer
			mov eax, 20
			call delay

		call coinCollection3
		jmp gameLoop

		moveDown:
			call UpdatePlayer
			inc yPos
			call WallsD
			
			; Border
			mov al, 29
			cmp yPos, al
			jl Next2
			dec yPos

			Next2:

			; Game Over
			cmp lives, 0
			jne Skippp
			call GameOver
			call ReadChar
			jmp exitGame2
				
			Skippp:
				; Move Ghost
				call randomGhostMovement3
				call movePinky3
				call moveLinearGhost3
				call moveLinearGhost4

			call DrawPlayer
			mov eax, 20
			call delay
		call coinCollection3
			jmp gameLoop

		moveLeft:
			call UpdatePlayer
			dec xPos
			call WallsL
			
			; Border
			mov al, 0
			cmp xPos, al
			ja Next3
			inc xPos

			Next3:

			; Game Over
			cmp lives, 0
			jne Skipppp
			call GameOver
			call ReadChar
			jmp exitGame2
				
			Skipppp:
				; Move Ghost
				call randomGhostMovement3
				call movePinky3
				call moveLinearGhost3
				call moveLinearGhost4

			call DrawPlayer
			mov eax, 15
			call delay
		call coinCollection3
		jmp gameLoop

		moveRight:
			call UpdatePlayer
			inc xPos
			call WallsR
			
			; Border
			mov al, 132
			cmp xPos, al
			jb Next4
			dec xPos

			Next4:

			; Game Over
			cmp lives, 0
			jne Skippppp
			call GameOver
			call ReadChar
			jmp exitGame2
				
			Skippppp:
				; Move Ghost
				call randomGhostMovement3
				call movePinky3
				call moveLinearGhost3
				call moveLinearGhost4

			call DrawPlayer
			mov eax, 15
			call delay

		call coinCollection3
		jmp GameLoop

	exitGame:
		call level3complete

	exitGame2:

	ret
Level3 endp

checkGhostCollision3 PROC

	mov al, xPos
	mov bl, yPos

	; Horizontal Check
	cmp al, xPosGhost
	jne Skip

	; Verticle Check
	cmp bl, yPosGhost
	jne Skip

	; Collision Detected
	; Remove Player and Ghost from Current Position
	mov eax, black + (black * 16)
	call SetTextColor
	
	mov dl, xPosGhost
	mov dh, yPosGhost
	call GoToXY

	mov al, ' '
	call writeChar
	
	mov dl, xPos
	mov dh, yPos
	call GoToXY

	mov al, ' '
	call writeChar

	; Reset Player and Ghost
	mov xPos, 11
	mov yPos, 15
	mov xPosGhost, 20
	mov yPosGhost, 15
	call updateGhost
	dec lives

	Skip:

	ret
checkGhostCollision3 endP

checkPinkyCollision3 PROC

	mov al, xPos
	mov bl, yPos

	; Horizontal Check
	cmp al, xPosPinky
	jne Skip

	; Verticle Check
	cmp bl, yPosPinky
	jne Skip

	; Collision Detected
	; Remove Player and Ghost from Current Position
	mov eax, black + (black * 16)
	call SetTextColor
	
	mov dl, xPosPinky
	mov dh, yPosPinky
	call GoToXY

	mov al, ' '
	call writeChar
	
	mov dl, xPos
	mov dh, yPos
	call GoToXY

	mov al, ' '
	call writeChar

	; Reset Player and Ghost
	mov xPos, 11
	mov yPos, 15
	mov xPosPinky, 50
	mov yPosPinky, 15
	call updatePinky
	dec lives

	Skip:

	ret
checkPinkyCollision3 endP

checkInkyCollision3 PROC

	mov al, xPos
	mov bl, yPos

	; Horizontal Check
	cmp al, xPosInky
	jne Skip

	; Verticle Check
	cmp bl, yPosInky
	jne Skip

	; Collision Detected
	; Remove Player and Ghost from Current Position
	mov eax, black + (black * 16)
	call SetTextColor
	
	mov dl, xPosInky
	mov dh, yPosInky
	call GoToXY

	mov al, ' '
	call writeChar
	
	mov dl, xPos
	mov dh, yPos
	call GoToXY

	mov al, ' '
	call writeChar

	; Reset Player and Ghost
	mov xPos, 11
	mov yPos, 15
	mov xPosInky, 80
	mov yPosInky, 15
	call updateInky
	dec lives

	Skip:

	ret
checkInkyCollision3 endP

checkClydeCollision3 PROC

	mov al, xPos
	mov bl, yPos

	; Horizontal Check
	cmp al, xPosClyde
	jne Skip

	; Verticle Check
	cmp bl, yPosClyde
	jne Skip

	; Collision Detected
	; Remove Player and Ghost from Current Position
	mov eax, black + (black * 16)
	call SetTextColor
	
	mov dl, xPosClyde
	mov dh, yPosClyde
	call GoToXY

	mov al, ' '
	call writeChar
	
	mov dl, xPos
	mov dh, yPos
	call GoToXY

	mov al, ' '
	call writeChar

	; Reset Player and Ghost
	mov xPos, 11
	mov yPos, 15
	mov xPosClyde, 120
	mov yPosClyde, 15
	call updateClyde
	dec lives

	Skip:

	ret
checkClydeCollision3 endP


level3Complete PROC

	; Level has been Completed
	call clrscr

	mov eax, green + (black * 16)
	call SetTextColor

	mov dl, 58
	mov dh, 13
	call GoToxy
	
	mov edx, OFFSET strLevel3Complete
	call WriteString

	mov dl, 57
	mov dh, 14
	call GoToxy

	mov eax, lightGray + (black * 16)
	call SetTextColor
	
	mov edx, OFFSET strResume
	call WriteString

	Level4jmp:
		call readChar
		cmp al, 'r'
		jne Level4jmp
	

	inComplete:

	ret
Level3Complete endP

randomGhostMovement3 PROC

	mov eax, black + (black * 16)
	call SetTextColor

	mov dl, xPosClyde
	mov dh, yPosClyde
	call GoToXY

	mov al, ' '
	call writeChar

	mov eax, 18
	call randomRange
	Add eax, 101
	mov xPosClyde, al
	
	mov eax, 7
	call randomRange
	add eax, 12
	mov yPosClyde, al

	call drawClyde
	
	Skip:
		ret
randomGhostMovement3 endp

moveLinearGhost3 PROC

	call updateGhost
	mov al, 0
	cmp upDown, al
	je Down

	; Up
	dec yPosGhost

	mov al, 11
	cmp yPosGhost, al
	jne Next
	mov al, 0
	mov upDown, al

	
	Down:
		inc yPosGhost
		mov al, 18
		cmp yPosGhost, al
		jne Next
		mov al, 1
		mov upDown, al

	Next:
		call DrawGhost

	ret
moveLinearGhost3 endP

moveLinearGhost4 PROC

	call updateInky
	mov al, 0
	cmp leftRight, al
	je Right

	; Left
	dec xPosInky
	mov al, 70
	cmp xPosInky, al
	jne Next
	mov al, 0
	mov leftRight, al

	
	Right:
		inc xPosInky
		mov al, 88
		cmp xPosInky, al
		jne Next
		mov al, 1
		mov LeftRight, al

	Next:
		call DrawInky

	ret
moveLinearGhost4 endP

DrawClyde PROC

	mov eax, black + (Yellow * 16)
	call SetTextColor

	; draw Ghost at (xPos,yPos):
	mov dl, xPosClyde
	mov dh, yPosClyde
	call Gotoxy

	mov al, Clyde
	call WriteChar
	
	ret
DrawClyde ENDP

UpdateClyde PROC

	mov dl, xPosClyde
	mov dh, yPosCLyde
	call Gotoxy
	
	mov al, " "
	call WriteChar
	
	ret
UpdateClyde ENDP

DrawInky PROC

	mov eax, black + (lightCyan * 16)
	call SetTextColor

	; draw Ghost at (xPos,yPos):
	mov dl, xPosInky
	mov dh, yPosInky
	call Gotoxy

	mov al, Inky
	call WriteChar
	
	ret
DrawInky ENDP


UpdateInky PROC

	mov eax, black + (black * 16)
	call SetTextColor

	mov dl, xPosInky
	mov dh, yPosInky
	call Gotoxy
	
	mov al, " "
	call WriteChar
	
	ret
UpdateInky ENDP

; ---------
;  Walls 3
; ---------

wallsU PROC

	cmp yPos, 10
	jne Skip

	inc yPos

	Skip:

	ret
wallsU endp

wallsD PROC

	cmp yPos, 20
	jne Skip

	dec yPos

	Skip:

	ret
wallsD endp

wallsL PROC

	cmp xPos, 10
	je Next1
		
	cmp xPos, 40
	je Next2
		
	cmp xPos, 70
	je Next3
		
	cmp xPos, 100
	je Next4

	jmp Skip

	Next1:
		cmp yPos, 15
		jne Jump1

		mov xPos, 117

		Jump1:
			inc xPos

		jmp Skip
		
	Next2:
		cmp yPos, 15
		jne Jump2

		mov xPos, 27

		Jump2:
			inc xPos

		jmp Skip
		
	Next3:
		cmp yPos, 15
		jne Jump3

		mov xPos, 57

		Jump3:
			inc xPos

		jmp Skip

	Next4:
		cmp yPos, 15
		jne Jump4

		mov xPos, 87

		Jump4:
			inc xPos

	Skip:

	ret
wallsL endp

wallsR PROC

	cmp xPos, 29
	je Next1
		
	cmp xPos, 59
	je Next2
		
	cmp xPos, 89
	je Next3
		
	cmp xPos, 119
	je Next4

	jmp Skip

	

	Next1:
		cmp yPos, 15
		jne Jump1

		mov xPos, 42

		Jump1:
			dec xPos

		jmp Skip
		
	Next2:
		cmp yPos, 15
		jne Jump2

		mov xPos, 72

		Jump2:
			dec xPos

		jmp Skip
		
	Next3:
		cmp yPos, 15
		jne Jump3

		mov xPos, 102

		Jump3:
			dec xPos

		jmp Skip

	Next4:
		cmp yPos, 15
		jne Jump4

		mov xPos, 12

		Jump4:
			dec xPos

	Skip:

	ret
wallsR endp


; ---------
;  Frame 3
; ---------

DrawFrame3 PROC

	mov eax, blue + (black * 16)
	call SetTextColor

	; Horizontal Borders
	mov dl, 0
	mov dh, 2
	call gotoxy

	mov edx, OFFSET ground
	call WriteString
	 
	mov dl, 0
	mov dh, 29
	call Gotoxy
	
	mov edx, OFFSET ground
	call WriteString

	; Verticle Borders
	mov bl, 3
	mov ecx, 26
	mov dl, 0
	mov dh, bl
	call gotoxy

	verticalFrame:
		mov edx, offset vFrameElement
		call WriteString

		mov dl, 132
		mov dh, bl
		call gotoxy

		mov edx, offset vFrameElement
		call WriteString

		inc bl
		mov dl, 0
		mov dh, bl
		call gotoxy

		mov eax, 20
		call delay

	LOOP verticalFrame


	; Horizontals
	mov dl, 10
	mov dh, 10
	call gotoXY

	mov edx, offset l3Horizontals
	call writeString

	mov dl, 40
	mov dh, 10
	call gotoXY

	mov edx, offset l3Horizontals
	call writeString

	mov dl, 70
	mov dh, 10
	call gotoXY

	mov edx, offset l3Horizontals
	call writeString

	mov dl, 100
	mov dh, 10
	call gotoXY

	mov edx, offset l3Horizontals
	call writeString


	mov dl, 10
	mov dh, 20
	call gotoXY

	mov edx, offset l3Horizontals
	call writeString

	mov dl, 40
	mov dh, 20
	call gotoXY

	mov edx, offset l3Horizontals
	call writeString

	mov dl, 70
	mov dh, 20
	call gotoXY

	mov edx, offset l3Horizontals
	call writeString

	mov dl, 100
	mov dh, 20
	call gotoXY

	mov edx, offset l3Horizontals
	call writeString


	; Vericles
	mov dl, 10
	mov dh, 11
	call gotoXY
	
	mov ebx, 0
	mov bh, dh
	mov eax, 0
	mov ecx, 9

	L1:
		mov eax, 20
		call delay

		cmp ecx, 5
		jne Skip7

		mov dl, 10
		mov dh, bh
		call GOTOXY
		dec ecx
		
		mov eax, lightgray + (lightgray * 16)
		call SetTextColor

		mov eax, '*'
		call writeChar
		
		mov eax, blue + (black * 16)
		call SetTextColor

		inc bh
		mov dl, 10
		mov dh, bh
		call GoToXY

		jmp L1

		Skip7:
			mov al, '|'
			call writeChar
		
			inc bh
			mov dl, 10
			mov dh, bh
			call gotoXy

		LOOP L1

	mov dl, 29
	mov dh, 11
	call gotoXY
	
	mov ebx, 0
	mov bh, dh
	mov eax, 0
	mov ecx, 9

	L2:
		mov eax, 20
		call delay

		cmp ecx, 5
		jne Skip

		mov dl, 29
		mov dh, bh
		call GOTOXY
		dec ecx
		
		mov eax, lightgray + (lightgray * 16)
		call SetTextColor

		mov eax, '*'
		call writeChar
		
		mov eax, blue + (black * 16)
		call SetTextColor

		inc bh
		mov dl, 29
		mov dh, bh
		call GoToXY

		jmp L2

		Skip:
		mov al, '|'
		call writeChar
		
		inc bh
		mov dl, 29
		mov dh, bh
		call gotoXy
		
		LOOP L2

	mov dl, 40
	mov dh, 11
	call gotoXY
	
	mov ebx, 0
	mov bh, dh
	mov eax, 0
	mov ecx, 9

	L3:
		mov eax, 20
		call delay

		cmp ecx, 5
		jne Skip1

		mov dl, 40
		mov dh, bh
		call GOTOXY
		dec ecx
		
		mov eax, lightgray + (lightgray * 16)
		call SetTextColor

		mov eax, '*'
		call writeChar
		
		mov eax, blue + (black * 16)
		call SetTextColor

		inc bh
		mov dl, 40
		mov dh, bh
		call GoToXY

		jmp L3

		Skip1:
		mov al, '|'
		call writeChar
		
		inc bh
		mov dl, 40
		mov dh, bh
		call gotoXy
		
		LOOP L3

	mov dl, 59
	mov dh, 11
	call gotoXY
	
	mov ebx, 0
	mov bh, dh
	mov eax, 0
	mov ecx, 9

	L4:
		mov eax, 20
		call delay

		cmp ecx, 5
		jne Skip2

		mov dl, 59
		mov dh, bh
		call GOTOXY
		dec ecx
		
		mov eax, lightgray + (lightgray * 16)
		call SetTextColor

		mov eax, '*'
		call writeChar
		
		mov eax, blue + (black * 16)
		call SetTextColor

		inc bh
		mov dl, 59
		mov dh, bh
		call GoToXY

		jmp L4

		Skip2:
		mov al, '|'
		call writeChar
		
		inc bh
		mov dl, 59
		mov dh, bh
		call gotoXy
		
		LOOP L4

	mov dl, 70
	mov dh, 11
	call gotoXY
	
	mov ebx, 0
	mov bh, dh
	mov eax, 0
	mov ecx, 9

	L5:
		mov eax, 20
		call delay

		cmp ecx, 5
		jne Skip3

		mov dl, 70
		mov dh, bh
		call GOTOXY
		dec ecx
		
		mov eax, lightgray + (lightgray * 16)
		call SetTextColor

		mov eax, '*'
		call writeChar
		
		mov eax, blue + (black * 16)
		call SetTextColor

		inc bh
		mov dl, 70
		mov dh, bh
		call GoToXY

		jmp L5

		Skip3:
		mov al, '|'
		call writeChar
		
		inc bh
		mov dl, 70
		mov dh, bh
		call gotoXy
		
		LOOP L5

	mov dl, 89
	mov dh, 11
	call gotoXY
	
	mov ebx, 0
	mov bh, dh
	mov eax, 0
	mov ecx, 9

	L6:
		mov eax, 20
		call delay

		cmp ecx, 5
		jne Skip4

		mov dl, 89
		mov dh, bh
		call GOTOXY
		dec ecx
		
		mov eax, lightgray + (lightgray * 16)
		call SetTextColor

		mov eax, '*'
		call writeChar
		
		mov eax, blue + (black * 16)
		call SetTextColor

		inc bh
		mov dl, 89
		mov dh, bh
		call GoToXY

		jmp L6

		Skip4:
		mov al, '|'
		call writeChar
		
		inc bh
		mov dl, 89
		mov dh, bh
		call gotoXy
		
		LOOP L6

	mov dl, 100
	mov dh, 11
	call gotoXY
	
	mov ebx, 0
	mov bh, dh
	mov eax, 0
	mov ecx, 9

	L7:
		mov eax, 20
		call delay

		cmp ecx, 5
		jne Skip5

		mov dl, 100
		mov dh, bh
		call GOTOXY
		dec ecx
		
		mov eax, lightgray + (lightgray * 16)
		call SetTextColor

		mov eax, '*'
		call writeChar
		
		mov eax, blue + (black * 16)
		call SetTextColor

		inc bh
		mov dl, 100
		mov dh, bh
		call GoToXY

		jmp L7

		Skip5:
		mov al, '|'
		call writeChar
		
		inc bh
		mov dl, 100
		mov dh, bh
		call gotoXy
		
		LOOP L7

	mov dl, 119
	mov dh, 11
	call gotoXY
	
	mov ebx, 0
	mov bh, dh
	mov eax, 0
	mov ecx, 9

	L8:
		mov eax, 20
		call delay

		cmp ecx, 5
		jne Skip6

		mov dl, 119
		mov dh, bh
		call GOTOXY
		dec ecx
		
		mov eax, lightgray + (lightgray * 16)
		call SetTextColor

		mov eax, '*'
		call writeChar
		
		mov eax, blue + (black * 16)
		call SetTextColor

		inc bh
		mov dl, 119
		mov dh, bh
		call GoToXY

		jmp L8

		Skip6:
		mov al, '|'
		call writeChar
		
		inc bh
		mov dl, 119
		mov dh, bh
		call gotoXy
		
		LOOP L8


	; Coins
	mov eax, yellow + (black * 16)
	call SetTextColor

	mov dl, 11
	mov dh, 11
	call gotoXY

	mov edx, offset coins18
	call writeString

	mov dl, 41
	mov dh, 11
	call gotoXY

	mov edx, offset coins18
	call writeString

	mov dl, 71
	mov dh, 11
	call gotoXY

	mov edx, offset coins18
	call writeString

	mov dl, 101
	mov dh, 11
	call gotoXY

	mov edx, offset coins18
	call writeString


	mov dl, 11
	mov dh, 19
	call gotoXY

	mov edx, offset coins18
	call writeString

	mov dl, 41
	mov dh, 19
	call gotoXY

	mov edx, offset coins18
	call writeString

	mov dl, 71
	mov dh, 19
	call gotoXY

	mov edx, offset coins18
	call writeString

	mov dl, 101
	mov dh, 19
	call gotoXY

	mov edx, offset coins18
	call writeString


	ret
DrawFrame3 endP

; -------
;  Coins 
; -------

coinCollection3 PROC

	mov esi, offset horizontalCoinLayout3
	movzx eax, xPos
	movzx ebx, yPos

	cmp xPos, 31
	ja N1
	jmp Row1
	
	N1:
		cmp xPos, 61
		ja N2
		jmp Row3
	
	N2:
		cmp xPos, 91
		jmp Row7
		jmp Row5

	Row1:
		cmp yPos, 11
		jne Row2

		Sub eax, 11
		Add esi, eax

		mov edx, 0
		cmp [esi], dl
		je Skip

		; Increment Score
		mov edx, 0
		mov [esi], dl
		inc score
		inc l3Score
		jmp Skip

	Row2:
		cmp yPos, 19
		jne Skip

		; Row 2
		Add esi, 18
		Sub eax, 11
		Add esi, eax

		mov edx, 0
		cmp [esi], dl
		je Skip

		; Increment Score
		mov edx, 0
		mov [esi], dl
		inc score
		inc l3Score
		jmp Skip

	Row3:
		cmp yPos, 11
		jne Row4

		; Row 3
		Add esi, 36
		Sub eax, 11
		Add esi, eax

		mov edx, 0
		cmp [esi], dl
		je Skip

		; Increment Score
		mov edx, 0
		mov [esi], dl
		inc score
		inc l3Score
		jmp Skip
			
	Row4:
		cmp yPos, 19
		jne Skip

		; Row 3
		Add esi, 54
		Sub eax, 11
		Add esi, eax

		mov edx, 0
		cmp [esi], dl
		je Skip

		; Increment Score
		mov edx, 0
		mov [esi], dl
		inc score
		inc l3Score
		jmp Skip
			
	Row5:
		cmp yPos, 11
		jne Row6

		; Row 3
		Add esi, 72
		Sub eax, 11
		Add esi, eax

		mov edx, 0
		cmp [esi], dl
		je Skip

		; Increment Score
		mov edx, 0
		mov [esi], dl
		inc score
		inc l3Score
		jmp Skip
			
	Row6:
		cmp yPos, 19
		jne Skip

		; Row 3
		Add esi, 90
		Sub eax, 11
		Add esi, eax

		mov edx, 0
		cmp [esi], dl
		je Skip

		; Increment Score
		mov edx, 0
		mov [esi], dl
		inc score
		inc l3Score
		jmp Skip
			
	Row7:
		cmp yPos, 11
		jne Row8

		; Row 3
		Add esi, 108
		Sub eax, 11
		Add esi, eax

		mov edx, 0
		cmp [esi], dl
		je Skip

		; Increment Score
		mov edx, 0
		mov [esi], dl
		inc score
		inc l3Score
		jmp Skip
			
	Row8:
		cmp yPos, 19
		jne Skip

		; Row 3
		Add esi, 124
		Sub eax, 11
		Add esi, eax

		mov edx, 0
		cmp [esi], dl
		je Skip

		; Increment Score
		mov edx, 0
		mov [esi], dl
		inc score
		inc l3Score
		jmp Skip

	Skip:

	ret
coinCollection3 endp

; -------------
;  User Info 3
; -------------

DisplayUserInfo3 PROC

	mov eax, white + (black * 16)
	call SetTextColor

	; Score
	mov dl, 0
	mov dh, 0
	call Gotoxy

	mov edx, OFFSET strScore
	call WriteString

	mov eax, score
	call WriteDec

	; Lives
	mov dl, 0
	mov dh, 1
	call Gotoxy

	mov edx, OFFSET strLives
	call WriteString
	
	mov eax, lives
	call WriteDec

	; Level 
	mov eax, yellow + (black * 16)
	call SetTextColor

	mov dl, 125
	mov dh, 1
	call Gotoxy

	mov edx, OFFSET strLevel3
	call WriteString

	ret
DisplayUserInfo3 endP


; -------------
;  Game Result
; -------------

gameResultScreen PROC

	call clrscr

	; Game Result
	mov eax, yellow + (black * 16)
	call SetTextColor

	mov dl, 61
	mov dh, 13
	call GoToxy
	
	mov edx, OFFSET strResult
	call WriteString

	
	; Username
	mov eax, white + (black * 16)
	call SetTextColor

	mov dl, 58
	mov dh, 15
	call GoToxy
	
	mov edx, OFFSET strUsername
	call WriteString

	mov eax, gray + (black * 16)
	call SetTextColor

	mov dl, 69
	mov dh, 15
	call GoToxy
	
	mov edx, OFFSET Username
	call WriteString


	; Level
	mov eax, white + (black * 16)
	call SetTextColor

	mov dl, 61
	mov dh, 16
	call GoToxy
	
	mov edx, OFFSET strlevelWhich
	call WriteString

	mov eax, gray + (black * 16)
	call SetTextColor

	mov dl, 69
	mov dh, 16
	call GoToxy
	
	mov eax, 0
	mov al, [level + 1]
	Sub al, '0'
	call writeDec


	; Score
	mov eax, white + (black * 16)
	call SetTextColor

	mov dl, 61
	mov dh, 17
	call GoToxy
	
	mov edx, OFFSET strScore
	call WriteString

	mov eax, gray + (black * 16)
	call SetTextColor

	mov dl, 69
	mov dh, 17
	call GoToxy
	
	mov eax, score
	call writeDec


	; Exit Instruction
	mov eax, green + (black * 16)
	call SetTextColor

	mov dl, 56
	mov dh, 19
	call GoToxy
	
	mov edx, OFFSET strExit
	call WriteString

	L1:
		call readChar
		cmp al, 'x'
		jne L1

	ret
gameResultScreen endp


; ---------------
;  File Handling
; ---------------

fileHandling PROC

	; Open File
	mov edx, OFFSET filename
	call OpenInputFile
	mov fileHandle, eax
	
    ; Error Opening File?
	cmp eax, INVALID_HANDLE_VALUE
	jne letsReadFile 

    
    ; Create File
    mov edx, OFFSET filename
    call CreateOutputFile
	mov fileHandle, eax

    
    letsReadFile:

        ; Read File
		mov edx, OFFSET buffer
		mov ecx, BUFFER_SIZE
		call ReadFromFile
		jnc check_buffer_size
	
        ; Error Reading File?
	    mWrite "Error reading file. "
	    call WriteWindowsMsg	 ;	yes: show error message
	    jmp close_file
	
	    check_buffer_size:
		    cmp eax,BUFFER_SIZE
		    jb buf_size_ok	; buffer large enough?
		    mWrite <"Error: Buffer too small for the file",0dh,0ah>	; yes
		    jmp quit	 ; and quit
	
	    buf_size_ok:
            mov bufferLastIndex, eax
		    ;mov buffer[eax], 0	; insert null terminator
            ;mWrite "File size: "
	        ;call WriteDec	; display file size
	        ;call Crlf
            ;inc bufferLastIndex
       
	
        ; Display File Content
        inc fileHandle
        mov eax, fileHandle
	    mov edx,OFFSET buffer
        ;call WriteString
	    call Crlf
        mov fileHandle, eax
   
        ; Error Displaying File Content?
        cmp eax, INVALID_HANDLE_VALUE   ;Check for errors.
        jne close_file ; if error not found
   
        mov edx,OFFSET str1
        call WriteString
        jmp quit
        

    ; Close File
	close_file:
		call CloseFile


    ; Create File
    mov edx, OFFSET filename
    call CreateOutputFile
	mov fileHandle, eax
	
    ; Error Opening File?
	cmp eax, INVALID_HANDLE_VALUE
	jne letsWriteToFile
    mov eax, 7


    ; Write File
    letsWriteToFile:

        ; ----------------------
        ;  Append New User Info
        ; ----------------------

		; Calculate LengthOF username
		mov esi, offset username
		mov UNlength, 1
		
		LX:
			mov eax, 0
			mov al, 0h
			cmp [esi], al
			je Skip
			inc esi
			inc UNlength
			jmp LX

		Skip:
        ; Write Username
        mov ecx, 0
        mov esi, offset myString
        mov eax, 0
        mov ebx, UNlength
        dec ebx

        L1:
            mov dl, [username + ecx]
            mov [esi + eax], dl
            inc eax
            inc ecx
            inc myStrLength

            cmp ecx, ebx
            jne L1
    
        Next:

        ; Write Level
        mov myString[ecx], '-'
        mov ecx, 0
        mov esi, offset myString
        Add esi, UNlength
        inc myStrLength
        mov ebx, lengthof level
        dec ebx

        L2:
            mov dl, [level + ecx]
            mov [esi + ecx], dl
            inc ecx
            inc myStrLength

            cmp ecx, ebx
            jne L2
    
        Next2:

        ; Write Score
        mov edx, UNlength
        Add edx, LengthOF level
        dec edx
        mov myString[edx], '+'
        inc myStrLength

        mov temp, 0
        mov eax, score

        L3:
            mov cl, 10
            Div cl
            mov ebx, 0
            mov bl, ah
            add bl, '0'
            push ebx
            mov bl, al
            movzx eax, bl
            inc temp

            cmp eax, 0
            jne L3
        
        mov ecx, temp
        mov edx, 0
        mov esi, offset myString
        Add esi, UNlength
        Add esi, LENGTHOF level

        reverseScore:

            pop ebx
            mov [esi + edx], bl
            inc edx
            inc myStrLength

            LOOP reverseScore

        Next3:
            ; Now, myString has the User Information
            ; Add it to the Buffer so that the Buffer remains sorted in Descending Order
            
            mov ecx, 0
            mov esi, offset buffer
            mov temp, 0

            mov al, 0h
            cmp [esi], al
            je nexttt

            L4:
                inc temp
                mov al, '+'
                inc ecx
                cmp [esi + ecx], al
                jne SkipCheck

                ; Check Score
                inc ecx
                mov eax, 0
                mov al, [esi + ecx]
                Sub al, '0'

                inc ecx
                inc temp
                mov bl, 0dh
                cmp [esi + ecx], bl
                je CompareScores
                    
                mov dl, 0ah
                cmp [esi + ecx], dl
                je CompareScores
                    
                mov dl, 0h
                cmp [esi + ecx], dl
                je CompareScores

                L5:
                    ; Convert Current Element to Integer using its ASCII
                    mov ebx, 0
                    mov bl, [esi + ecx]
                    Sub bl, '0'
                    
                    ; Add Current Element in eax
                    mov edx, 0
                    mov dl, 10
                    Mul dl
                    Add eax, ebx
                    inc ecx
                    inc temp

                    mov dl, 0dh
                    cmp [esi + ecx], dl
                    je CompareScores
                    
                    mov dl, 0ah
                    cmp [esi + ecx], dl
                    je CompareScores
                    
                    mov dl, 0h
                    cmp [esi + ecx], dl
                    je CompareScores
                    
                    jmp L5

                CompareScores:
                    cmp score, eax
                    jae PositionFound
                    mov temp, 0
                    mov first, 0

                SkipCheck:
                    cmp ecx, bufferLastIndex
                    jne L4
                    inc ecx
                    inc ecx


            PositionFound:
                ; ecx has the Starting Index of the Second Half of the Buffer
                mov eax, ecx
                Sub ecx, temp
                cmp temp, 0
                je Nexttt

                mov edi, offset secondHalf
                dec ecx
                mov eax, ecx

                cmp first, 1
                je L6

                inc ecx
                inc eax

                ; Copy Second Half of the Buffer to SecondHalf
                L6:
                    mov bl, [esi + ecx]
                    mov [edi], bl
                    inc edi
                    inc ecx 
                    inc SHlength

                    cmp ecx, bufferLastIndex
                    jne L6


            Nexttt:
            ; Now Insert myString to its Correct Place
            movzx ecx, myStrLength
            mov edi, offset myString
            
            cmp temp, 0
            jne L7

            mov dl, 0ah
            mov [esi + eax], dl
            inc eax

            L7:
                mov dl, [edi]
                mov [esi + eax], dl
                inc eax
                inc edi

                LOOP L7
           
            mov dl, 0ah
            mov [esi + eax], dl
            inc eax
            
            cmp temp, 0
            je Nextttt

            movzx ecx, SHlength
            mov edi, offset secondHalf

            mov dl, 0ah
            cmp [edi], dl
            jne L8
            inc edi

            L8:
                mov dl, [edi]
                mov [esi + eax], dl
                inc edi
                inc eax

                LOOP L8


        ;mov bufferLastIndex, edx
        ;inc edx
        ;mov buffer[edx], 0
        Nextttt:
        ; Write the buffer to the HighScore File
        mov bufferLastIndex, eax
        mov eax, fileHandle
        mov edx, OFFSET buffer
        mov ecx, bufferLastIndex
        call WriteToFile
        jc show_error_message

        mov eax, 0

        show_error_message:

    ; Close File
	close_file2:
		call CloseFile
    call Crlf
    
    quit:

	ret
fileHandling endp


; ---------
;  Level 4
; ---------

Level4 PROC

	call clrscr
	mov lives, 1
	mov xPos, 1
	mov yPos, 28
	mov currGhostX, 65
	mov currGhostY, 15
	mov xPosGhost, 65
	mov yPosGhost, 15

	; Gameplay
	call DrawFrame4
	call displayUserInfo4
	call DrawPlayer
	call DrawGhost
	call Randomize
	call scoreBonus4

	gameloop:

		; Objective
		call checkScoreCollision4
		cmp bl, 1
		je exitGame

		; get user key input:
		call ReadChar
		mov inputChar, al

		; exit game if user types 'x':
		cmp inputChar, 'x'
		je exitGame

		; Pause if 'P' is Pressed
		cmp inputChar, 'p'
		jne unPaused
		call PauseGame
		jmp GameLoop

		unPaused:
		
		mov eax, black + (black * 16)
		call SetTextColor

			; Move Player
			cmp inputChar,"w"
			je moveUp

			cmp inputChar,"s"
			je moveDown

			cmp inputChar,"a"
			je moveLeft

			cmp inputChar,"d"
			je moveRight

		moveUp:
			call UpdatePlayer
			dec yPos

			; Border
			mov al, 2
			cmp yPos, al
			ja Next
			inc yPos

			Next:
			call checkCollision4
			; Game Over
			cmp lives, 0
			jne Skipp
			call GameOver
			call ReadChar
			jmp exitGame

			Skipp:
				; Move Ghost
				call randomGhostMovement4

			call DrawPlayer
			mov eax, 20
			call delay
		jmp gameLoop

		moveDown:
			call UpdatePlayer
			inc yPos
			
			; Border
			mov al, 29
			cmp yPos, al
			jl Next2
			dec yPos

			Next2:
			call checkCollision4
			; Game Over
			cmp lives, 0
			jne Skippp
			call GameOver
			call ReadChar
			jmp exitGame
				
			Skippp:
				; Move Ghost
				call randomGhostMovement4

			call DrawPlayer
			mov eax, 20
			call delay
			jmp gameLoop

		moveLeft:
			call UpdatePlayer
			dec xPos
			
			; Border
			mov al, 0
			cmp xPos, al
			ja Next3
			inc xPos

			Next3:
			call checkCollision4
			; Game Over
			cmp lives, 0
			jne Skipppp
			call GameOver
			call ReadChar
			jmp exitGame2
				
			Skipppp:
				; Move Ghost
				call randomGhostMovement4

			call DrawPlayer
			mov eax, 15
			call delay
		jmp gameLoop

		moveRight:
			call UpdatePlayer
			inc xPos
			
			; Border
			mov al, 132
			cmp xPos, al
			jb Next4
			dec xPos

			Next4:
			call checkCollision4
			; Game Over
			cmp lives, 0
			jne Skippppp
			call GameOver
			call ReadChar
			jmp exitGame
				
			Skippppp:
				; Move Ghost
				call randomGhostMovement4

			call DrawPlayer
			mov eax, 15
			call delay

		jmp GameLoop

	exitGame:
		call level4complete

	exitGame2:

	ret
Level4 endp

level4Complete PROC

	; Level has been Completed
	call clrscr

	mov eax, green + (black * 16)
	call SetTextColor

	mov dl, 62
	mov dh, 13
	call GoToxy
	
	mov edx, OFFSET strYouWin
	call WriteString

	mov dl, 57
	mov dh, 14
	call GoToxy

	mov eax, lightGray + (black * 16)
	call SetTextColor
	
	mov edx, OFFSET strResume
	call WriteString

	Level2jmp:
		call readChar
		cmp al, 'r'
		jne Level2jmp
	

	inComplete:

	ret
Level4Complete endP

; -------------
;  Score Bonus
; -------------

scoreBonus4 PROC

	mov yPosSB, 3
	mov xPosSB, 131

	mov dl, xPosSB
	mov dh, yPosSB
	call GoToXY

	mov eax, black + (yellow * 16)
	call SetTextColor

	mov al, '$'
	call writeChar

	ret
scoreBonus4 endP

checkScoreCollision4 PROC

	mov bl, 0

	mov al, xPosSB
	cmp xPos, al
	jne Skip

	mov al, yPosSB
	cmp yPos, al
	jne Skip

	; Bonus Acheived
	Add score, 100
	mov bl, 1
	
	Skip:

	ret
checkScoreCollision4 endP


; ---------
;  Frame 4
; ---------

DrawFrame4 PROC

	mov eax, blue + (black * 16)
	call SetTextColor

	; Horizontal Borders
	mov dl, 0
	mov dh, 2
	call gotoxy
	mov edx, OFFSET ground
	call WriteString
	 
	mov dl, 0
	mov dh, 29
	call Gotoxy
	
	mov edx, OFFSET ground
	call WriteString

	; Verticle Borders
	mov bl, 3
	mov ecx, 26
	mov dl, 0
	mov dh, bl
	call gotoxy

	verticalFrame:
		mov edx, offset vFrameElement
		call WriteString

		mov dl, 132
		mov dh, bl
		call gotoxy

		mov edx, offset vFrameElement
		call WriteString

		inc bl
		mov dl, 0
		mov dh, bl
		call gotoxy

		mov eax, 20
		call delay

	LOOP verticalFrame

	ret
DrawFrame4 endP

randomGhostMovement4 PROC

	mov eax, black + (black * 16)
	call SetTextColor

	mov dl, xPosGhost
	mov dh, yPosGhost
	call GoToXY

	mov al, ' '
	call writeChar

	mov eax, 131
	call randomRange
	inc eax
	mov xPosGhost, al
	
	mov eax, 25
	call randomRange
	add eax, 3
	mov yPosGhost, al
	
	mov al, xPosSB
	cmp xPosGhost, al
	jne next
	
	mov al, yPosSB
	cmp yPosGhost, al
	je Skip

	Next:
		call drawGhost
	
	Skip:
		ret
randomGhostMovement4 endp

; -------------
;  User Info 4
; -------------

DisplayUserInfo4 PROC

	mov eax, white + (black * 16)
	call SetTextColor

	; Score
	mov dl, 0
	mov dh, 0
	call Gotoxy

	mov edx, OFFSET strScore
	call WriteString

	mov eax, score
	call WriteDec

	; Lives
	mov dl, 0
	mov dh, 1
	call Gotoxy

	mov edx, OFFSET strLives
	call WriteString
	
	mov eax,lives
	call WriteDec

	; Level 
	mov eax, yellow + (black * 16)
	call SetTextColor

	mov dl, 125
	mov dh, 1
	call Gotoxy

	mov edx, OFFSET strLevel4
	call WriteString

	ret
DisplayUserInfo4 endP

checkCollision4 PROC

	mov al, xPos
	mov bl, yPos

	; Horizontal Check
	cmp al, xPosGhost
	jne Skip

	; Verticle Check
	cmp bl, yPosGhost
	jne Skip

	; Collision Detected
	; Remove Player and Ghost from Current Position
	mov eax, black + (black * 16)
	call SetTextColor
	
	mov dl, xPosGhost
	mov dh, yPosGhost
	call GoToXY

	mov al, ' '
	call writeChar
	
	mov dl, xPos
	mov dh, yPos
	call GoToXY

	mov al, ' '
	call writeChar

	; Reset Player and Ghost
	mov xPos, 2
	mov yPos, 27
	mov xPosGhost, 127
	mov yPosGhost, 8
	call updateGhost
	dec lives

	Skip:

	ret
checkCollision4 endP

; ---------
;  Level 2
; ---------

Level2 PROC

	call clrscr
	mov lives, 3
	mov xPos, 3
	mov yPos, 25
	mov currGhostX, 22
	mov currGhostY, 8
	mov xPosGhost, 22
	mov yPosGhost, 8

	; Gameplay
	call DrawFrame2
	call DrawPlayer
	call DrawGhost
	call DrawPinky
	call Randomize

	gameLoop:

		; Bonuses
		; Score Bonus
		cmp isScoreSpawned, 1
		je CheckScoreCollection
		call ScoreBonus
		jmp GEskip

		CheckScoreCollection:
			call checkScoreCollision
			
		; Ghost Eater
		GEskip:
		cmp isGhostEaterSpawned, 1
		je CheckGhostEaterCollection
		call GhostEaterBonus
		jmp SkipSpawn

		CheckGhostEaterCollection:
			call checkGhostEaterBonusCollision

		SkipSpawn:
		; Check Level Completion
		call Level2Complete
		cmp bl, 1
		je exitGame

		; Scoring
		call coinCollection21
		call coinCollection22

		mov eax, white (black * 16)
		call SetTextColor

		call DisplayUserInfo2

		; get user key input:
		call ReadChar
		mov inputChar, al

		; exit game if user types 'x':
		cmp inputChar, 'x'
		je exitGame

		; Pause if 'P' is Pressed
		cmp inputChar, 'p'
		jne unPaused
		call PauseGame
		jmp GameLoop

		unPaused:

			; Move Player
			cmp inputChar,"w"
			je moveUp

			cmp inputChar,"s"
			je moveDown

			cmp inputChar,"a"
			je moveLeft

			cmp inputChar,"d"
			je moveRight

		moveUp:
			call UpdatePlayer
			dec yPos
			call checkWallU

			; Border
			mov al, 2
			cmp yPos, al
			jg Skip1
			inc yPos

			Skip1:
				; Collision Detection
				cmp isGEeaten, 0
				je notEaten

				; Ghost has been Eaten
				inc yPos
				call GEPlayerGhostCollision
				call GEPlayerPinkyCollision
				dec yPos
				dec GEsteps
		
				cmp GEsteps, 0
				jne notEaten
				mov isGEeaten, 0

				NotEaten:
					inc yPos
					call checkCollision2
					call checkCollisionPinky
					dec yPos
					cmp bl, 1
					jne Next
					call DrawGhost
					call DrawPinky
				
				Next:
				; Game Over
				cmp lives, 0
				jne Skipp
				call GameOver
				call ReadChar
				jmp exitGame

				Skipp:
					; Move Ghost
					call moveLinearGhost2
					call movePinky

				call DrawPlayer
				mov eax, 20
				call delay
		jmp gameLoop

		moveDown:
			call UpdatePlayer
			inc yPos
			call checkWallD
			
			; Border
			mov al, 29
			cmp yPos, al
			jl Skip2
			dec yPos

			Skip2:
				; Collision Detection
				cmp isGEeaten, 0
				je notEaten2

				; Ghost has been Eaten
				dec yPos
				call GEPlayerGhostCollision
				call GEPlayerPinkyCollision
				inc yPos
				dec GEsteps
		
				cmp GEsteps, 0
				jne notEaten2
				mov isGEeaten, 0

				NotEaten2:
				dec yPos
				call checkCollision2
				call checkCollisionPinky
				inc yPos
				cmp bl, 1
				cmp bl, 1
				jne Next2
				call DrawGhost
				call DrawPinky	
				
				Next2:
				; Game Over
				cmp lives, 0
				jne Skippp
				call GameOver
				call ReadChar
				jmp exitGame
				
				Skippp:
					; Move Ghost
					call moveLinearGhost2
					call movePinky

				call DrawPlayer
				mov eax, 20
				call delay
			jmp gameLoop

		moveLeft:
			call UpdatePlayer
			dec xPos
			call checkWallL
			
			; Border
			mov al, 0
			cmp xPos, al
			ja Skip3
			inc xPos

			Skip3:
				; Collision Detection
				cmp isGEeaten, 0
				je notEaten3

				; Ghost has been Eaten
				inc xPos
				call GEPlayerGhostCollision
				call GEPlayerPinkyCollision
				dec xPos
				dec GEsteps
		
				cmp GEsteps, 0
				jne notEaten3
				mov isGEeaten, 0

				NotEaten3:
				inc xPos
				call checkCollision2
				call checkCollisionPinky
				dec xPos
				cmp bl, 1
				jne Next3
				call DrawGhost
				call DrawPinky
				
				Next3:
				; Game Over
				cmp lives, 0
				jne Skipppp
				call GameOver
				call ReadChar
				jmp exitGame
				
				Skipppp:
					; Move Ghost
					call moveLinearGhost2
					call movePinky

				call DrawPlayer
				mov eax, 15
				call delay
		jmp gameLoop

		moveRight:
			call UpdatePlayer
			inc xPos
			call checkWallR
			
			; Border
			mov al, 132
			cmp xPos, al
			jb Skip4
			dec xPos

			Skip4:
				cmp isGEeaten, 0
				je notEaten4

				; Ghost has been Eaten
				dec xPos
				call GEPlayerGhostCollision
				call GEPlayerPinkyCollision
				inc xPos
				dec GEsteps
		
				cmp GEsteps, 0
				jne notEaten4
				mov isGEeaten, 0

				NotEaten4:
				dec xPos
				call checkCollision2
				call checkCollisionPinky
				inc xPos
				cmp bl, 1
				jne Next4
				call DrawGhost
				call DrawPinky
				
				Next4:
				; Game Over
				cmp lives, 0
				jne Skippppp
				call GameOver
				call ReadChar
				jmp exitGame
				
				Skippppp:
					; Move Ghost
					call moveLinearGhost2
					call movePinky

				call DrawPlayer
				mov eax, 15
				call delay
		jmp gameLoop

	exitGame:

	ret
Level2 endp


; --------------------
;  Level 2 Completion 
; --------------------

level2Complete PROC
	
	cmp l2Score, 150
	jae JUMP	

	; Check for Completion
	mov bl, 0
	cmp score, 100
	jb inComplete

	; Check if all Coins has been eaten

	mov esi, offset horizontalCoinLayout2
	mov ecx, 383

	L2:
		mov al, 0
		cmp [esi], al
		je Next2
		jmp incomplete
		Next2:
		inc esi
		LOOP L2

	mov esi, offset verticleCoinLayout2
	mov ecx, 36

	L1:
		mov al, 0
		cmp [esi], al
		je Next
		jmp incomplete
		Next:
		inc esi
		LOOP L1

	; Level has been Completed
	JUMP:
	call clrscr
	mov bl, 1

	mov eax, green + (black * 16)
	call SetTextColor

	mov dl, 58
	mov dh, 13
	call GoToxy
	
	mov edx, OFFSET strLevel2Complete
	call WriteString

	mov dl, 57
	mov dh, 14
	call GoToxy

	mov eax, lightGray + (black * 16)
	call SetTextColor
	
	mov edx, OFFSET strResume
	call WriteString

	Level3jmp:
		call readChar
		cmp al, 'r'
		jne Level3jmp
	

	inComplete:

	ret
Level2Complete endP


; -------
;  Coins
; -------

coinCollection21 PROC

	mov esi, offset verticleCoinLayout2
	mov eax, 0
	mov ebx, 0
	mov al, xPos
	mov bl, yPos
	
	; Check y-Coordinate
	mov dl, 24
	cmp bl, dl
	jg Skip

	mov dl, 9
	cmp bl, dl
	jl Skip

	; Check x-Coordinate
	mov dl, 25
	cmp al, dl
	je Col1

	mov dl, 31
	cmp al, dl
	je Col2

	mov dl, 102
	cmp al, dl
	je Col3
	
	mov dl, 108
	cmp al, dl
	je Col4
	jmp Skip

	; First Verticle Line
	Col1:
		SUB bl, 12
		ADD esi, ebx
		mov dl, 0
		cmp BYTE PTR [esi], dl
		je Skip

		; Increment Score
		mov edx, 0
		mov [esi], edx
		inc score
		inc l2Score
		jmp Skip

	Col2:
		SUB bl, 12
		ADD esi, 11
		ADD esi, ebx
		mov dl, 0
		cmp BYTE PTR [esi], dl
		je Skip

		; Increment Score
		mov edx, 0
		mov [esi], edx
		inc score
		inc l2Score
		jmp Skip

	Col3:
		SUB bl, 12
		ADD esi, 14
		ADD esi, ebx
		mov dl, 0
		cmp BYTE PTR [esi], dl
		je Skip

		; Increment Score
		mov edx, 0
		mov [esi], edx
		inc score
		inc l2Score
		jmp Skip

	Col4:
		SUB bl, 12
		ADD esi, 21
		ADD esi, ebx
		mov dl, 0
		cmp BYTE PTR [esi], dl
		je Skip

		; Increment Score
		mov edx, 0
		mov [esi], edx
		inc score
		inc l2Score

	Skip:

	ret
coinCollection21 endp

coinCollection22 PROC

	mov esi, offset horizontalCoinLayout2
	add esi, 166
	mov edx, 0
	mov [esi], dl

	mov esi, offset horizontalCoinLayout2
	mov eax, 0
	mov ebx, 0
	mov al, xPos
	mov bl, yPos

	; Check x-Coordinate
	mov dl, 25
	cmp al, dl
	jl Skip

	mov dl, 108
	cmp al, dl
	jg Skip
	
	; Check y-Coordinate
	mov dl, 8
	cmp bl, dl
	je Row1

	mov dl, 12
	cmp bl, dl
	je Row2

	mov dl, 16
	cmp bl, dl
	je Row3

	mov dl, 20
	cmp bl, dl
	je Row4

	mov dl, 24
	cmp bl, dl
	je Row5

	jmp Skip

	; First Horzontal Line
	Row1:
		SUB al, 25
		ADD esi, eax
		mov dl, 0
		cmp BYTE PTR [esi], dl
		je Skip

		; Increment Score
		mov edx, 0
		mov [esi], edx
		inc score
		inc l2Score
		jmp Skip

	Row2:
		SUB al, 25
		ADD esi, 84
		ADD esi, eax
		mov dl, 0
		cmp BYTE PTR [esi], dl
		je Skip

		; Increment Score
		mov edx, 0
		mov [esi], edx
		inc score
		inc l2Score
		jmp Skip

	Row3:
		SUB al, 25
		ADD esi, 162
		ADD esi, eax
		mov dl, 0
		cmp BYTE PTR [esi], dl
		je Skip

		; Increment Score
		mov edx, 0
		mov [esi], edx
		inc score
		inc l2Score
		jmp Skip

	Row4:
		SUB al, 25
		ADD esi, 227
		ADD esi, eax
		mov dl, 0
		cmp BYTE PTR [esi], dl
		je Skip

		; Increment Score
		mov edx, 0
		mov [esi], edx
		inc score
		inc l2Score
		jmp Skip

	Row5:
		SUB al, 25
		ADD esi, 299
		ADD esi, eax
		mov dl, 0
		cmp BYTE PTR [esi], dl
		je Skip

		; Increment Score
		mov edx, 0
		mov [esi], edx
		inc score
		inc l2Score
		jmp Skip

	Skip:

	ret
coinCollection22 endp

GhostCoinInteraction21 PROC

	mov esi, offset verticleCoinLayout2
	mov eax, 0
	mov ebx, 0
	mov al, xPosGhost
	mov bl, yPosGhost
	
	; Check y-Coordinate
	mov dl, 24
	cmp bl, dl
	jg Skip

	mov dl, 8
	cmp bl, dl
	jl Skip

	; Check x-Coordinate
	mov dl, 25
	cmp al, dl
	je Col1

	mov dl, 31
	cmp al, dl
	je Col2

	mov dl, 102
	cmp al, dl
	je Col3
	
	mov dl, 108
	cmp al, dl
	je Col4
	jmp Skip

	; First Verticle Line
	Col1:
		SUB bl, 8
		ADD esi, ebx
		mov dl, 0
		cmp BYTE PTR [esi], dl
		je Skip

		; Dont Remove Coin
		mov eax, yellow + (black * 16)
		call SetTextColor

		mov dl, xPosGhost
		mov dh, yPosGhost
		call Gotoxy

		mov al, dot
		call WriteChar
		jmp Skip

	Col2:
		SUB bl, 8
		ADD esi, 11
		ADD esi, ebx
		mov dl, 0
		cmp BYTE PTR [esi], dl
		je Skip

		
		; Dont Remove Coin
		mov eax, yellow + (black * 16)
		call SetTextColor

		mov dl, xPosGhost
		mov dh, yPosGhost
		call Gotoxy

		mov al, dot
		call WriteChar
		jmp Skip

	Col3:
		SUB bl, 8
		ADD esi, 14
		ADD esi, ebx
		mov dl, 0
		cmp BYTE PTR [esi], dl
		je Skip

		
		; Dont Remove Coin
		mov eax, yellow + (black * 16)
		call SetTextColor

		mov dl, xPosGhost
		mov dh, yPosGhost
		call Gotoxy

		mov al, dot
		call WriteChar
		jmp Skip

	Col4:
		SUB bl, 8
		ADD esi, 20
		ADD esi, ebx
		mov dl, 0
		cmp BYTE PTR [esi], dl
		je Skip

		; Dont Remove Coin
		mov eax, yellow + (black * 16)
		call SetTextColor

		mov dl, xPosGhost
		mov dh, yPosGhost
		call Gotoxy

		mov al, dot
		call WriteChar

	Skip:

	ret
GhostCoinInteraction21 endp

GhostCoinInteraction22 PROC

	mov esi, offset horizontalCoinLayout2
	mov eax, 0
	mov ebx, 0
	mov al, xPosGhost
	mov bl, yPosGhost

	; Check x-Coordinate
	mov dl, 25
	cmp al, dl
	jl Skip

	mov dl, 108
	cmp al, dl
	jg Skip
	
	; Check y-Coordinate
	mov dl, 8
	cmp bl, dl
	je Row1

	mov dl, 12
	cmp bl, dl
	je Row2

	mov dl, 16
	cmp bl, dl
	je Row3

	mov dl, 20
	cmp bl, dl
	je Row4

	mov dl, 24
	cmp bl, dl
	je Row5

	jmp Skip

	; First Horzontal Line
	Row1:
		SUB al, 25
		ADD esi, eax
		mov dl, 0
		cmp BYTE PTR [esi], dl
		je Skip

		; Dont Remove Coin
		mov eax, yellow + (black * 16)
		call SetTextColor

		mov dl, xPosGhost
		mov dh, yPosGhost
		call Gotoxy

		mov al, dot
		call WriteChar
		jmp Skip

	Row2:
		SUB al, 25
		ADD esi, 84
		ADD esi, eax
		mov dl, 0
		cmp BYTE PTR [esi], dl
		je Skip

		
		; Dont Remove Coin
		mov eax, yellow + (black * 16)
		call SetTextColor

		mov dl, xPosGhost
		mov dh, yPosGhost
		call Gotoxy

		mov al, dot
		call WriteChar
		jmp Skip

	Row3:
		SUB al, 25
		ADD esi, 162
		ADD esi, eax
		mov dl, 0
		cmp BYTE PTR [esi], dl
		je Skip

		
		; Dont Remove Coin
		mov eax, yellow + (black * 16)
		call SetTextColor

		mov dl, xPosGhost
		mov dh, yPosGhost
		call Gotoxy

		mov al, dot
		call WriteChar
		jmp Skip

	Row4:
		SUB al, 25
		ADD esi, 227
		ADD esi, eax
		mov dl, 0
		cmp BYTE PTR [esi], dl
		je Skip

		
		; Dont Remove Coin
		mov eax, yellow + (black * 16)
		call SetTextColor

		mov dl, xPosGhost
		mov dh, yPosGhost
		call Gotoxy

		mov al, dot
		call WriteChar
		jmp Skip

	Row5:
		SUB al, 25
		ADD esi, 299
		ADD esi, eax
		mov dl, 0
		cmp BYTE PTR [esi], dl
		je Skip

		
		; Dont Remove Coin
		mov eax, yellow + (black * 16)
		call SetTextColor

		mov dl, xPosGhost
		mov dh, yPosGhost
		call Gotoxy

		mov al, dot
		call WriteChar
		jmp Skip

	Skip:

	ret
GhostCoinInteraction22 endp


; -----------------
;  Player Movement
; -----------------

checkWallR PROC

	cmp xPos, 22
	jne Wall2
	
	cmp yPos, 6
	je C1

	cmp yPos, 6
	jb Wall2
	
	cmp yPos, 10
	jb Wall2

	cmp yPos, 26
	ja Wall2

	C1:
		dec xPos
		jmp Skip

	Wall2:
		cmp xPos, 27
		jne Wall3

		cmp yPos, 14
		jb Wall3

		cmp yPos, 22
		ja Wall3

		C2:
			dec xPos
			jmp Skip


	Wall3:
		cmp xPos, 99
		jne Wall4

		cmp yPos, 14
		jb Wall4

		cmp yPos, 18
		ja Wall4

		C3:
			dec xPos
			jmp Skip

	Wall4:
		cmp xPos, 105
		jne Wall5

		cmp yPos, 10
		jb Wall5

		cmp yPos, 22
		ja Wall5

		C4:
			dec xPos
			jmp Skip

	Wall5:
		cmp xPos, 111
		jne Skip

		cmp yPos, 6
		jb Skip

		cmp yPos, 26
		ja Skip

		C5:
			dec xPos

	Skip:

	ret
checkWallR endp

checkWallL PROC

	cmp xPos, 22
	jne Wall2
	
	cmp yPos, 6
	je C1

	cmp yPos, 6
	jb Wall2
	
	cmp yPos, 10
	jb Wall2

	cmp yPos, 26
	ja Wall2

	C1:
		inc xPos
		jmp Skip

	Wall2:
		cmp xPos, 28
		jne Wall3

		cmp yPos, 14
		jb Wall3

		cmp yPos, 22
		ja Wall3

		C2:
			inc xPos
			jmp Skip


	Wall3:
		cmp xPos, 99
		jne Wall4

		cmp yPos, 14
		jb Wall4

		cmp yPos, 18
		ja Wall4

		C3:
			inc xPos
			jmp Skip

	Wall4:
		cmp xPos, 105
		jne Wall5

		cmp yPos, 10
		jb Wall5

		cmp yPos, 22
		ja Wall5

		C4:
			inc xPos
			jmp Skip

	Wall5:
		cmp xPos, 111
		jne Skip

		cmp yPos, 6
		jb Skip

		cmp yPos, 26
		ja Skip

		C5:
			inc xPos

	Skip:

	ret
checkWallL endp

checkWallU PROC

	cmp yPos, 6
	jne Wall2

	cmp xPos, 22
	jb Wall2
	
	cmp xPos, 110
	ja Wall2

	C1:
		inc yPos
		jmp Skip

	Wall2:
		cmp yPos, 10
		jne Wall3

		cmp xPos, 22
		jb Wall3

		cmp xPos, 105
		ja Wall3

		C2:
			inc yPos
			jmp Skip


	Wall3:
		cmp yPos, 14
		jne Wall4

		cmp xPos, 28
		jb Wall4

		cmp xPos, 99
		ja Wall4

		C3:
			inc yPos
			jmp Skip

	Wall4:
		cmp yPos, 18
		jne Wall5

		cmp xPos, 34
		jb Wall5

		cmp xPos, 99
		ja Wall5

		C4:
			inc yPos
			jmp Skip

	Wall5:
		cmp yPos, 22
		jne wall6

		cmp xPos, 28
		jb wall6

		cmp xPos, 105
		ja wall6

		C5:
			inc yPos
			jmp Skip

	Wall6:
		cmp yPos, 26
		jne Skip

		cmp xPos, 22
		jb Skip

		cmp xPos, 111
		ja Skip

		C6:
			inc yPos

	Skip:

	ret
checkWallU endp

checkWallD PROC

	cmp yPos, 6
	jne Wall2

	cmp xPos, 22
	jb Wall2
	
	cmp xPos, 110
	ja Wall2

	C1:
		dec yPos
		jmp Skip

	Wall2:
		cmp yPos, 10
		jne Wall3

		cmp xPos, 22
		jb Wall3

		cmp xPos, 105
		ja Wall3

		C2:
			dec yPos
			jmp Skip


	Wall3:
		cmp yPos, 14
		jne Wall4

		cmp xPos, 28
		jb Wall4

		cmp xPos, 99
		ja Wall4

		C3:
			dec yPos
			jmp Skip

	Wall4:
		cmp yPos, 18
		jne Wall5

		cmp xPos, 34
		jb Wall5

		cmp xPos, 99
		ja Wall5

		C4:
			dec yPos
			jmp Skip

	Wall5:
		cmp yPos, 22
		jne wall6

		cmp xPos, 28
		jb wall6

		cmp xPos, 105
		ja wall6

		C5:
			dec yPos
			jmp Skip

	Wall6:
		cmp yPos, 26
		jne Skip

		cmp xPos, 22
		jb Skip

		cmp xPos, 111
		ja Skip

		C6:
			dec yPos

	Skip:

	ret
checkWallD endp

; ------------
;  User Info2
; ------------

DisplayUserInfo2 PROC

	; Score
	mov dl, 0
	mov dh, 0
	call Gotoxy

	mov edx, OFFSET strScore
	call WriteString

	mov eax,score
	call WriteDec

	; Lives
	mov dl, 0
	mov dh, 1
	call Gotoxy

	mov edx, OFFSET strLives
	call WriteString
	
	mov eax,lives
	call WriteDec

	; Level 
	mov eax, yellow + (black * 16)
	call SetTextColor

	mov dl, 125
	mov dh, 1
	call Gotoxy

	mov edx, OFFSET strLevel2
	call WriteString

	ret
DisplayUserInfo2 endP


; --------
;  Frame2
; --------

DrawFrame2 PROC

	mov eax, blue + (black * 16)
	call SetTextColor

	; Horizontal Borders
	mov dl, 0
	mov dh, 2
	call gotoxy
	mov edx, OFFSET ground
	call WriteString
	 
	mov dl, 0
	mov dh, 29
	call Gotoxy
	
	mov edx, OFFSET ground
	call WriteString

	; Verticle Borders
	mov bl, 3
	mov ecx, 26
	mov dl, 0
	mov dh, bl
	call gotoxy

	verticalFrame:
		mov edx, offset vFrameElement
		call WriteString

		mov dl, 132
		mov dh, bl
		call gotoxy

		mov edx, offset vFrameElement
		call WriteString

		inc bl
		mov dl, 0
		mov dh, bl
		call gotoxy

		mov eax, 20
		call delay

	LOOP verticalFrame

	; Maze
	; Horizontal Lines
	mov dl, 22
	mov dh, 6
	call gotoxy

	mov edx, offset l2h1
	call writeString

	mov dl, 22
	mov dh, 26
	call gotoxy

	mov edx, offset l2h1
	call writeString
	
	mov dl, 22
	mov dh, 10
	call gotoxy

	mov edx, offset l2h2
	call writeString

	mov dl, 28
	mov dh, 14
	call gotoxy

	mov edx, offset l2h4
	call writeString
	
	mov dl, 34
	mov dh, 18
	call gotoxy

	mov edx, offset l2h5
	call writeString

	mov dl, 28
	mov dh, 22
	call gotoxy

	mov edx, offset l2h3
	call writeString
	
	
	; Vertical Lines
	mov ecx, 19
	mov bl, 7
	mov dl, 111
	mov dh, bl
	call GoToXY

	L1:
		mov al, '|'
		call writeChar

		inc bl
		mov dl, 111
		mov dh, bl
		call GoToXY

		mov eax, 20
		call delay

		LOOP L1
		
	mov ecx, 15
	mov bl, 11
	mov dl, 22
	mov dh, bl
	call GoToXY

	L2:
		mov al, '|'
		call writeChar

		inc bl
		mov dl, 22
		mov dh, bl
		call GoToXY

		mov eax, 20
		call delay

		LOOP L2
		
	mov ecx, 7
	mov bl, 15
	mov dl, 28
	mov dh, bl
	call GoToXY

	L3:
		mov al, '|'
		call writeChar

		inc bl
		mov dl, 28
		mov dh, bl
		call GoToXY

		mov eax, 20
		call delay

		LOOP L3
		
	mov ecx, 11
	mov bl, 11
	mov dl, 105
	mov dh, bl
	call GoToXY

	L4:
		mov al, '|'
		call writeChar

		inc bl
		mov dl, 105
		mov dh, bl
		call GoToXY

		mov eax, 20
		call delay

		LOOP L4
		
	mov ecx, 3
	mov bl, 15
	mov dl, 99
	mov dh, bl
	call GoToXY

	L5:
		mov al, '|'
		call writeChar

		inc bl
		mov dl, 99
		mov dh, bl
		call GoToXY

		mov eax, 20
		call delay

		LOOP L5
	
	; Coins
	; Horizontal Coins
	mov eax, yellow + (black * 16)
	call SetTextColor
	
	mov dl, 25
	mov dh, 8
	call gotoxy

	mov edx, offset coins84
	call WriteString

	mov dl, 25
	mov dh, 12
	call gotoxy

	mov edx, offset coins78
	call WriteString

	mov dl, 31
	mov dh, 20
	call gotoxy

	mov edx, offset coins72
	call WriteString

	mov dl, 31
	mov dh, 16
	call gotoxy

	mov edx, offset coins65
	call WriteString

	mov dl, 25
	mov dh, 24
	call gotoxy

	mov edx, offset coins84
	call WriteString


	; Verticle Coins
	mov ecx, 15
	mov dl, 108
	mov dh, 9
	mov bl, 9
	call gotoxy

	V1:
		mov edx, offset dot
		call WriteString

		inc bl
		mov dl, 108
		mov dh, bl
		call gotoxy

		mov eax, 20
		call delay

	LOOP V1
	
	mov ecx, 11
	mov dl, 25
	mov dh, 13
	mov bl, 13
	call gotoxy

	V2:
		mov edx, offset dot
		call WriteString

		inc bl
		mov dl, 25
		mov dh, bl
		call gotoxy

		mov eax, 20
		call delay

	LOOP V2
	
	mov ecx, 7
	mov dl, 102
	mov dh, 13
	mov bl, 13
	call GoToXY

	V3:
		mov edx, offset dot
		call WriteString

		inc bl
		mov dl, 102
		mov dh, bl
		call gotoxy

		mov eax, 20
		call delay

	LOOP V3

	mov ecx, 3
	mov dl, 31
	mov dh, 17
	mov bl, 17
	call GoToXY

	V4:
		mov edx, offset dot
		call WriteString

		inc bl
		mov dl, 31
		mov dh, bl
		call gotoxy

		mov eax, 20
		call delay

	LOOP V4
	
	ret
DrawFrame2 endP


; -------------
;  Score Bonus
; -------------

scoreBonus PROC

	cmp isScoreSpawned, 1
	je Skip

	; 1/300 chance for Score Spawn
	mov eax, 300
    inc eax
    call RandomRange

	cmp al, 1
	jne Skip

	; Choose random y-coordinate
	Again1:
		mov eax, 25
		call RandomRange
		Add eax, 4

	cmp al, 6
	je Again1

	cmp al, 10
	je Again1

	cmp al, 14
	je Again1

	cmp al, 18
	je Again1

	cmp al, 22
	je Again1

	cmp al, 8
	je Again1

	cmp al, 12
	je Again1

	cmp al, 16
	je Again1

	cmp al, 20
	je Again1

	cmp al, 24
	je Again1

	cmp al, 26
	je Again1

	mov yPosSB, al
		
	; Choose random x-coordinate
	Again2:
		mov eax, 127
		call RandomRange
		inc eax

	cmp al, 22
	je Again2

	cmp al, 28
	je Again2

	cmp al, 105
	je Again2

	cmp al, 111
	je Again2

	cmp al, 99
	je Again2

	cmp al, 25
	je Again2

	cmp al, 31
	je Again2

	cmp al, 108
	je Again2

	cmp al, 102
	je Again2
	
	mov xPosSB, al

	; Spawn Score Bonus
	mov isScoreSpawned, 1

	mov dl, xPosSB
	mov dh, yPosSB
	call GoToXY

	mov eax, black + (yellow * 16)
	call SetTextColor

	mov al, '$'
	call writeChar

	Skip:


	ret
scoreBonus endP

checkScoreCollision PROC

	mov al, xPosSB
	cmp xPos, al
	jne Skip

	mov al, yPosSB
	cmp yPos, al
	jne Skip

	; Bonus Acheived
	Add score, 20
	mov	isScoreSpawned, 0

	Skip:

	ret
checkScoreCollision endP


; -------------------
;  Ghost Eater Bonus
; -------------------

ghostEaterBonus PROC

	cmp isGhostEaterSpawned, 1
	je Skip

	; 1/300 chance for Ghost Eater Spawn
	mov eax, 300
    inc eax
    call RandomRange

	cmp al, 1
	jne Skip

	; Choose random y-coordinate
	Again1:
		mov eax, 25
		call RandomRange
		Add eax, 4

	cmp al, 6
	je Again1

	cmp al, 10
	je Again1

	cmp al, 14
	je Again1

	cmp al, 18
	je Again1

	cmp al, 22
	je Again1

	cmp al, 8
	je Again1

	cmp al, 12
	je Again1

	cmp al, 16
	je Again1

	cmp al, 20
	je Again1

	cmp al, 24
	je Again1

	cmp al, 26
	je Again1

	mov yPosGE, al
		
	; Choose random x-coordinate
	Again2:
		mov eax, 127
		call RandomRange
		inc eax

	cmp al, 22
	je Again2

	cmp al, 28
	je Again2

	cmp al, 105
	je Again2

	cmp al, 111
	je Again2

	cmp al, 99
	je Again2

	cmp al, 24
	je Again2

	cmp al, 30
	je Again2

	cmp al, 107
	je Again2

	cmp al, 101
	je Again2
	
	mov xPosGE, al

	; Spawn Ghost Eater Bonus
	mov isGhostEaterSpawned, 1

	mov dl, xPosGE
	mov dh, yPosGE
	call GoToXY

	mov eax, black + (cyan * 16)
	call SetTextColor

	mov al, '%'
	call writeChar

	Skip:


	ret
ghostEaterBonus endP

checkGhostEaterBonusCollision PROC

	mov al, xPosGE
	cmp xPos, al
	jne Skip

	mov al, yPosGE
	cmp yPos, al
	jne Skip

	; Bonus Acheived
	mov	isGhostEaterSpawned, 0
	mov isGEeaten, 1
	mov GEsteps, 255

	Skip:

	ret
checkGhostEaterBonusCollision endP

GEPlayerGhostCollision PROC

	; Horizontal Check
	mov al, xPos
	mov bl, yPos

	cmp al, xPosGhost
	je Next

	inc al
	cmp al, xPosGhost
	je Next

	dec al
	dec al
	cmp al, xPosGhost
	je Next
	jmp Verticle

	Next:
		cmp bl, yPosGhost
		je CollisionDetected

	; Verticle Check
	Verticle:
	mov al, xPos
	mov bl, yPos

	cmp bl, yPosGhost
	je Next2

	inc bl
	cmp bl, yPosGhost
	je Next2

	dec bl
	dec bl
	cmp bl, yPosGhost
	je Next2
	jmp Skip

	Next2:
		cmp al, xPosGhost
		je CollisionDetected
		jmp Skip

	; Collision
	CollisionDetected:
	
	; Reset Ghost
	call updateGhost2
	mov al, currGhostX
	mov cl, currGhostY
	mov xPosGhost, al
	mov yPosGhost, cl
	Add Score, 20

	Skip:

	ret
GEPlayerGhostCollision endP

GEPlayerPinkyCollision PROC

	; Horizontal Check
	mov al, xPos
	mov bl, yPos

	cmp al, xPosPinky
	je Next

	inc al
	cmp al, xPosPinky
	je Next

	dec al
	dec al
	cmp al, xPosPinky
	je Next
	jmp Verticle

	Next:
		cmp bl, yPosPinky
		je CollisionDetected

	; Verticle Check
	Verticle:
	mov al, xPos
	mov bl, yPos

	cmp bl, yPosPinky
	je Next2

	inc bl
	cmp bl, yPosPinky
	je Next2

	dec bl
	dec bl
	cmp bl, yPosPinky
	je Next2
	jmp Skip

	Next2:
		cmp al, xPosPinky
		je CollisionDetected
		jmp Skip

	; Collision
	CollisionDetected:
	
	; Reset Ghost
	call updatePinky
	mov xPosPinky, 127
	mov yPosPinky, 8
	Add Score, 20

	Skip:

	ret
GEPlayerPinkyCollision endP


; ------------
;  Collision
; ------------

checkCollision2 PROC

	mov al, xPos
	mov bl, yPos

	; Horizontal Check
	cmp al, xPosGhost
	jne Skip

	; Verticle Check
	cmp bl, yPosGhost
	jne Skip

	; Collision Detected
	mov bl, 1
	
	; Remove Player and Ghost from Current Position
	mov eax, black + (black * 16)
	call SetTextColor
	
	mov dl, xPosGhost
	mov dh, yPosGhost
	call GoToXY

	mov al, ' '
	call writeChar
	
	mov dl, xPos
	mov dh, yPos
	call GoToXY

	mov al, ' '
	call writeChar

	; Reset Player and Ghost
	mov xPos, 2
	mov yPos, 27
	mov al, currGhostX
	mov cl, currGhostY
	mov xPosGhost, al
	mov yPosGhost, cl
	call updateGhost2
	dec lives

	Skip:

	ret
checkCollision2 endP

checkCollisionPinky PROC

	mov al, xPos
	mov bl, yPos

	; Horizontal Check
	cmp al, xPosPinky
	jne Skip

	; Verticle Check
	cmp bl, yPosPinky
	jne Skip

	; Collision Detected
	mov bl, 1
	
	; Remove Player and Ghost from Current Position
	mov eax, black + (black * 16)
	call SetTextColor
	
	mov dl, xPosPinky
	mov dh, yPosPinky
	call GoToXY

	mov al, ' '
	call writeChar
	
	mov dl, xPos
	mov dh, yPos
	call GoToXY

	mov al, ' '
	call writeChar

	; Reset Player and Pinky
	mov xPos, 2
	mov yPos, 27
	mov xPosPinky, 127
	mov yPosPinky, 8
	call updatePinky
	dec lives

	Skip:

	ret
checkCollisionPinky endP


; -------
;  Ghost
; -------


UpdateGhost2 PROC

	mov dl, xPosGhost
	mov dh, yPosGhost
	call Gotoxy
	
	mov al, " "
	call WriteChar
	call GhostCoinInteraction21
	call GhostCoinInteraction22
	
	ret
UpdateGhost2 ENDP

moveLinearGhost2 PROC

	; Right
	cmp yPosGhost, 8
	jne Down

	cmp xPosGhost, 108
	je Down
	
	call updateGhost2
	inc xPosGhost
	jmp Next

	Down:
		cmp xPosGhost, 25
		je Up

		cmp yPosGhost, 24
		je Left

		cmp xPosGhost, 102
		jbe Right2

		cmp yPosGhost, 12
		je temp1

		
		temp1:
		call updateGhost2
		inc yPosGhost
		jmp Next

	Left:
		cmp xPosGhost, 25
		je Up
		
		call updateGhost2
		dec xPosGhost
		jmp Next

	Up:
		cmp yPosGhost, 12
		je Right2

		call UpdateGhost2
		dec yPosGhost
		jmp Next

	Right2:
		cmp xPosGhost, 102
		je Down2

		cmp yPosGhost, 12
		je temp2

		cmp yPosGhost, 20
		jbe Left2

		temp2:
		call UpdateGhost2
		inc xPosGhost
		jmp Next

	Down2:
		cmp yPosGhost, 20
		je Left2

		call UpdateGhost2
		inc yPosGhost
		jmp Next

	Left2:
		cmp xPosGhost, 31
		je Up2

		cmp yPosGhost, 16
		je Right3

		call UpdateGhost2
		dec xPosGhost
		jmp Next

	Up2:
		cmp yPosGhost, 16
		je Right3

		call UpdateGhost2
		dec yPosGhost
		jmp Next

	Right3:
		cmp xPosGhost, 97
		jne temp3

		; Reset Ghost Position
		call UpdateGhost2
		mov xPosGhost, 22
		mov yPosGhost, 8
		jmp Next

		temp3:
			call UpdateGhost2
			inc xPosGhost
			jmp Next

	Next:
		call DrawGhost

	ret
moveLinearGhost2 endP


; --------
;  Pinky
; --------

DrawPinky PROC

	mov eax, black + (lightMagenta * 16)
	call SetTextColor

	; draw Ghost at (xPos,yPos):
	mov dl, xPosPinky
	mov dh, yPosPinky
	call Gotoxy

	mov al, Pinky
	call WriteChar

	mov eax, black + (black * 16)
	call SetTextColor
	
	ret
DrawPinky ENDP


UpdatePinky PROC

	mov eax, black + (black * 16)
	call SetTextColor

	mov dl, xPosPinky
	mov dh, yPosPinky
	call Gotoxy
	
	mov al, " "
	call WriteChar
	
	ret
UpdatePinky ENDP

movePinky PROC

	randomMovement:
	call randomize
    mov eax, 5
    call RandomRange
    inc eax
    
	; Up
	cmp al, 1
	jne Next1
	
	cmp yPosPinky, 3
	je randomMovement
	
	cmp yPosPinky, 26
	jne jump2
		
	cmp xPosPinky, 20
	jbe jump2

	cmp xPosPinky, 114
	jbe randomMovement
	
	Jump2:

	mov al, xPosGE
	cmp xPosPinky, al
	jne Jmp2

	mov al, yPosGE
	cmp yPosPinky, al
	je skip

	Jmp2:
		mov al, xPosSB
		cmp xPosPinky, al
		jne J3

		mov al, yPosSB
		cmp yPosPinky, al
		je randomMovement

	J3:

	call UpdatePinky
	dec yPosPinky
	jmp Skip

	Next1:
		; Down
		cmp al, 2
		je Nextt2
		
		cmp al, 6
		jne Next2
		
		Nextt2:
		cmp yPosPinky, 28
		je randomMovement
		
		cmp yPosPinky, 5
		jne jump3
		
		cmp xPosPinky, 20
		jbe jump3

		cmp xPosPinky, 114
		jbe randomMovement

		Jump3:
		mov al, xPosGE
		cmp xPosPinky, al
		jne Jmp3

		mov al, yPosGE
		cmp yPosPinky, al
		je skip

		Jmp3:
			mov al, xPosSB
			cmp xPosPinky, al
			jne J4

			mov al, yPosSB
			cmp yPosPinky, al
			je randomMovement

		J4:

		call UpdatePinky
		inc yPosPinky
		jmp Skip

	Next2:
		; Left
		cmp al, 3
		je Nextt3

		cmp al, 4
		jne Next3
		
		Nextt3:
		cmp xPosPinky, 1
		je randomMovement
		
		cmp xPosPinky, 112
		jne jump4
		
		cmp yPosPinky, 5
		jbe jump4

		cmp yPosPinky, 25
		jbe randomMovement

		Jump4:
		mov al, xPosGE
		cmp xPosPinky, al
		jne Jmp4

		mov al, yPosGE
		cmp yPosPinky, al
		je skip

		Jmp4:
			mov al, xPosSB
			cmp xPosPinky, al
			jne J5

			mov al, yPosSB
			cmp yPosPinky, al
			je randomMovement

		J5:
		call UpdatePinky
		dec xPosPinky
		jmp Skip

	Next3:
		; Right
		cmp xPosPinky, 131
		je randomMovement
		
		cmp xPosPinky, 20
		jne jump5
		
		cmp yPosPinky, 5
		jbe jump5

		cmp yPosPinky, 25
		jbe randomMovement

		Jump5:
		mov al, xPosGE
		cmp xPosPinky, al
		jne Jmp5

		mov al, yPosGE
		cmp yPosPinky, al
		je skip

		Jmp5:
			mov al, xPosSB
			cmp xPosPinky, al
			jne J6

			mov al, yPosSB
			cmp yPosPinky, al
			je randomMovement

		J6:

		call UpdatePinky
		inc xPosPinky

	Skip:
		call DrawPinky

	ret
movePinky ENDP

movePinky3 PROC

	randomMovement:
		call randomize
		mov eax, 4
		call RandomRange
		inc eax
    
	; Up
	cmp al, 1
	jne Next1
	
	cmp yPosPinky, 12
	je J4

	J3:
		call UpdatePinky
		dec yPosPinky
		jmp Skip

	Next1:
		; Down
		cmp al, 2
		jne Next2
		
		cmp yPosPinky, 18
		je J3
		
	J4:
		call UpdatePinky
		inc yPosPinky
		jmp Skip

	Next2:
		; Left
		cmp al, 3
		jne Next3
		
		cmp xPosPinky, 42
		je J6

	J5:
		call UpdatePinky
		dec xPosPinky
		jmp Skip

	Next3:
		; Right
		cmp xPosPinky, 58
		je J5

	J6:
		call UpdatePinky
		inc xPosPinky

	Skip:
		call DrawPinky

	ret
movePinky3 ENDP



; ---------
;  Level 1
; ---------

Level1 PROC

	mov eax, white + (black * 16)
	call SetTextColor
	
	; Gameplay
	call DrawFrame1
	call DrawPlayer
	call DrawGhost
	call Randomize


	gameLoop:

		; Check Level Completion
		call Level1Complete
		cmp bl, 1
		je exitGame

		; Scoring
		call coinCollection1
		call coinCollection2

		mov eax, white (black * 16)
		call SetTextColor

		call DisplayUserInfo

		; get user key input:
		call ReadChar
		mov inputChar, al

		; exit game if user types 'x':
		cmp inputChar, 'x'
		je exitGame

		; Pause if 'P' is Pressed
		cmp inputChar, 'p'
		jne unPaused
		call PauseGame
		jmp GameLoop

		unPaused:

			; Move Player
			cmp inputChar,"w"
			je moveUp

			cmp inputChar,"s"
			je moveDown

			cmp inputChar,"a"
			je moveLeft

			cmp inputChar,"d"
			je moveRight

		moveUp:
			call UpdatePlayer
			dec yPos

			; First Rectangle
			mov bl, 0
			call gameLoopHELPER1
			cmp bl, 1
			je Skip1

			; Second Rectangle
			mov bl, 0
			call gameLoopHELPER2
			cmp bl, 1
			je Skip1
				
			; Third Rectangle
			mov bl, 0
			call gameLoopHELPER3
			cmp bl, 1
			je Skip1

			; Border
			mov al, 2
			cmp yPos, al
			jg Skip1
			inc yPos

			Skip1:
				call checkCollision
				
				; Game Over
				cmp lives, 0
				jne Skipp
				call GameOver
				call ReadChar
				jmp exitGame

				Skipp:
				; Move Ghost
				call moveLinearGhost

				call DrawPlayer
				mov eax, 25
				call Delay
		jmp gameLoop

		moveDown:
			call UpdatePlayer
			inc yPos

			; First Rectangle
			mov bl, 0
			call gameLoopHELPER4
			cmp bl, 1
			je Skip2

			; Second Rectangle
			mov bl, 0
			call gameLoopHELPER5
			cmp bl, 1
			je Skip2
				
			; Third Rectangle
			mov bl, 0
			call gameLoopHELPER6
			cmp bl, 1
			je Skip2
			
			; Border
			mov al, 29
			cmp yPos, al
			jl Skip2
			dec yPos

			Skip2:
				call checkCollision
				
				; Game Over
				cmp lives, 0
				jne Skippp
				call GameOver
				call ReadChar
				jmp exitGame
				
				Skippp:
				; Move Ghost
				call moveLinearGhost

				call DrawPlayer
				mov eax, 25
				call Delay
			jmp gameLoop

		moveLeft:
			call UpdatePlayer
			dec xPos
			; First Rectangle
			mov bl, 0
			call gameLoopHELPER7
			cmp bl, 1
			je Skip3

			; Second Rectangle
			mov bl, 0
			call gameLoopHELPER8
			cmp bl, 1
			je Skip3
				
			; Third Rectangle
			mov bl, 0
			call gameLoopHELPER9
			cmp bl, 1
			je Skip3
			
			; Border
			mov al, 0
			cmp xPos, al
			ja Skip3
			inc xPos

			Skip3:
				call checkCollision
				
				; Game Over
				cmp lives, 0
				jne Skipppp
				call GameOver
				call ReadChar
				jmp exitGame
				
				Skipppp:
				; Move Ghost
				call moveLinearGhost

				call DrawPlayer
				mov eax, 7
				call Delay
		jmp gameLoop

		moveRight:
			call UpdatePlayer
			inc xPos

			; First Rectangle
			mov bl, 0
			call gameLoopHELPER10
			cmp bl, 1
			je Skip4

			; Second Rectangle
			mov bl, 0
			call gameLoopHELPER11
			cmp bl, 1
			je Skip4
				
			; Third Rectangle
			mov bl, 0
			call gameLoopHELPER12
			cmp bl, 1
			je Skip4
			
			; Border
			mov al, 132
			cmp xPos, al
			jb Skip4
			dec xPos

			Skip4:
				call checkCollision
				
				; Game Over
				cmp lives, 0
				jne Skippppp
				call GameOver
				call ReadChar
				jmp exitGame
				
				Skippppp:
				; Move Ghost
				call moveLinearGhost

				call DrawPlayer
				mov eax, 7
				call Delay

		jmp gameLoop

	exitGame:

    ret
Level1 endp


; -----------
;  Game Over 
; -----------

gameOver PROC

	call clrscr

	mov eax, yellow + (black * 16)
	call SetTextColor

	mov dl, 61
	mov dh, 13
	call GoToxy
	
	mov edx, OFFSET gameLost
	call WriteString

	ret
gameOver endP


; --------------------
;  Level 1 Completion 
; --------------------

level1Complete PROC
		
	cmp l1Score, 150
	jae JUMP

	; Check for Completion
	mov bl, 0
	cmp score, 113
	jb inComplete

	; Check if all Coins has been eaten

	mov esi, offset horizontalCoinLayout1
	mov ecx, 248

	L2:
		mov al, 0
		cmp [esi], al
		je Next2
		jmp incomplete
		Next2:
		inc esi
		LOOP L2

	mov esi, offset verticleCoinLayout1
	mov ecx, 72

	L1:
		mov al, 0
		cmp [esi], al
		je Next
		jmp incomplete
		Next:
		inc esi
		LOOP L1

	; Level has been Completed
	JUMP:
	call clrscr
	mov bl, 1

	mov eax, green + (black * 16)
	call SetTextColor

	mov dl, 58
	mov dh, 13
	call GoToxy
	
	mov edx, OFFSET strLevel1Complete
	call WriteString

	mov dl, 57
	mov dh, 14
	call GoToxy

	mov eax, lightGray + (black * 16)
	call SetTextColor
	
	mov edx, OFFSET strResume
	call WriteString

	Level2jmp:
		call readChar
		cmp al, 'r'
		jne Level2jmp
	

	inComplete:

	ret
Level1Complete endP


; ------------------
;  gameLoop Helpers
; ------------------

gameLoopHELPER1 PROC

	mov al, 11
	cmp xPos, al
	jl Skip

	mov al, 40
	cmp xPos, al
	jg Skip

	mov al, 23
	cmp yPos, al
	jg Skip

	mov al, 8
	cmp yPos, al
	jl Skip

	inc yPos
	mov bl, 1

	Skip:

	ret
gameLoopHELPER1 endP

gameLoopHELPER2 PROC

	mov al, 51
	cmp xPos, al
	jl Skip

	mov al, 81
	cmp xPos, al
	jg Skip

	mov al, 23
	cmp yPos, al
	jg Skip

	mov al, 8
	cmp yPos, al
	jl Skip

	inc yPos
	mov bl, 1

	Skip:

	ret
gameLoopHELPER2 endP

gameLoopHELPER3 PROC

	mov al, 92
	cmp xPos, al
	jl Skip

	mov al, 121
	cmp xPos, al
	jg Skip

	mov al, 23
	cmp yPos, al
	jg Skip

	mov al, 8
	cmp yPos, al
	jl Skip

	inc yPos
	mov bl, 1

	Skip:

	ret
gameLoopHELPER3 endP

gameLoopHELPER4 PROC

	mov al, 11
	cmp xPos, al
	jl Skip

	mov al, 40
	cmp xPos, al
	jg Skip

	mov al, 23
	cmp yPos, al
	jg Skip

	mov al, 8
	cmp yPos, al
	jl Skip

	dec yPos
	mov bl, 1

	Skip:

	ret
gameLoopHELPER4 endP

gameLoopHELPER5 PROC

	mov al, 51
	cmp xPos, al
	jl Skip

	mov al, 81
	cmp xPos, al
	jg Skip

	mov al, 23
	cmp yPos, al
	jg Skip

	mov al, 8
	cmp yPos, al
	jl Skip

	dec yPos
	mov bl, 1

	Skip:

	ret
gameLoopHELPER5 endP

gameLoopHELPER6 PROC

	mov al, 92
	cmp xPos, al
	jl Skip

	mov al, 121
	cmp xPos, al
	jg Skip

	mov al, 23
	cmp yPos, al
	jg Skip

	mov al, 8
	cmp yPos, al
	jl Skip

	dec yPos
	mov bl, 1

	Skip:

	ret
gameLoopHELPER6 endP

gameLoopHELPER7 PROC

	mov al, 40
	cmp xPos, al
	jne Skip

	mov al, 23
	cmp yPos, al
	jg Skip

	mov al, 8
	cmp yPos, al
	jl Skip

	inc xPos
	mov bl, 1

	Skip:

	ret
gameLoopHELPER7 endP

gameLoopHELPER8 PROC

	mov al, 81
	cmp xPos, al
	jne Skip

	mov al, 23
	cmp yPos, al
	jg Skip

	mov al, 8
	cmp yPos, al
	jl Skip

	inc xPos
	mov bl, 1

	Skip:

	ret
gameLoopHELPER8 endP

gameLoopHELPER9 PROC

	mov al, 121
	cmp xPos, al
	jne Skip

	mov al, 23
	cmp yPos, al
	jg Skip

	mov al, 8
	cmp yPos, al
	jl Skip

	inc xPos
	mov bl, 1

	Skip:

	ret
gameLoopHELPER9 endP

gameLoopHELPER10 PROC

	mov al, 11
	cmp xPos, al
	jne Skip

	mov al, 23
	cmp yPos, al
	jg Skip

	mov al, 8
	cmp yPos, al
	jl Skip

	dec xPos
	mov bl, 1

	Skip:

	ret
gameLoopHELPER10 endP

gameLoopHELPER11 PROC

	mov al, 51
	cmp xPos, al
	jne Skip

	mov al, 23
	cmp yPos, al
	jg Skip

	mov al, 8
	cmp yPos, al
	jl Skip

	dec xPos
	mov bl, 1

	Skip:

	ret
gameLoopHELPER11 endP

gameLoopHELPER12 PROC

	mov al, 92
	cmp xPos, al
	jne Skip

	mov al, 23
	cmp yPos, al
	jg Skip

	mov al, 8
	cmp yPos, al
	jl Skip

	dec xPos
	mov bl, 1

	Skip:

	ret
gameLoopHELPER12 endP

ghostHELPER1 PROC

	mov al, 11
	cmp xPosghost, al
	jl Skip

	mov al, 40
	cmp xPosghost, al
	jg Skip

	mov al, 23
	cmp yPosghost, al
	jg Skip

	mov al, 8
	cmp yPosghost, al
	jl Skip

	inc yPosghost
	mov bl, 1

	Skip:

	ret
ghostHELPER1 endP

ghostHELPER2 PROC

	mov al, 51
	cmp xPosghost, al
	jl Skip

	mov al, 81
	cmp xPosghost, al
	jg Skip

	mov al, 23
	cmp yPosghost, al
	jg Skip

	mov al, 8
	cmp yPosghost, al
	jl Skip

	inc yPosghost
	mov bl, 1

	Skip:

	ret
ghostHELPER2 endP

ghostHELPER3 PROC

	mov al, 92
	cmp xPosghost, al
	jl Skip

	mov al, 121
	cmp xPosghost, al
	jg Skip

	mov al, 23
	cmp yPosghost, al
	jg Skip

	mov al, 8
	cmp yPosghost, al
	jl Skip

	inc yPosghost
	mov bl, 1

	Skip:

	ret
ghostHELPER3 endP

ghostHELPER4 PROC

	mov al, 11
	cmp xPosghost, al
	jl Skip

	mov al, 40
	cmp xPosghost, al
	jg Skip

	mov al, 23
	cmp yPosghost, al
	jg Skip

	mov al, 8
	cmp yPosghost, al
	jl Skip

	dec yPosghost
	mov bl, 1

	Skip:

	ret
ghostHELPER4 endP

ghostHELPER5 PROC

	mov al, 51
	cmp xPosghost, al
	jl Skip

	mov al, 81
	cmp xPosghost, al
	jg Skip

	mov al, 23
	cmp yPosghost, al
	jg Skip

	mov al, 8
	cmp yPosghost, al
	jl Skip

	dec yPosghost
	mov bl, 1

	Skip:

	ret
ghostHELPER5 endP

ghostHELPER6 PROC

	mov al, 92
	cmp xPosghost, al
	jl Skip

	mov al, 121
	cmp xPosghost, al
	jg Skip

	mov al, 23
	cmp yPosghost, al
	jg Skip

	mov al, 8
	cmp yPosghost, al
	jl Skip

	dec yPosghost
	mov bl, 1

	Skip:

	ret
ghostHELPER6 endP

ghostHELPER7 PROC

	mov al, 40
	cmp xPosghost, al
	jne Skip

	mov al, 23
	cmp yPosghost, al
	jg Skip

	mov al, 8
	cmp yPosghost, al
	jl Skip

	inc xPosghost
	mov bl, 1

	Skip:

	ret
ghostHELPER7 endP

ghostHELPER8 PROC

	mov al, 81
	cmp xPosghost, al
	jne Skip

	mov al, 23
	cmp yPosghost, al
	jg Skip

	mov al, 8
	cmp yPosghost, al
	jl Skip

	inc xPosghost
	mov bl, 1

	Skip:

	ret
ghostHELPER8 endP

ghostHELPER9 PROC

	mov al, 121
	cmp xPosghost, al
	jne Skip

	mov al, 23
	cmp yPosghost, al
	jg Skip

	mov al, 8
	cmp yPosghost, al
	jl Skip

	inc xPosghost
	mov bl, 1

	Skip:

	ret
ghostHELPER9 endP

ghostHELPER10 PROC

	mov al, 11
	cmp xPosghost, al
	jne Skip

	mov al, 23
	cmp yPosghost, al
	jg Skip

	mov al, 8
	cmp yPosghost, al
	jl Skip

	dec xPosghost
	mov bl, 1

	Skip:

	ret
ghostHELPER10 endP

ghostHELPER11 PROC

	mov al, 51
	cmp xPosghost, al
	jne Skip

	mov al, 23
	cmp yPosghost, al
	jg Skip

	mov al, 8
	cmp yPosghost, al
	jl Skip

	dec xPosghost
	mov bl, 1

	Skip:

	ret
ghostHELPER11 endP

ghostHELPER12 PROC

	mov al, 92
	cmp xPosghost, al
	jne Skip

	mov al, 23
	cmp yPosghost, al
	jg Skip

	mov al, 8
	cmp yPosghost, al
	jl Skip

	dec xPosghost
	mov bl, 1

	Skip:

	ret
ghostHELPER12 endP


; -------------
;  Game Paused
; -------------

PauseGame PROC

	mov eax, lightRed + (black * 16)
	call SetTextColor

	mov dl, 61
	mov dh, 0
	call GoToxy
	
	mov edx, OFFSET strPause
	call WriteString

	mov dl, 57
	mov dh, 1
	call GoToxy

	mov eax, yellow + (black * 16)
	call SetTextColor
	
	mov edx, OFFSET strResume
	call WriteString

	Paused:
		call ReadChar
		mov inputChar, al

		; Resume if 'r' is Pressed
		cmp inputChar, 'r'
		jne Paused

	; Remove Pause Prompt
	mov dl, 61
	mov dh, 0
	call GoToXY
	
	mov edx, offset strRemovePause
	mov ecx, 19
	call writeString

	mov dl, 57
	mov dh, 1
	call GoToXY

	mov edx, offset strRemovePause
	mov ecx, 19
	call writeString
	
	ret
PauseGame endP 


; ----------------
;  Welcome Screen
; ----------------

WelcomeScreen PROC

	; Draw PacMan
	mov dl, 55
	mov dh, 13
	call GoToxy
	
	mov eax, yellow + (black * 16)
	call SetTextColor

	mov edx, offset strPacMan
	call WriteString

	; Display Username Prompt
	mov dl, 53
	mov dh, 15
	call GoToxy
	
	mov eax, lightGray + (black * 16)
	call SetTextColor

	mov edx, offset enterName
	call WriteString

	; Input Username
	mov edx, offset username
    mov ecx, 255
	call readString

	ret
WelcomeScreen endP


; -------------
;  Menu Screen
; -------------

MenuScreen PROC

	In1:
	; Draw Menu
	mov dl, 55
	mov dh, 13
	call GoToxy
	
	mov eax, yellow + (black * 16)
	call SetTextColor

	mov edx, offset strMenu
	call WriteString

	; Play
	mov dl, 50
	mov dh, 15
	call GoToxy
	
	mov eax, lightGray + (black * 16)
	call SetTextColor

	mov edx, offset strPlay
	
	; Instructions
	call WriteString
	mov dl, 50
	mov dh, 16
	call GoToxy
	
	mov eax, lightGray + (black * 16)
	call SetTextColor

	mov edx, offset strInstructions
	call WriteString

	; Preferences
	mov dl, 50
	mov dh, 17
	call GoToxy
	
	mov eax, lightGray + (black * 16)
	call SetTextColor

	mov edx, offset strPreferences
	call WriteString


	; Input Choice
	call ReadChar
	mov inputChar, al

	cmp inputChar, '1'
	je Skip

	cmp inputChar, '2'
	jne Next
	call clrscr
	call InstructionsScreen
	jmp In1

	Next:
	cmp inputChar, '3'
	jne In1

	call clrscr
	call PreferencesScreen
	jmp In1

	Skip:

	ret
MenuScreen endP


; ---------------------
;  Instructions Screen
; ---------------------

InstructionsScreen PROC

	; Draw Instructions
	mov dl, 5
	mov dh, 5
	call GoToxy
	
	mov eax, yellow + (black * 16)
	call SetTextColor

	mov edx, offset strInstructions2
	call WriteString

	; General
	mov dl, 2
	mov dh, 7
	call GoToxy
	
	mov eax, lightGray + (black * 16)
	call SetTextColor

	mov edx, offset strGeneral1
	call WriteString
	
	mov dl, 2
	mov dh, 8
	call GoToxy

	mov edx, offset strGeneral2
	call WriteString
	
	mov dl, 2
	mov dh, 9
	call GoToxy

	mov edx, offset strGeneral3
	call WriteString
	
	; Controls
	mov dl, 2
	mov dh, 11
	call GoToxy

	mov edx, offset strMVup
	call WriteString
	
	mov dl, 2
	mov dh, 12
	call GoToxy

	mov edx, offset strMVleft
	call WriteString
	
	mov dl, 2
	mov dh, 13
	call GoToxy

	mov edx, offset strMVdown
	call WriteString

	mov dl, 2
	mov dh, 14
	call GoToxy

	mov edx, offset strMVright
	call WriteString
	
	mov dl, 2
	mov dh, 16
	call GoToxy

	mov edx, offset strOtherCTRLs1
	call WriteString
	
	mov dl, 2
	mov dh, 17
	call GoToxy

	mov edx, offset strOtherCTRLs2
	call WriteString
	
	mov dl, 2
	mov dh, 18
	call GoToxy

	mov edx, offset strOtherCTRLs3
	call WriteString

	; Input Choice
	call ReadChar
	call clrscr

	ret
InstructionsScreen endP


; --------------------
;  Preferences Screen
; --------------------

PreferencesScreen PROC

	; Draw Preferences
	mov dl, 55
	mov dh, 13
	call GoToxy
	
	mov eax, yellow + (black * 16)
	call SetTextColor

	mov edx, offset strPreferences2
	call WriteString
	
	; PacMan
	mov dl, 51
	mov dh, 15
	call GoToxy
	
	mov eax, lightGray + (black * 16)
	call SetTextColor

	mov edx, offset strChoosePacMan
	call WriteString

	call ReadChar
	mov Player, al
	
	; Ghost
	mov dl, 51
	mov dh, 16
	call GoToxy

	mov edx, offset strChooseGhost
	call WriteString

	call ReadChar
	mov Ghost, al

	; Press any Key to Continue
	call ReadChar
	call clrscr

	ret
PreferencesScreen endP


; -------
;  Frame
; -------

DrawFrame1 PROC

	mov eax, blue + (black * 16)
	call SetTextColor

	; Horizontal Borders
	mov dl, 0
	mov dh, 2
	call gotoxy
	mov edx, OFFSET ground
	call WriteString
	 
	mov dl, 0
	mov dh, 29
	call Gotoxy
	
	mov edx, OFFSET ground
	call WriteString


	; Verticle Borders
	mov bl, 3
	mov ecx, 26
	mov dl, 0
	mov dh, bl
	call gotoxy

	verticalFrame:
		mov edx, offset vFrameElement
		call WriteString

		mov dl, 132
		mov dh, bl
		call gotoxy

		mov edx, offset vFrameElement
		call WriteString

		inc bl
		mov dl, 0
		mov dh, bl
		call gotoxy

		mov eax, 20
		call delay

	LOOP verticalFrame

	
	; Maze
	; Horizontal Lines
	mov dl, 11
	mov dh, 8
	call gotoxy
	mov edx, offset mazeRectangle
	call WriteString

	mov dl, 11
	mov dh, 23
	call gotoxy
	mov edx, offset mazeRectangle
	call WriteString

	mov dl, 52
	mov dh, 8
	call gotoxy
	mov edx, offset mazeRectangle
	call WriteString

	mov dl, 52
	mov dh, 23
	call gotoxy
	mov edx, offset mazeRectangle
	call WriteString

	mov dl, 92
	mov dh, 8
	call gotoxy
	mov edx, offset mazeRectangle
	call WriteString

	mov dl, 92
	mov dh, 23
	call gotoxy
	mov edx, offset mazeRectangle
	call WriteString

	mov dl, 51
	mov dh, 8
	call gotoxy
	mov edx, offset mazeRectangle
	call WriteString

	mov dl, 51
	mov dh, 23
	call gotoxy
	mov edx, offset dash
	call WriteString

	
	; Vertical Lines
	mov bl, 9
	mov ecx, 14
	mov dl, 11
	mov dh, bl
	call gotoxy

	verticalBorders:
		mov edx, offset vFrameElement
		call WriteString

		mov dl, 40
		mov dh, bl
		call gotoxy

		mov edx, offset vFrameElement
		call WriteString

		mov dl, 51
		mov dh, bl
		call gotoxy

		mov edx, offset vFrameElement
		call WriteString

		mov dl, 81
		mov dh, bl
		call gotoxy

		mov edx, offset vFrameElement
		call WriteString

		mov dl, 92
		mov dh, bl
		call gotoxy

		mov edx, offset vFrameElement
		call WriteString

		mov dl, 121
		mov dh, bl
		call gotoxy

		mov edx, offset vFrameElement
		call WriteString

		inc bl
		mov dl, 11
		mov dh, bl
		call gotoxy

		mov eax, 20
		call delay

	LOOP verticalBorders

	
	; Coins
	; Horizontal Coins
	mov eax, yellow + (black * 16)
	call SetTextColor
	
	mov dl, 5
	mov dh, 6
	call gotoxy

	mov edx, offset coins
	call WriteString

	mov dl, 5
	mov dh, 25
	call gotoxy

	mov edx, offset coins
	call WriteString


	; Verticle Coins
	mov ecx, 18
	mov dl, 5
	mov dh, 7
	mov bl, 7
	call gotoxy

	verticleCoins:
		mov edx, offset dot
		call WriteString

		mov dl, 45
		mov dh, bl
		call gotoxy
		
		mov edx, offset dot
		call WriteString

		mov dl, 86
		mov dh, bl
		call gotoxy
		
		mov edx, offset dot
		call WriteString

		mov dl, 127
		mov dh, bl
		call gotoxy
		
		mov edx, offset dot
		call WriteString

		inc bl
		mov dl, 5
		mov dh, bl
		call gotoxy

		mov eax, 20
		call delay

	LOOP verticleCoins

	
	ret
DrawFrame1 endP


; -----------
;  User Info
; -----------

DisplayUserInfo PROC

	; Score
	mov dl, 0
	mov dh, 0
	call Gotoxy

	mov edx, OFFSET strScore
	call WriteString

	mov eax,score
	call WriteDec

	; Lives
	mov dl, 0
	mov dh, 1
	call Gotoxy

	mov edx, OFFSET strLives
	call WriteString
	
	mov eax,lives
	call WriteDec

	; Level 
	mov eax, yellow + (black * 16)
	call SetTextColor

	mov dl, 125
	mov dh, 1
	call Gotoxy

	mov edx, OFFSET strLevel1
	call WriteString

	ret
DisplayUserInfo endP


; --------
;  Player
; --------

DrawPlayer PROC

	mov eax, white + (black * 16)
	call SetTextColor

	; draw player at (xPos,yPos):
	mov dl,xPos
	mov dh,yPos
	call Gotoxy
	mov al, Player
	call WriteChar
	
	ret
DrawPlayer ENDP


UpdatePlayer PROC

	mov dl,xPos
	mov dh,yPos
	call Gotoxy
	
	mov al, " "
	call WriteChar
	
	ret
UpdatePlayer ENDP


; --------
;  Ghost
; --------

DrawGhost PROC

	mov eax, black + (lightRed * 16)
	call SetTextColor

	; draw Ghost at (xPos,yPos):
	mov dl, xPosGhost
	mov dh, yPosGhost
	call Gotoxy

	mov al, Ghost
	call WriteChar
	
	ret
DrawGhost ENDP


UpdateGhost PROC

	mov dl, xPosGhost
	mov dh, yPosGhost
	call Gotoxy
	
	mov al, " "
	call WriteChar
	call GhostCoinInteraction1
	call GhostCoinInteraction2
	
	ret
UpdateGhost ENDP

moveLinearGhost PROC

	; Down
	cmp xPosGhost, 127
	jne Left

	cmp yPosGhost, 25
	je Left
	
	call UpdateGhost
	inc yPosGhost
	jmp Next

	Left:
		cmp yPosGhost, 25
		jne Up

		cmp xPosGhost, 5
		je Up
		
		call UpdateGhost
		dec xPosGhost
		jmp Next

	Up:
		cmp xPosGhost, 5
		jne Right

		cmp yPosGhost, 6
		je Right
		
		call UpdateGhost
		dec yPosGhost
		jmp Next

	Right:
		call UpdateGhost
		inc xPosGhost

	Next:
		call DrawGhost
		mov eax, 10
		;call Delay

	ret
moveLinearGhost endP


; -------
;  Coins
; -------

coinCollection1 PROC

	mov esi, offset verticleCoinLayout1
	mov eax, 0
	mov ebx, 0
	mov al, xPos
	mov bl, yPos
	
	; Check y-Coordinate
	mov dl, 24
	cmp bl, dl
	jg Skip

	mov dl, 7
	cmp bl, dl
	jl Skip

	; Check x-Coordinate
	mov dl, 5
	cmp al, dl
	je Col1

	mov dl, 45
	cmp al, dl
	je Col2

	mov dl, 86
	cmp al, dl
	je Col3
	
	mov dl, 127
	cmp al, dl
	je Col4
	jmp Skip

	; First Verticle Line
	Col1:
		SUB bl, 7
		ADD esi, ebx
		mov dl, 0
		cmp BYTE PTR [esi], dl
		je Skip

		; Increment Score
		mov edx, 0
		mov [esi], edx
		inc score
		inc l1Score
		jmp Skip

	Col2:
		SUB bl, 7
		ADD esi, 18
		ADD esi, ebx
		mov dl, 0
		cmp BYTE PTR [esi], dl
		je Skip

		; Increment Score
		mov edx, 0
		mov [esi], edx
		inc score
		inc l1Score
		jmp Skip

	Col3:
		SUB bl, 7
		ADD esi, 36
		ADD esi, ebx
		mov dl, 0
		cmp BYTE PTR [esi], dl
		je Skip

		; Increment Score
		mov edx, 0
		mov [esi], edx
		inc score
		inc l1Score
		jmp Skip

	Col4:
		SUB bl, 7
		ADD esi, 54
		ADD esi, ebx
		mov dl, 0
		cmp BYTE PTR [esi], dl
		je Skip

		; Increment Score
		mov edx, 0
		mov [esi], edx
		inc score
		inc l1Score

	Skip:

	ret
coinCollection1 endp

coinCollection2 PROC

	mov esi, offset horizontalCoinLayout1
	mov eax, 0
	mov ebx, 0
	mov al, xPos
	mov bl, yPos

	; Check x-Coordinate
	mov dl, 5
	cmp al, dl
	jl Skip

	mov dl, 127
	cmp al, dl
	jg Skip
	
	; Check y-Coordinate
	mov dl, 6
	cmp bl, dl
	je Row1

	mov dl, 25
	cmp bl, dl
	je Row2
	jmp Skip

	; First Horzontal Line
	Row1:
		SUB al, 5
		ADD esi, eax
		mov dl, 0
		cmp BYTE PTR [esi], dl
		je Skip

		; Increment Score
		mov edx, 0
		mov [esi], edx
		inc score
		inc l1score
		jmp Skip

	Row2:
		SUB al, 5
		ADD esi, 124
		ADD esi, eax
		mov dl, 0
		cmp BYTE PTR [esi], dl
		je Skip

		; Increment Score
		mov edx, 0
		mov [esi], edx
		inc score
		inc l1score
		jmp Skip

	Skip:

	ret
coinCollection2 endp

GhostCoinInteraction1 PROC

	mov esi, offset verticleCoinLayout1
	mov eax, 0
	mov ebx, 0
	mov al, xPosGhost
	mov bl, yPosGhost
	
	; Check y-Coordinate
	mov dl, 24
	cmp bl, dl
	jg Skip

	mov dl, 7
	cmp bl, dl
	jl Skip

	; Check x-Coordinate
	mov dl, 5
	cmp al, dl
	je Col1

	mov dl, 45
	cmp al, dl
	je Col2

	mov dl, 86
	cmp al, dl
	je Col3
	
	mov dl, 127
	cmp al, dl
	je Col4
	jmp Skip

	; First Verticle Line
	Col1:
		SUB bl, 7
		ADD esi, ebx
		mov dl, 0
		cmp BYTE PTR [esi], dl
		je Skip

		; Dont Remove Coin
		mov eax, yellow + (black * 16)
		call SetTextColor

		mov dl, xPosGhost
		mov dh, yPosGhost
		call Gotoxy

		mov al, dot
		call WriteChar
		jmp Skip

	Col2:
		SUB bl, 7
		ADD esi, 18
		ADD esi, ebx
		mov dl, 0
		cmp BYTE PTR [esi], dl
		je Skip

		
		; Dont Remove Coin
		mov eax, yellow + (black * 16)
		call SetTextColor

		mov dl, xPosGhost
		mov dh, yPosGhost
		call Gotoxy

		mov al, dot
		call WriteChar
		jmp Skip

	Col3:
		SUB bl, 7
		ADD esi, 36
		ADD esi, ebx
		mov dl, 0
		cmp BYTE PTR [esi], dl
		je Skip

		
		; Dont Remove Coin
		mov eax, yellow + (black * 16)
		call SetTextColor

		mov dl, xPosGhost
		mov dh, yPosGhost
		call Gotoxy

		mov al, dot
		call WriteChar
		jmp Skip

	Col4:
		SUB bl, 7
		ADD esi, 54
		ADD esi, ebx
		mov dl, 0
		cmp BYTE PTR [esi], dl
		je Skip

		; Dont Remove Coin
		mov eax, yellow + (black * 16)
		call SetTextColor

		mov dl, xPosGhost
		mov dh, yPosGhost
		call Gotoxy

		mov al, dot
		call WriteChar

	Skip:

	ret
GhostCoinInteraction1 endp

GhostCoinInteraction2 PROC

	mov esi, offset horizontalCoinLayout1
	mov eax, 0
	mov ebx, 0
	mov al, xPosGhost
	mov bl, yPosGhost

	; Check x-Coordinate
	mov dl, 5
	cmp al, dl
	jl Skip

	mov dl, 127
	cmp al, dl
	jg Skip
	
	; Check y-Coordinate
	mov dl, 6
	cmp bl, dl
	je Row1

	mov dl, 25
	cmp bl, dl
	je Row2
	jmp Skip

	; First Horzontal Line
	Row1:
		SUB al, 5
		ADD esi, eax
		mov dl, 0
		cmp BYTE PTR [esi], dl
		je Skip

		; Dont Remove Coin
		mov eax, yellow + (black * 16)
		call SetTextColor

		mov dl, xPosGhost
		mov dh, yPosGhost
		call Gotoxy

		mov al, dot
		call WriteChar
		jmp Skip

	Row2:
		SUB al, 5
		ADD esi, 124
		ADD esi, eax
		mov dl, 0
		cmp BYTE PTR [esi], dl
		je Skip

		
		; Dont Remove Coin
		mov eax, yellow + (black * 16)
		call SetTextColor

		mov dl, xPosGhost
		mov dh, yPosGhost
		call Gotoxy

		mov al, dot
		call WriteChar
		jmp Skip

	Skip:

	ret
GhostCoinInteraction2 endp


; -------
;  Lives
; -------

checkCollision PROC

	; Horizontal Check
	mov al, xPos
	mov bl, yPos

	cmp al, xPosGhost
	je Next

	inc al
	cmp al, xPosGhost
	je Next

	dec al
	dec al
	cmp al, xPosGhost
	je Next
	jmp Verticle

	Next:
		cmp bl, yPosGhost
		je CollisionDetected

	; Verticle Check
	Verticle:
	mov al, xPos
	mov bl, yPos

	cmp bl, yPosGhost
	je Next2

	inc bl
	cmp bl, yPosGhost
	je Next2

	dec bl
	dec bl
	cmp bl, yPosGhost
	je Next2
	jmp Skip

	Next2:
		cmp al, xPosGhost
		je CollisionDetected
		jmp Skip

	; Collision
	CollisionDetected:
		mov bl, 1
	
	; Remove Player and Ghost from Current Position
	mov eax, black + (black * 16)
	call SetTextColor
	
	mov dl, xPosGhost
	mov dh, yPosGhost
	call GoToXY

	mov al, ' '
	call writeChar
	
	mov dl, xPos
	mov dh, yPos
	call GoToXY

	mov al, ' '
	call writeChar

	; Reset Player and Ghost
	mov xPos, 2
	mov yPos, 28
	mov al, currGhostX
	mov cl, currGhostY
	mov xPosGhost, al
	mov yPosGhost, cl
	dec lives

	Skip:

	ret
checkCollision endP

end main