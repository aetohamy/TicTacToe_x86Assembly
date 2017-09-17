INCLUDE Irvine32.inc
.data 
TheFirstRowB Byte  ' 1 | 2 | 3 ',0
TheBaseLineB Byte  '---+---+---',0
TheSecondRowB Byte ' 4 | 5 | 6 ',0
TheThirdRowB Byte  ' 7 | 8 | 9 ',0
UserInputB Byte ?,0
Player1B Byte " Please enter the number of the square where you want to place your X",0
Player2B Byte " Please enter the number of the square where you want to place your O",0
PromptKey BYTE "Press any key to continue...",0
PromptP1Name BYTE "Player 1 Name : ",0
PromptP2Name BYTE "Player 2 Name : ",0
InvalidInputB Byte "Cannot be placed please enter another number",0
CounterXsInFirstRowB Byte 0
CounterXsInSecondRowB Byte 0
CounterXsInThirdRowB Byte 0
CounterOsInFirstRowB Byte 0
CounterOsInSecondRowB Byte 0
CounterOsInThirdRowB Byte 0
CounterXsInFirstColumnB Byte 0
CounterXsInSecondColumnB Byte 0
CounterXsInThirdColumnB Byte 0
CounterOsInFirstColumnB Byte 0
CounterOsInSecondColumnB Byte 0
CounterOsInThirdColumnB Byte 0
CounterXsInRightDiagonalB Byte 0
CounterXsInLeftDiagonalB Byte 0
CounterOsInRightDiagonalB Byte 0
CounterOsInLeftDiagonalB Byte 0
PlayerAWonB Byte "Player 1 won, Start a new game if you want",0
PlayerBWonB Byte "Player 2 won, Start a new game if you want",0
TieMessageB BYTE "It's a Tie ! , Start a new game if you want ",0
NewGameMessageB BYTE "Do you want to start a new game ? (1[yes]/0[no]) ",0
PromptSymbol BYTE " enter your desired symbol : ",0
MovesLeftB BYTE ?
PlayerAScore BYTE 0
PlayerBScore BYTE 0
StrPlayerAScore BYTE " won : ",0
StrPlayerBScore BYTE " won : ",0
WonOrTie BYTE 0
CheckB BYTE 0
;----------------------------------------------------------------------------
;initial data of strings (to be copied when the user choses to restart the game)
INITFirstRowB Byte  ' 1 | 2 | 3 ',0
INITSecondRowB Byte ' 4 | 5 | 6 ',0
INITThirdRowB Byte  ' 7 | 8 | 9 ',0
P1Name BYTE 20 DUP(?)
P2Name BYTE 20 DUP(?)
P1Symbol BYTE ?
P2Symbol BYTE ?

.code

