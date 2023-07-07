; Arithmetic.asm
; ASSEMBLY IMPLEMENTATION OF STEP 5
; Andrew Friedman
; ECE 2031 CS
; 07/06/2023

; init program
ORG 0

; double value in init & check if over max
Double:	
    LOAD	Curr            ; load current value
    SHIFT 	1               ; *= 2
    STORE 	Curr            ; cache result
    SUB 	Max             ; -= 1200
    JNEG	Double          ; not over so not finished double
    JZERO	Double          ; not over so not finished double

; subtract 50 from init & check if under min
Subtract:
    LOAD 	Curr            ; load current value
    SUB		Fifty           ; -= 50
    STORE 	Curr            ; cache result
    SUB		Min             ; -= 1196
    JPOS 	Subtract        ; not under so not finished sub
    JZERO	Subtract        ; not under so not finished sub
    LOAD 	Curr            ; load final result

Finish:						; infinite loop
	JUMP 	Finish			; goto 27

; values
Curr:	DW	162
; static values
Fifty:	DW	50
Max:	DW 	1200
Min: 	DW 	1196