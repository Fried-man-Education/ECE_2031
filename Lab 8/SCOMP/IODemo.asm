; IODemo.asm
; Produces a "bouncing" animation on the LEDs.
; The LED pattern is initialized with the switch state.
; Andrew Friedman
; ECE 2031 CS
; 07/11/2023

ORG 0

	; Get and store the switch values
	IN     Switches
    STORE  PatternInit	; save initial switch values
	OUT    LEDs
	STORE  Pattern
	
Left:
	; Slow down the loop so humans can watch it.
;	CALL   Delay

	; Check if the left place is 1 and if so, switch direction
    CALL   SwitchFlip	; check for channges in switches state
	LOAD   Pattern
	AND    Bit9         ; bit mask
	JPOS   Right        ; bit9 is 1; go right

	LOAD   Pattern
	SHIFT  1
	STORE  Pattern
	OUT    LEDs

	JUMP   Left
	
Right:
	; Slow down the loop so humans can watch it.
;	CALL   Delay

	; Check if the right place is 1 and if so, switch direction
   	CALL   SwitchFlip   ; check for channges in switches state
	LOAD   Pattern
	AND    Bit0         ; bit mask
	JPOS   Left         ; bit0 is 1; go left
	
	LOAD   Pattern
	SHIFT  -1
	STORE  Pattern
	OUT    LEDs
	
	JUMP   Right
	
; To make things happen on a human timescale, the timer is
; used to delay for half a second.
Delay:
	OUT    Timer
WaitingLoop:
	IN     Timer
	ADDI   -5
	JNEG   WaitingLoop
	RETURN

SwitchFlip:
	IN     Switches		; Get current state of switches
	XOR    PatternInit 	; Compare current and initial switch state
	JZERO  Break 		; If 0, switch states are the same and break
   	IN     Switches 	; read switches again
   	STORE  PatternInit 	; initial state = new state (for later comparisons)
   	STORE  Pattern 		; current LED pattern = new state
	OUT    LEDs			; update LED state
Break: RETURN

; Variables
Pattern:   DW 0
PatternInit:   DW &B0000000000

; Useful values
Bit0:      DW &B0000000001
Bit9:      DW &B1000000000

; IO address constants
Switches:  EQU 000
LEDs:      EQU 001
Timer:     EQU 002
Hex0:      EQU 004
Hex1:      EQU 005