;------------------------------------------------------
;DrawGameBoard Proc
;Draws the board as the game goes on
;Receives: 3 Strings used to draw the game
;Returns: Nothing
;Requires:Nothing
;-------------------------------------------------------
DrawGameBoard Proc
MOV EDX, OFFSET TheFirstRowB ;Makes Edx points to the first Row
CALL WRITESTRING ;Draws the Row
CALL CRLF ;Moves to a new Line
MOV EDX, OFFSET TheBaseLineB ; draws ---+---+---
CALL WRITESTRING
CALL CRLF
MOV EDX, OFFSET TheSecondRowB
CALL WRITESTRING
CALL CRLF 
MOV EDX, OFFSET TheBaseLineB
CALL WRITESTRING
CALL CRLF 
MOV EDX, OFFSET TheThirdRowB
CALL WRITESTRING
CALL CRLF
CALL CRLF
RET
DrawGameBoard ENDP
;----------------------------------------------------------
;----------------------------------------------------------
;PlayerAturn Proc
;Takes the input from the first player and places it
;Receives: a char character from the user 
;Returns: Nothing
;Requires: Procedure win,tie, lose, board to be ready
;----------------------------------------------------------
PlayerAturn PROC
BeginAgain:
CALL WIN
;CALL TIE
cmp WonOrTie , 1
je LWonOrTie
mov  eax,yellow+(blue*16)
call SetTextColor
MOV EDX ,OFFSET P1Name
call WriteString
MOV EDX, OFFSET Player1B ;Makes Edx point to the first player message
CALL WRITESTRING 
mov  eax,white+(black*16)
call SetTextColor
CALL CRLF 
CALL CRLF
CALL READCHAR ;Reads the number from user
CALL WRITECHAR
CALL CRLF
CALL CRLF
MOV ECX, LENGTHOF TheFirstRowB ; Search For the number 
MOV ESI, OFFSET TheFirstRowB
call Check
cmp CheckB , 1
je PlaceTheXinTheFirstRow
MOV ECX,LENGTHOF TheSecondRowB
MOV ESI, OFFSET TheSecondRowB
call Check
cmp CheckB , 1
je PlaceTheXinTheSecondRow
MOV ECX,LENGTHOF TheThirdRowB
MOV ESI, OFFSET TheThirdRowB
call Check
cmp CheckB , 1
je PlaceTheXinTheThirdRow
MOV EDX, OFFSET InvalidInputB
CALL WRITESTRING
CALL CRLF
CALL CRLF
JMP BeginAgain
PlaceTheXinTheFirstRow:
MOV BL,P1Symbol
MOV [ESI],BL
INC CounterXsInFirstRowB ;Counter of Xs in first row to help determine the winner if the row contains 3 then x won
CMP AL,'1'
JNE CheckNextNumber
INC CounterXsInFirstColumnB ;Counter of Xs in first Column to help determine the winner if the row contains 3 then x won
INC	CounterXsInLeftDiagonalB ;Counter of Xs in left Diagonal to help determine the winner if the row contains 3 then x won
JMP Done
CheckNextNumber:
CMP AL,'2'
JNE CheckNextNumber2
INC CounterXsInSecondColumnB
JMP Done
CheckNextNumber2:
CMP AL,'3'
JNE PlaceTheXinTheSecondRow
INC CounterXsInThirdColumnB
INC CounterXsInRightDiagonalB
JMP Done
PlaceTheXinTheSecondRow:
MOV BL,P1Symbol
MOV [ESI],BL
INC CounterXsInSecondRowB
CMP AL,'4'
JNE CheckNextNumber3
INC CounterXsInFirstColumnB
JMP Done
CheckNextNumber3:
CMP AL,'5'
JNE CheckNextNumber4
INC CounterXsInSecondColumnB
INC	CounterXsInLeftDiagonalB
INC CounterXsInRightDiagonalB
JMP Done
CheckNextNumber4:
CMP AL,'6'
JNE PlaceTheXinTheThirdRow
INC CounterXsInThirdColumnB
JMP Done
PlaceTheXinTheThirdRow:
MOV BL,P1Symbol
MOV [ESI],BL
INC CounterXsInThirdRowB
CMP AL,'7'
JNE CheckNextNumber5
INC CounterXsInFirstColumnB
INC CounterXsInRightDiagonalB
CALL WIN
JMP Done
CheckNextNumber5:
CMP AL,'8'
JNE CheckNextNumber6
INC CounterXsInSecondColumnB
CALL WIN
JMP Done
CheckNextNumber6:
CMP AL,'9'
JNE Done
INC CounterXsInThirdColumnB
INC CounterXsInLeftDiagonalB
Done:
DEC MovesLeftB
CALL WIN
;CALL TIE
LWonOrTie:
RET
PlayerAturn ENDP
;----------------------------------------------------------
;----------------------------------------------------------
;PlayerBturn Proc
;Takes the input from the first player and places it
;Receives: a char character from the user 
;Returns: Nothing
;Requires: Procedure win,tie, lose, board to be ready
;----------------------------------------------------------
PlayerBturn PROC
BeginAgain:
;CALL WIN
CALL TIE
cmp WonOrTie , 1
je LWonorTie
mov  eax,yellow+(red*16)
call SetTextColor
MOV Edx , OFFSET P2Name
call WriteString
MOV EDX, OFFSET Player2B ;Makes Edx point to the first player message
CALL WRITESTRING 
mov  eax,white+(black*16)
call SetTextColor
CALL CRLF 
CALL CRLF
CALL READCHAR ;Reads the number from user
CALL WRITECHAR
CALL CRLF
CALL CRLF
MOV ECX, LENGTHOF TheFirstRowB ; Search For the number 
MOV ESI, OFFSET TheFirstRowB
call Check
cmp CheckB , 1
je PlaceTheOinTheFirstRow
MOV ECX,LENGTHOF TheSecondRowB
MOV ESI, OFFSET TheSecondRowB
call Check
cmp CheckB , 1
je PlaceTheOinTheSecondRow
MOV ECX,LENGTHOF TheThirdRowB
MOV ESI, OFFSET TheThirdRowB
call Check
cmp CheckB , 1
je PlaceTheOinTheThirdRow
MOV EDX, OFFSET InvalidInputB
CALL WRITESTRING
CALL CRLF
CALL CRLF
JMP BeginAgain
PlaceTheOinTheFirstRow:
MOV BL,P2Symbol
MOV [ESI],BL
INC CounterOsInFirstRowB
CMP AL,'1'
JNE CheckNextNumber
INC CounterOsInFirstColumnB
INC	CounterOsInLeftDiagonalB
JMP Done
CheckNextNumber:
CMP AL,'2'
JNE CheckNextNumber2
INC CounterOsInSecondColumnB
JMP Done
CheckNextNumber2:
CMP AL,'3'
JNE PlaceTheOinTheSecondRow
INC CounterOsInThirdColumnB
INC CounterOsInRightDiagonalB
JMP Done
PlaceTheOinTheSecondRow:
MOV BL,P2Symbol
MOV [ESI],BL
INC CounterOsInSecondRowB
CMP AL,'4'
JNE CheckNextNumber3
INC CounterOsInFirstColumnB
JMP Done
CheckNextNumber3:
CMP AL,'5'
JNE CheckNextNumber4
INC CounterOsInSecondColumnB
INC	CounterOsInLeftDiagonalB
INC CounterOsInRightDiagonalB
JMP Done
CheckNextNumber4:
CMP AL,'6'
JNE PlaceTheOinTheThirdRow
INC CounterOsInThirdColumnB
JMP Done
PlaceTheOinTheThirdRow:
MOV BL,P2Symbol
MOV [ESI],BL
INC CounterOsInThirdRowB
CMP AL,'7'
JNE CheckNextNumber5
INC CounterOsInFirstColumnB
INC CounterOsInRightDiagonalB
JMP Done
CheckNextNumber5:
CMP AL,'8'
JNE CheckNextNumber6
INC CounterOsInSecondColumnB
JMP Done
CheckNextNumber6:
CMP AL,'9'
JNE Done
INC CounterOsInThirdColumnB
INC CounterOsInLeftDiagonalB
Done:
DEC MovesLeftB
CALL WIN
;CALL TIE
LWonorTie:
RET
PlayerBturn ENDP
;----------------------------------------------------------
;----------------------------------------------------------
;WIN Proc
;checks if any of the players won
;Receives: The board
;Returns: Nothing
;Requires: Proc PlayerA, PlayerB
;----------------------------------------------------------
WIN PROC
MOV AL,CounterXsInFirstRowB
CMP AL, 3
JE playerAWon
MOV AL, CounterXsInSecondRowB
CMP AL, 3
JE playerAWon
MOV AL, CounterXsInThirdRowB
CMP AL, 3
JE playerAWon
MOV AL,CounterXsInFirstColumnB
CMP AL, 3
JE playerAWon
MOV AL, CounterXsInSecondColumnB
CMP AL, 3
JE playerAWon
MOV AL, CounterXsInThirdColumnB
CMP AL, 3
JE playerAWon
MOV AL,CounterXsInRightDiagonalB
CMP AL, 3
JE playerAWon
MOV AL, CounterXsInLeftDiagonalB
CMP AL, 3
JE playerAWon
JMP checkPlayer2
playerAWon:
MOV EDX, OFFSET PlayerAWonB
CALL WRITESTRING
CALL CRLF
CALL CRLF
CALL DrawGameBoard
INC PlayerAScore
MOV WonOrTie , 1
ret
checkPlayer2:
MOV AL,CounterOsInFirstRowB
CMP AL, 3
JE playerBWon
MOV AL, CounterOsInSecondRowB
CMP AL, 3
JE playerBWon
MOV AL, CounterOsInThirdRowB
CMP AL, 3
JE playerBWon
MOV AL,CounterOsInFirstColumnB
CMP AL, 3
JE playerBWon
MOV AL, CounterOsInSecondColumnB
CMP AL, 3
JE playerBWon
MOV AL, CounterOsInThirdColumnB
CMP AL, 3
JE playerBWon
MOV AL,CounterOsInRightDiagonalB
CMP AL, 3
JE playerBWon
MOV AL, CounterOsInLeftDiagonalB
CMP AL, 3
JE playerBWon
JMP done
playerBWon:
MOV EDX, OFFSET PlayerBWonB
CALL WRITESTRING
CALL CRLF
CALL CRLF
CALL DrawGameBoard
INC PlayerBScore
mov WonOrTie , 1
ret
done:
CALL TIE
RET
WIN ENDP
;--------------------------------------------------------------

