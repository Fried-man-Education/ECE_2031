; SimpleDemo.asm
; Tests basic instructions in SCOMP

ORG 0

	; Some basic math
	LOAD   One
	ADD    Two
	ADD    NegTwo
	ADDI   5
	ADDI   -5
	SUB    Three
	SUB    NegThree
    
    ; Some basic memory operations
    STORE  Temp         ; What value gets stored?
    ADD    Temp
    LOAD   Temp         ; Is AC now 1 or 2?
	
	; Some basic logic
	LOADI  0
	OR     LowByte
	AND    Bit2
	XOR    LowByte
	SHIFT  4
	SHIFT  -4
	
	; Jumps
	LOADI  0
	JNEG   WrongJump    ; 0 is not negative
	JZERO  CheckJPOS
	
WrongJump:
	LOADI  &HEE         ; 0xEE in AC indicates an error
	JUMP   WrongJump    ; Infinite loop

CheckJPOS:
	LOADI  -8
	JPOS   WrongJump    ; -8 is not positive
	LOADI  0
	JPOS   WrongJump    ; 0 is not positive
	LOADI  8
	JPOS   Questions    ; 8 IS positive, so...
	JUMP   WrongJump    ; if that jump fails, something is wrong

Questions:
	LOADI  &H1337         ; Why doesn't this operand work?
	OR     255          ; Why doesn't AC get OR'd with 255 (0xFF)?
	
Finish:
	LOAD   Buzz
	JUMP   Finish       ; Infinite loop
	
; Useful values
One:       DW   1
Two:       DW   2
Three:     DW   3
NegOne:    DW  -1
NegTwo:    DW  -2
NegThree:  DW  -3
Bit0:      DW  &B0001
Bit1:      DW  &B0010
Bit2:      DW  &B0100
Bit3:      DW  &B1000
LowByte:   DW  &H00FF
Buzz:      DW  &HABEE
Temp:      DW  0
