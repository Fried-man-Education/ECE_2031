; step 6 - pre.asm
; ASSEMBLY IMPLEMENTATION OF LOAD, ADD, STORE, LOOP
; Andrew Friedman
; ECE 2031 CS
; 07/06/2023

; init program
ORG 0
	LOADI	5 				; set AC to 5
	ADD	ADDED				; add 0x24 to AC
	STORE 	TARGET			; put AC contents at 0x1A
Finish:						; infinite loop
	JUMP 	Finish			; goto 12

; pre-set values
ORG &H012
	ADDED: 		DW	&H24	; value to be added on
ORG &H01A					; memory destination
	TARGET:		DW	&H0		; zero out memory