;----------------------------------------------------------
;----------------------------------------------------------
;TIE Proc
;checks if there is a tie
;Receives: The board
;Returns: Nothing
;Requires: Proc PlayerA, PlayerB
;----------------------------------------------------------
TIE PROC
cmp MovesLeftB , 0 ; Checks to see whether its the last move or not
JNE SomeoneWon ; If it is not the last move - > goto end the procedure
MOV AL,CounterXsInFirstRowB
CMP AL, 3
JE SomeoneWon
MOV AL, CounterXsInSecondRowB
CMP AL, 3
JE SomeoneWon
MOV AL, CounterXsInThirdRowB
CMP AL, 3
JE SomeoneWon
MOV AL,CounterXsInFirstColumnB
CMP AL, 3
JE SomeoneWon
MOV AL, CounterXsInSecondColumnB
CMP AL, 3
JE SomeoneWon
MOV AL, CounterXsInThirdColumnB
CMP AL, 3
JE SomeoneWon
MOV AL,CounterXsInRightDiagonalB
CMP AL, 3
JE SomeoneWon
MOV AL, CounterXsInLeftDiagonalB
CMP AL, 3
JE SomeoneWon
checkPlayer2:
MOV AL,CounterOsInFirstRowB
CMP AL, 3
JE SomeoneWon
MOV AL, CounterOsInSecondRowB
CMP AL, 3
JE SomeoneWon
MOV AL, CounterOsInThirdRowB
CMP AL, 3
JE SomeoneWon
MOV AL,CounterOsInFirstColumnB
CMP AL, 3
JE SomeoneWon
MOV AL, CounterOsInSecondColumnB
CMP AL, 3
JE SomeoneWon
MOV AL, CounterOsInThirdColumnB
CMP AL, 3
JE SomeoneWon
MOV AL,CounterOsInRightDiagonalB
CMP AL, 3
JE SomeoneWon
MOV AL, CounterOsInLeftDiagonalB
CMP AL, 3
JE SomeoneWon
TieFound:
MOV EDX, OFFSET TieMessageB ; Prints that its a tie and goes to ask the user whether he wants to cont or not
CALL WRITESTRING
CALL CRLF
CALL CRLF
CALL DrawGameBoard
mov WonOrTie , 1
SomeoneWon:
RET
TIE ENDP
;----------------------------------------------------------
;Helper Procedure : [CpyArr Proc]
;Copies one BYTE Array to the other
;Receives: Source Array , Destination Array , LengthOf SourceArray
;Returns: Nothing
;Requires: Nothing
;----------------------------------------------------------
CpyArr PROC source:PTR BYTE , target:PTR BYTE  , srcLength:DWORD
cld ; direction = forward
mov esi , source
mov edi , target
mov ecx, srcLength
rep movsb
ret
CpyArr ENDP
;--------------------------------------------------------------
;----------------------------------------------------------
;Helper Procedure : [InitializeVars]
;Initializes all the counters
;Receives: Nothing
;Returns: Nothing
;Requires: Nothing
;----------------------------------------------------------
InitializeVars PROC
mov MovesLeftB , 9
mov CounterXsInFirstRowB , 0
mov CounterXsInSecondRowB , 0
mov CounterXsInThirdRowB , 0
mov CounterOsInFirstRowB , 0
mov CounterOsInSecondRowB , 0
mov CounterOsInThirdRowB , 0
mov CounterXsInFirstColumnB , 0
mov CounterXsInSecondColumnB , 0
mov CounterXsInThirdColumnB , 0
mov CounterOsInFirstColumnB , 0
mov CounterOsInSecondColumnB , 0
mov CounterOsInThirdColumnB , 0
mov CounterXsInRightDiagonalB , 0
mov CounterXsInLeftDiagonalB , 0
mov CounterOsInRightDiagonalB , 0
mov CounterOsInLeftDiagonalB , 0
INVOKE CpyArr	, OFFSET INITFirstRowB , OFFSET TheFirstRowB , LENGTHOF TheFirstRowB
INVOKE CpyArr	, OFFSET INITSecondRowB , OFFSET TheSecondRowB , LENGTHOF TheSecondRowB
INVOKE CpyArr	, OFFSET INITThirdRowB , OFFSET TheThirdRowB , LENGTHOF TheThirdRowB
ret
InitializeVars ENDP
;--------------------------------------------------------------
;----------------------------------------------------------
; DisplayScores 
;Displays the scores of Player A and Player B
;Receives: Nothing
;Returns: Nothing
;Requires: Nothing
;----------------------------------------------------------
DisplayScores PROC 
mov eax , 0
mov  eax,yellow+(blue*16)
call SetTextColor
mov edx , OFFSET P1Name
call WriteString
mov edx , OFFSET StrPlayerAScore
call WriteString
mov al , PlayerAScore
call WriteDec
call Crlf
mov  eax,yellow+(red*16)
call SetTextColor
mov edx , OFFSET P2Name
call WriteString
mov edx , OFFSET StrPlayerBScore
call WriteString
mov al , PlayerBScore
call WriteDec
call Crlf
mov  eax,white+(black*16)
call SetTextColor
ret
DisplayScores ENDP
;--------------------------------------------------------------
;----------------------------------------------------------
; PromptNames
;Prompt Name for P1 & P2
;Receives: String for P1 , P2
;Returns: Nothing
;Requires: Nothing
;----------------------------------------------------------
PromptNames PROC
mov edx , OFFSET PromptP1Name
call WriteString
mov edx , OFFSET P1Name
mov ecx , 20
call ReadString
call Crlf
mov edx , OFFSET PromptP2Name
call WriteString
mov edx , OFFSET P2Name
mov ecx , 20
call ReadString
call Crlf
mov edx , OFFSET P1Name
call WriteString
mov edx , OFFSET PromptSymbol
call WriteString
call Crlf
call ReadChar
call WriteChar
call Crlf
mov P1Symbol , al
ReInput:
mov edx , OFFSET P2Name
call WriteString
mov edx , OFFSET PromptSymbol
call WriteString
call Crlf
call ReadChar
cmp al , P1Symbol
jne Valid
Invalid:
mov edx , OFFSET InvalidInputB
call crlf
call WriteString
jmp ReInput
Valid:
call WriteChar
call Crlf
mov P2Symbol , al
mov edx , OFFSET PromptKey
call WriteString
call ReadInt
ret
PromptNames ENDP
;--------------------------------------------------------------
Check PROC 
L:
	MOV BL, [ESI]
	CMP BL,AL
	JE EndF
	Inc ESI
