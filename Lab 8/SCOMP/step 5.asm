; step 5.asm
; ASSEMBLY FOR LIGHT CHASING GAME
; Andrew Friedman
; ECE 2031 CS
; 07/11/2023

ORG 0
Init:	
	LOADI 0  				; Load immediate value 0 into the accumulator
	STORE Initial  			; Store accumulator value in the Initial variable
	STORE LEDDisp  			; Initialize LEDDisp to 0
	OUT LEDs  				; Output accumulator value to LEDs
	LOADI 0  				; Load immediate value 0 into the accumulator
	STORE Score  			; Initialize Score to 0
	OUT Hex0  				; Output accumulator value to Hex0
	LOADI 1  				; Load immediate value 1 into the accumulator
	STORE Round  			; Initialize Round to 1
	OUT	Hex1  				; Output accumulator value to Hex1

SwitchHold: 
	IN Switches  			; Input from switches
	OR Initial  			; Or the input value with Initial
	JZERO Game  			; If the result is zero, jump to Game
	JUMP SwitchHold  		; If not, continue polling SwitchHold

Game: 
	LOAD LEDDisp  			; Load LEDDisp into the accumulator
	OUT LEDs  				; Output accumulator value to LEDs
	Call Delay  			; Call the Delay subroutine
	IN Switches  			; Input from switches
	JZERO NextLED  			; If the input is zero, jump to NextLED
	
	LOAD LEDDisp  			; Load LEDDisp into the accumulator
	Call Count1s  			; Call the Count1s subroutine
	SUB Round  				; Subtract Round from accumulator
	JPOS Next  				; If the result is positive, jump to Next
	JNEG Next  				; If the result is negative, jump to Next

	Win:   
		LOAD Score  		; Load Score into the accumulator
		ADDI 1  			; Increment the accumulator
		STORE Score  		; Store accumulator value in the Score variable
	Next:	  
		LOAD Round  		; Load Round into the accumulator
		ADDI 1  			; Increment the accumulator
		STORE Round  		; Store accumulator value in the Round variable
		OUT Hex1  			; Output accumulator value to Hex1
		LOAD Score  		; Load Score into the accumulator
		OUT Hex0  			; Output accumulator value to Hex0
		LOAD Initial  		; Load Initial into the accumulator
		STORE LEDDisp  		; Store accumulator value in the LEDDisp variable
		JUMP SwitchHold  	; Jump back to SwitchHold

NextLED: 
	LOAD LEDDisp  			; Load LEDDisp into the accumulator
	ADDI &B0000000001  		; Increment the accumulator
	STORE LEDDisp  			; Store accumulator value in the LEDDisp variable
	JUMP Game  				; Jump back to Game


; Delay func
Delay:
	OUT Timer
WaitingLoop:
	IN Timer
	ADDI -7
	JNEG WaitingLoop
	RETURN

; Count1s - Subroutine to count the number
; of 1s in the accumulator.  Result is
; returned in accumulator.
; Does not work if MSb is 1.
Count1s:
  STORE  C1Val    ; Save AC for later
  LOADI  0        ; Reset count variable
  STORE  C1Count
  LOAD   C1Val 
  JNEG   C1Ret    ; Return if MSb is 1
C1Loop:
  AND    C1One    ; Mask LSb
  ADD    C1Count  ; Add to count
  STORE  C1Count  ; Store new count
  LOAD   C1Val 
  SHIFT  -1       ; Shift to the right
  STORE  C1Val 
  JPOS   C1Loop   ; Loop until 0
C1Ret:
  LOAD   C1Count  ; The value to return
  RETURN
C1One:   DW 1
C1Val:   DW 0
C1Count: DW 0

; Game variables
Round: DW 0
Score: DW 0
Initial: DW &B0000000000
LEDDisp: DW &B0000000000

; Constant values for IO
Switches: EQU 000
LEDs: EQU 001
Timer: EQU 002
Hex0: EQU 004
Hex1: EQU 005
