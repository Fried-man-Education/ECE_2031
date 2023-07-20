; DetectChange.asm
; Displays the value from the audio peripheral

ORG 0
	; Get data from the audio peripheral
	IN     Sound
	STORE  LastSound
	IN     Timer
	STORE  StartTime
	
	; Check if the new input sound is larger than twice the averaged Sound
	LOAD   AverageSound     ; Load the average sound value into the accumulator
	SHIFT  1                ; Double the average sound level by shifting bits to the left
	SUB    LastSound        ; Subtract the last sound from the double of the average sound, placing the result in the accumulator
	JNEG   DetectedChange   ; If the result is negative (indicating that the last sound is larger than twice the average sound), jump to DetectedChange


	; Check if the new input sound is smaller than half of the averaged Sound
    LOAD   AverageSound     ; Load the average sound value into the accumulator again
    SHIFT  -1               ; Halve the average sound level
    SUB    LastSound        ; Subtract the last sound from half of the average sound, placing the result in the accumulator
    JPOS   DetectedChange   ; If the result is positive (indicating that the last sound is smaller than half of the average sound), jump to DetectedChange

    LOAD   InputCount       ; Load the count of sound level data points
    CALL   CalculateAverage ; Call the subroutine to calculate the new average sound level
	
	; Display the average sound value on Hex 0
	; CALL Delay
	LOAD   AverageSound
	OUT    Hex0            ; Displays the average
    ; Display most-significant 10 bits of the magnitude on LEDs
    ;CALL   Abs
    ;SHIFT  -6
    ;OUT    LEDs
	; Do it again
	JUMP   0

DetectedChange:
    IN     Timer            		; Read the current system time value using the Timer input. This time corresponds to the moment the sound level change was detected.
    STORE  DetectedSoundStartTime 	; Store the detected change start time in the DetectedSoundStartTime data word. This time will be used as a reference point to calculate the duration of the detected sound change.

    ; Calculate the time since the detected sound and output to Hex1
    IN     Timer            		; Read the current system time again. This time corresponds to the current moment in the execution of the program.
    SUB    DetectedSoundStartTime 	; Subtract the DetectedSoundStartTime from the current time. The result of this operation is the duration (in cycles) since the detected sound change.
    OUT    Hex1             		; Output this duration to Hex1. Hex1 will now display the number of cycles that have passed since the detected sound change.

    ; Return to the beginning
    JUMP   0

CalculateAverage:
	LOAD  Total			    ; Load the current total
	AND   Zero			    ; Set the total to zero
    STORE Total
    LOAD InputCount
	STORE Temp				; Temp variable stores the number of sound inputs
	CALL CalculateTotal		; Call the subroutine to calculate the sum of all the previous sound values
	LOAD InputCount			; Increment input count for averaging
	ADD  One
	STORE InputCount
	STORE Temp				; Temp variable stores the new number of sound inputs
    LOAD Total
    STORE AverageSound		; Store the current total in averageSound, so that in the FindLargestBit subroutine, we can change the AverageSound directly
	CALL FindLargestBit		; Now AverageSound stores a start point to estimate the true average value
	LOAD InputCount			
	STORE Temp				
	CALL FindTrueAverage	; Call FindTrueAverage subroutine to find the true average with a start point stored in Average Sound and input count stored in temp
	LOAD TempSum			; After calling the subroutine, reset tempsum to 0 for future use
	AND Zero
	STORE TempSum
	RETURN

; Subroutine to calculate the sum of all the previous sound values
; according to current average sound level and new sound input
CalculateTotal:
	LOAD  Total
	ADD   AverageSound  	; Add averageSound until input count goes to 0
	STORE Total
	LOAD  Temp
	SUB   One				; decrement input count until 0
    STORE Temp
	JPOS  CalculateTotal	
	LOAD  Total				; now Total has previous AverageSound * inputCount
	ADD   LastSound			; add the new sound level to total for averaging
	STORE Total				; Total stores the sum of all the input sound levels
	RETURN

; Subroutine to find the largest bit of InputCount to find the next largest average that divides by 2^n
; For example, if InputCount is 0b11, next largest average is stored as Total/2 because the next smallest value in form of 2^n is 2
; We use this next largest average to find the true average value quicker
FindLargestBit:
	LOAD Temp
	SUB One
	JZERO DividerIsOne		; If input count is 1, no need to change the averageSound
	LOAD AverageSound		
	SHIFT -1				; Or shift AverageSound by 1 to divide by two, because the input count is greater than 1, which means at least 2
	STORE AverageSound		; Store this value to AverageSound
	LOAD Temp				; Load input count
	SHIFT -1				; Shift right by 1 bit
	STORE Temp
	SUB One					; subtract 1 to see if this bit is the last bit that is 1
	JPOS FindLargestBit		; If there are more bits in input count that is 1, loop back and find the largest bit
	RETURN
DividerIsOne:
	LOAD Total
	STORE AverageSound
	RETURN

; Subroutine to find the true average with a start point stored in Average Sound and input count stored in temp
FindTrueAverage:
	LOAD TempSum			; TempSum is used to check if the current AverageSound is floor of total/input count
	ADD AverageSound		; Add AverageSound to Tempsum until input count goes to 0, same as inputCount * AverageSound
	STORE TempSum
	LOAD Temp
	SUB One
	STORE Temp
	JPOS FindTrueAverage
	LOAD Total				; Total - TempSum to see if inputCount * AverageSound is smaller than total
	SUB TempSum				; If Total - TempSum is greater than 0, AverageSound is valid, code returns
	JNEG DecrementAverageSound	; if not, decrement the AverageSound to find the true value
	RETURN
DecrementAverageSound:
	LOAD AverageSound		
	SUB One					; decrement AverageSound
	STORE AverageSound
	LOAD TempSum
	AND Zero
	STORE TempSum
    LOAD InputCount
	STORE Temp
	JUMP FindTrueAverage	; Use the subroutine above to check if this new averageSound is good, if not, it will come back into this method

Delay:
	OUT    Timer
WaitingLoop:
	IN     Timer
	ADDI   -1
	JNEG   WaitingLoop
	RETURN

; Subroutine to get the absolute value.
; Additional subroutine for negation is made available,
; since that's required for absolute value anyway.
Abs:
	JNEG   Negate
    RETURN ; positive or zero; just return
Negate:
	STORE  NegTemp
    SUB    NegTemp
    SUB    NegTemp
	RETURN
	
StartTime: DW 0
NegTemp: DW 0
LastSound: DW 0
AverageSound: DW 0
InputCount: DW 0
Temp: DW 0
LargestBit: DW 0
Total: DW 0
TempSum: DW 0
One:       DW &B0000000001
Zero:      DW &B0000000000
LastSoundRange: DW 0
DetectedSoundStartTime: DW 0

; IO address constants
Switches:  EQU 000
LEDs:      EQU 001
Timer:     EQU 002
Hex0:      EQU 004
Hex1:      EQU 005
Sound:     EQU &H50