LOOP L
mov CheckB,0
ret
EndF:
mov CheckB , 1
ret
Check ENDP
;-----------------------------------------------------------------------------------------
main PROC
call PromptNames	
GameLoop:
call InitializeVars
call Clrscr
CALL DrawGameBoard
CALL PlayerAturn
cmp WonOrTie , 1
je LeaveProgram
CALL DrawGameBoard
CALL PlayerBturn
cmp WonOrTie , 1
je LeaveProgram
CALL DrawGameBoard
CALL PlayerAturn
cmp WonOrTie , 1
je LeaveProgram
CALL DrawGameBoard
CALL PlayerBturn
cmp WonOrTie , 1
je LeaveProgram
CALL DrawGameBoard
CALL PlayerAturn
cmp WonOrTie , 1
je LeaveProgram
CALL DrawGameBoard
CALL PlayerBturn
cmp WonOrTie , 1
je LeaveProgram
CALL DrawGameBoard
CALL PlayerAturn
cmp WonOrTie , 1
je LeaveProgram
CALL DrawGameBoard
CALL PlayerBturn
cmp WonOrTie , 1
je LeaveProgram
CALL DrawGameBoard
call PlayerAturn
cmp WonOrTie , 1
je LeaveProgram
CALL DrawGameBoard
JMP GameLoop
LeaveProgram:
	call DisplayScores	
	mov edx , OFFSET NewGameMessageB ; Asks the user if he wants to continue or not
	call Crlf
	call WriteString
	call ReadInt
	cmp al , 1 ; Checks if 1 is entered or not by the user
	mov WonOrTie , 0
	je GameLoop ; If user chooses 1[yes] jumps to GameLoop

	exit
main ENDP




END main