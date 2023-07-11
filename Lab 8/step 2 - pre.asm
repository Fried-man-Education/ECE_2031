; step 2 - pre.asm
; MULTIPLIES 13 BY 20 TWICE AND STORES RESULTS THEN LOOPS INDEFINITELY
; Andrew Friedman
; ECE 2031 CS
; 07/11/2023

; init program
ORG 0
  LOADI 	13		; init value
  CALL	Mul20		; AC *= 20
  STORE Result1		; setup output first output
  CALL 	Mul20		; AC *= 20
  STORE	Result2		; setup output first output
  
; end loop
Finish:	
	JUMP 	Finish  ; inf looper
	
; AC * 20 function
Mul20:	
	STORE CURR 		; boot temp variable
    SHIFT 4 		; *= 16
    ADD	CURR 		; += curr
    ADD	CURR 		; += curr
    ADD	CURR 		; += curr
    ADD	CURR 		; += curr
    RETURN			; goto origin

; temp & output variables
CURR: DW 0			; Mul20 func temp variable
Result1: DW 0		; AC * 20
Result2: DW 0		; AC * 400