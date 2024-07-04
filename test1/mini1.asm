system_port_a:  EQU	10H;I/O address port a
system_port_b:  EQU	11H;I/O address port b
system_port_C:  EQU	12H;I/O address port c	
CTRLR:		EQU	13H;I/O address control port 
	
		ORG	802CH		; RST 5.5
		JMP	ISR_5_5

		ORG	8034H		; RST 6.5
		JMP	ISR_6_5
		
		ORG	8100H
		LXI	SP,0F000H

		MVI 	A, 00001100B	;set mask 
		SIM    			;Set interrupt masking
		EI			;Enable interrupt

		MVI	A,90H ;10010000B -SET PORT A AS INPUT AND PORT B C AS OUTPUT
		OUT	CTRLR



START:		MVI	E, 07H		;INITIATE LCD
		RST	1
		CALL	dlyz
		MVI	E, 09H		;CLEAR LCD
		RST	1
		CALL	dlyz
		CALL	dlyz
		
main:		
		call 	clr7	
		LXI	H, 0000H	;----1STLINE
		MVI	E, 0AH		;GOTO_XY LCD
		RST	1
		LXI	H, MAIN1
		MVI	E, 0BH		;PUTSTRING AT LCD
		RST	1

		LXI	H, 0401H	;----2NDLINE
		MVI	E, 0AH		
		RST	1
		LXI	H, MAIN50
		MVI	E, 0BH		
		RST	1

		LXI	H, 0402H	;----3RDLINE
		MVI	E, 0AH		
		RST	1
		LXI	H, MAIN20
		MVI	E, 0BH		
		RST	1

		LXI	H, 0403H	;----4THLINE
		MVI	E, 0AH		
		RST	1
		LXI	H, MAIN10
		MVI	E, 0BH		
		RST	1
		
meno:			
		mvi	h,00h
		mvi	l,07h
		shld	ctr
		call	scan 
		lda 	key
		cpi	010	;button '1'
		cz	main2	;jump to subroutine main2 when "1" is pressed
		cpi	12h	;button '2'
		cz	main3	;jump to subroutine main3 when "2" is pressed
		cpi	1ah	;button '3'
		cz	main4	;jump to subroutine main4 when "3" is pressed
		jmp	meno

;-------------------------------------------------------------------------

kosong:		call	clr7
		call	DISPSEVSEG
main2:  ; Main routine for handling 50 cent coins

    ; MVI A,0
    ; STA GP
    ; LDA GP
    ; INR A
    ; STA GP

    mvi h,00h               ; Load H register with 00h
    mvi l,07h               ; Load L register with 07h
    shld ctr                ; Store HL pair to memory location 'ctr'
    call scan               ; Call scan subroutine
    lda key                 ; Load accumulator with the value at memory location 'key'
    cpi 02                  ; Compare accumulator with 02
    cz main                 ; Jump to 'main' if zero (equal)
    cpi 1DH                 ; Compare accumulator with 1DH
    cz R5                   ; Jump to 'R5' if zero (equal)

    MVI E, 07H              ; Load E register with 07H
    RST 1                   ; Restart, call address 8
    CALL dlyz               ; Call delay subroutine
    MVI E, 09H              ; Load E register with 09H
    RST 1                   ; Restart, call address 8
    CALL dlyz               ; Call delay subroutine

    LXI H, 0500H            ; Load HL pair with address 0500H
    MVI E, 0AH              ; Load E register with 0AH
    RST 1                   ; Restart, call address 8
    LXI H, UNIVERSAL        ; Load HL pair with address of UNIVERSAL
    MVI E, 0BH              ; Load E register with 0BH
    RST 1                   ; Restart, call address 8

    LXI H, 0501H            ; Load HL pair with address 0501H
    MVI E, 0AH              ; Load E register with 0AH
    RST 1                   ; Restart, call address 8
    LXI H, FIFTY            ; Load HL pair with address of FIFTY
    MVI E, 0BH              ; Load E register with 0BH
    RST 1                   ; Restart, call address 8

RES0:   MVI A, 00001100B     ; Load accumulator with binary value 00001100 (set mask)
    SIM                     ; Set interrupt masking
    EI                      ; Enable interrupts

    LXI H, 0500H            ; Load HL pair with address 0500H
    MVI E, 0AH              ; Load E register with 0AH
    RST 1                   ; Restart, call address 8
    LXI H, UNIVERSAL        ; Load HL pair with address of UNIVERSAL
    MVI E, 0BH              ; Load E register with 0BH
    RST 1                   ; Restart, call address 8

    LXI H, 0501H            ; Load HL pair with address 0501H
    MVI E, 0AH              ; Load E register with 0AH
    RST 1                   ; Restart, call address 8
    LXI H, FIFTY            ; Load HL pair with address of FIFTY
    MVI E, 0BH              ; Load E register with 0BH
    RST 1                   ; Restart, call address 8

    LDA BUFFER+5            ; Load accumulator with value from BUFFER+5
    LXI H, SEVSEGDATA       ; Load HL pair with address of SEVSEGDATA
    MVI D,0                 ; Load D register with 0
    MOV E,A                 ; Move value in accumulator to E register
    DAD D                   ; Add DE pair to HL pair
    MOV A,M                 ; Move value at memory location in HL pair to accumulator
    STA DIGIT+5             ; Store accumulator value to DIGIT+5
    CALL DISPSEVSEG         ; Call display seven-segment subroutine
    CALL DLY                ; Call delay subroutine

    CALL DISPSEVSEG         ; Call display seven-segment subroutine
    LDA BUFFER+4            ; Load accumulator with value from BUFFER+4
    LXI H, SEVSEGDATA       ; Load HL pair with address of SEVSEGDATA
    MVI D,0                 ; Load D register with 0
    MOV E,A                 ; Move value in accumulator to E register
    DAD D                   ; Add DE pair to HL pair
    MOV A,M                 ; Move value at memory location in HL pair to accumulator
    STA DIGIT+4             ; Store accumulator value to DIGIT+4
    CALL DISPSEVSEG         ; Call display seven-segment subroutine
    CALL DLY                ; Call delay subroutine

    CALL DISPSEVSEG         ; Call display seven-segment subroutine
    LDA BUFFER+3            ; Load accumulator with value from BUFFER+3
    LXI H, SEVSEGDATA       ; Load HL pair with address of SEVSEGDATA
    MVI D,0                 ; Load D register with 0
    MOV E,A                 ; Move value in accumulator to E register
    DAD D                   ; Add DE pair to HL pair
    MOV A,M                 ; Move value at memory location in HL pair to accumulator
    STA DIGIT+3             ; Store accumulator value to DIGIT+3
    CALL DISPSEVSEG         ; Call display seven-segment subroutine
    CALL DLY                ; Call delay subroutine

    CALL DISPSEVSEG         ; Call display seven-segment subroutine
    LDA BUFFER+2            ; Load accumulator with value from BUFFER+2
    LXI H, SEVSEGDATA       ; Load HL pair with address of SEVSEGDATA
    MVI D,0                 ; Load D register with 0
    MOV E,A                 ; Move value in accumulator to E register
    DAD D                   ; Add DE pair to HL pair
    MOV A,M                 ; Move value at memory location in HL pair to accumulator
    STA DIGIT+2             ; Store accumulator value to DIGIT+2
    CALL DISPSEVSEG         ; Call display seven-segment subroutine
    CALL DLY                ; Call delay subroutine

    CALL DISPSEVSEG         ; Call display seven-segment subroutine
    LDA BUFFER+1            ; Load accumulator with value from BUFFER+1
    LXI H, SEVSEGDATA       ; Load HL pair with address of SEVSEGDATA
    MVI D,0                 ; Load D register with 0
    MOV E,A                 ; Move value in accumulator to E register
    DAD D                   ; Add DE pair to HL pair
    MOV A,M                 ; Move value at memory location in HL pair to accumulator
    STA DIGIT+1             ; Store accumulator value to DIGIT+1
    CALL DISPSEVSEG         ; Call display seven-segment subroutine
    CALL DLY                ; Call delay subroutine

    CALL DISPSEVSEG         ; Call display seven-segment subroutine
    LDA BUFFER              ; Load accumulator with value from BUFFER
    LXI H, SEVSEGDATA       ; Load HL pair with address of SEVSEGDATA
    MVI D,0                 ; Load D register with 0
    MOV E,A                 ; Move value in accumulator to E register
    DAD D                   ; Add DE pair to HL pair
    MOV A,M                 ; Move value at memory location in HL pair to accumulator
    STA DIGIT               ; Store accumulator value to DIGIT
    CALL DISPSEVSEG         ; Call display seven-segment subroutine
    CALL DLY                ; Call delay subroutine

    CALL DISPSEVSEG         ; Call display seven-segment subroutine
    CALL GPIO               ; Call GPIO subroutine

    LDA BUFFER+5            ; Load accumulator with value from BUFFER+5
    INR A                   ; Increment accumulator
    STA BUFFER+5            ; Store accumulator value to BUFFER+5
    CPI 10                  ; Compare accumulator with 10
    jnz RES0                ; Jump to RES0 if not zero (not equal)
    CALL NEW1               ; Call NEW1 subroutine
    LDA BUFFER+4            ; Load accumulator with value from BUFFER+4
    INR A                   ; Increment accumulator
    STA BUFFER+4            ; Store accumulator value to BUFFER+4
    CPI 10                  ; Compare accumulator with 10
    jnz RES0                ; Jump to RES0 if not zero (not equal)
    CALL NEW2               ; Call NEW2 subroutine
    LDA BUFFER+3            ; Load accumulator with value from BUFFER+3
    INR A                   ; Increment accumulator
    STA BUFFER+3            ; Store accumulator value to BUFFER+3
    CPI 10                  ; Compare accumulator with 10
    jnz RES0                ; Jump to RES0 if not zero (not equal)
    CALL NEW3               ; Call NEW3 subroutine
    LDA BUFFER+2            ; Load accumulator with value from BUFFER+2
    INR A                   ; Increment accumulator
    STA BUFFER+2            ; Store accumulator value to BUFFER+2
    CPI 10                  ; Compare accumulator with 10
    jnz RES0                ; Jump to RES0 if not zero (not equal)
    CALL NEW4               ; Call NEW4 subroutine
    LDA BUFFER+1            ; Load accumulator with value from BUFFER+1
    INR A                   ; Increment accumulator
    STA BUFFER+1            ; Store accumulator value to BUFFER+1
    CPI 10                  ; Compare accumulator with 10
    jnz RES0                ; Jump to RES0 if not zero (not equal)
    CALL NEW5               ; Call NEW5 subroutine
    LDA BUFFER              ; Load accumulator with value from BUFFER
    INR A                   ; Increment accumulator
    STA BUFFER              ; Store accumulator value to BUFFER
    CPI 10                  ; Compare accumulator with 10
    jnz RES0                ; Jump to RES0 if not zero (not equal)
    CALL NEW6               ; Call NEW6 subroutine

    JMP kosong              ; Jump to 'kosong'


;--------------------------------------------------------------------

kosong2:	call	clr7
		call	DISPSEVSEG
main3:  ; Main routine for handling 20 cent coins

    MVI E, 07H          ; Load E register with 07H
    RST 1               ; Restart, call address 8
    CALL dlyz           ; Call delay subroutine
    MVI E, 09H          ; Load E register with 09H
    RST 1               ; Restart, call address 8
    CALL dlyz           ; Call delay subroutine

    mvi h,00h           ; Load H register with 00h
    mvi l,07h           ; Load L register with 07h
    shld ctr            ; Store HL pair to memory location 'ctr'
    call scan           ; Call scan subroutine
    lda key             ; Load accumulator with the value at memory location 'key'
    cpi 02              ; Compare accumulator with 02
    cz main             ; Jump to 'main' if zero (equal)

    LXI H, 0500H        ; Load HL pair with address 0500H
    MVI E, 0AH          ; Load E register with 0AH
    RST 1               ; Restart, call address 8
    LXI H, UNIVERSAL    ; Load HL pair with address of UNIVERSAL
    MVI E, 0BH          ; Load E register with 0BH
    RST 1               ; Restart, call address 8

    LXI H, 0501H        ; Load HL pair with address 0501H
    MVI E, 0AH          ; Load E register with 0AH
    RST 1               ; Restart, call address 8
    LXI H, TWENTY       ; Load HL pair with address of TWENTY
    MVI E, 0BH          ; Load E register with 0BH
    RST 1               ; Restart, call address 8

    call dlyz           ; Call delay subroutine

RES1:   MVI A, 00001100B   ; Load accumulator with binary value 00001100 (set mask)
    SIM                 ; Set interrupt masking
    EI                  ; Enable interrupts

    LXI H, 0500H        ; Load HL pair with address 0500H
    MVI E, 0AH          ; Load E register with 0AH
    RST 1               ; Restart, call address 8
    LXI H, UNIVERSAL    ; Load HL pair with address of UNIVERSAL
    MVI E, 0BH          ; Load E register with 0BH
    RST 1               ; Restart, call address 8

    LXI H, 0501H        ; Load HL pair with address 0501H
    MVI E, 0AH          ; Load E register with 0AH
    RST 1               ; Restart, call address 8
    LXI H, TWENTY       ; Load HL pair with address of TWENTY
    MVI E, 0BH          ; Load E register with 0BH
    RST 1               ; Restart, call address 8

    mvi h,00h           ; Load H register with 00h
    mvi l,07h           ; Load L register with 07h
    shld ctr            ; Store HL pair to memory location 'ctr'
    call scan           ; Call scan subroutine
    lda key             ; Load accumulator with the value at memory location 'key'
    cpi 1DH             ; Compare accumulator with 1DH
    cz R5               ; Jump to 'R5' if zero (equal)

    LDA BUFFER+5        ; Load accumulator with value from BUFFER+5
    LXI H, SEVSEGDATA   ; Load HL pair with address of SEVSEGDATA
    MVI D, 0            ; Load D register with 0
    MOV E, A            ; Move value in accumulator to E register
    DAD D               ; Add DE pair to HL pair
    MOV A, M            ; Move value at memory location in HL pair to accumulator
    STA DIGIT+5         ; Store accumulator value to DIGIT+5
    CALL DISPSEVSEG     ; Call display seven-segment subroutine
    CALL DLY            ; Call delay subroutine

    CALL DISPSEVSEG     ; Call display seven-segment subroutine
    LDA BUFFER+4        ; Load accumulator with value from BUFFER+4
    LXI H, SEVSEGDATA   ; Load HL pair with address of SEVSEGDATA
    MVI D, 0            ; Load D register with 0
    MOV E, A            ; Move value in accumulator to E register
    DAD D               ; Add DE pair to HL pair
    MOV A, M            ; Move value at memory location in HL pair to accumulator
    STA DIGIT+4         ; Store accumulator value to DIGIT+4
    CALL DISPSEVSEG     ; Call display seven-segment subroutine
    CALL DLY            ; Call delay subroutine

    CALL DISPSEVSEG     ; Call display seven-segment subroutine
    LDA BUFFER+3        ; Load accumulator with value from BUFFER+3
    LXI H, SEVSEGDATA   ; Load HL pair with address of SEVSEGDATA
    MVI D, 0            ; Load D register with 0
    MOV E, A            ; Move value in accumulator to E register
    DAD D               ; Add DE pair to HL pair
    MOV A, M            ; Move value at memory location in HL pair to accumulator
    STA DIGIT+3         ; Store accumulator value to DIGIT+3
    CALL DISPSEVSEG     ; Call display seven-segment subroutine
    CALL DLY            ; Call delay subroutine

    CALL DISPSEVSEG     ; Call display seven-segment subroutine
    LDA BUFFER+2        ; Load accumulator with value from BUFFER+2
    LXI H, SEVSEGDATA   ; Load HL pair with address of SEVSEGDATA
    MVI D, 0            ; Load D register with 0
    MOV E, A            ; Move value in accumulator to E register
    DAD D               ; Add DE pair to HL pair
    MOV A, M            ; Move value at memory location in HL pair to accumulator
    STA DIGIT+2         ; Store accumulator value to DIGIT+2
    CALL DISPSEVSEG     ; Call display seven-segment subroutine
    CALL DLY            ; Call delay subroutine

    CALL DISPSEVSEG     ; Call display seven-segment subroutine
    LDA BUFFER+1        ; Load accumulator with value from BUFFER+1
    LXI H, SEVSEGDATA   ; Load HL pair with address of SEVSEGDATA
    MVI D, 0            ; Load D register with 0
    MOV E, A            ; Move value in accumulator to E register
    DAD D               ; Add DE pair to HL pair
    MOV A, M            ; Move value at memory location in HL pair to accumulator
    STA DIGIT+1         ; Store accumulator value to DIGIT+1
    CALL DISPSEVSEG     ; Call display seven-segment subroutine
    CALL DLY            ; Call delay subroutine

    CALL DISPSEVSEG     ; Call display seven-segment subroutine
    LDA BUFFER          ; Load accumulator with value from BUFFER
    LXI H, SEVSEGDATA   ; Load HL pair with address of SEVSEGDATA
    MVI D, 0            ; Load D register with 0
    MOV E, A            ; Move value in accumulator to E register
    DAD D               ; Add DE pair to HL pair
    MOV A, M            ; Move value at memory location in HL pair to accumulator
    STA DIGIT           ; Store accumulator value to DIGIT
    CALL DISPSEVSEG     ; Call display seven-segment subroutine
    CALL DLY            ; Call delay subroutine

    CALL DISPSEVSEG     ; Call display seven-segment subroutine
    CALL GPIO           ; Call GPIO subroutine

    LDA BUFFER+5        ; Load accumulator with value from BUFFER+5
    INR A               ; Increment accumulator
    STA BUFFER+5        ; Store accumulator value to BUFFER+5
    CPI 10              ; Compare accumulator with 10
    CNZ RES1            ; Jump to RES1 if not zero (not equal)
    CALL NEW1           ; Call NEW1 subroutine

    LDA BUFFER+4        ; Load accumulator with value from BUFFER+4
    INR A               ; Increment accumulator
    STA BUFFER+4        ; Store accumulator value to BUFFER+4
    CPI 10              ; Compare accumulator with 10
    CNZ RES1            ; Jump to RES1 if not zero (not equal)
    CALL NEW2           ; Call NEW2 subroutine

    LDA BUFFER+3        ; Load accumulator with value from BUFFER+3
    INR A               ; Increment accumulator
    STA BUFFER+3        ; Store accumulator value to BUFFER+3
    CPI 10              ; Compare accumulator with 10
    CNZ RES1            ; Jump to RES1 if not zero (not equal)
    CALL NEW3           ; Call NEW3 subroutine

    LDA BUFFER+2        ; Load accumulator with value from BUFFER+2
    INR A               ; Increment accumulator
    STA BUFFER+2        ; Store accumulator value to BUFFER+2
    CPI 10              ; Compare accumulator with 10
    CNZ RES1            ; Jump to RES1 if not zero (not equal)
    CALL NEW4           ; Call NEW4 subroutine

    LDA BUFFER+1        ; Load accumulator with value from BUFFER+1
    INR A               ; Increment accumulator
    STA BUFFER+1        ; Store accumulator value to BUFFER+1
    CPI 10              ; Compare accumulator with 10
    CNZ RES1            ; Jump to RES1 if not zero (not equal)
    CALL NEW5           ; Call NEW5 subroutine

    LDA BUFFER          ; Load accumulator with value from BUFFER
    INR A               ; Increment accumulator
    STA BUFFER          ; Store accumulator value to BUFFER
    CPI 10              ; Compare accumulator with 10
    CNZ RES1            ; Jump to RES1 if not zero (not equal)
    CALL NEW6           ; Call NEW6 subroutine

    MVI A, 00001100B    ; Load accumulator with binary value 00001100 (set mask)
    SIM                 ; Set interrupt masking
    EI                  ; Enable interrupts

    JMP kosong2         ; Unconditional jump to 'kosong2'


kosong4:	call	clr7
		call	DISPSEVSEG
main4:  ; Main routine for handling 10 cent coins

    MVI E, 07H          ; Load E register with 07H
    RST 1               ; Restart, call address 8
    CALL dlyz           ; Call delay subroutine
    MVI E, 09H          ; Load E register with 09H
    RST 1               ; Restart, call address 8
    CALL dlyz           ; Call delay subroutine

    mvi h,00h           ; Load H register with 00h
    mvi l,07h           ; Load L register with 07h
    shld ctr            ; Store HL pair to memory location 'ctr'
    call scan           ; Call scan subroutine
    lda key             ; Load accumulator with the value at memory location 'key'
    cpi 02              ; Compare accumulator with 02
    cz main             ; Jump to 'main' if zero (equal)

    LXI H, 0500H        ; Load HL pair with address 0500H
    MVI E, 0AH          ; Load E register with 0AH
    RST 1               ; Restart, call address 8
    LXI H, UNIVERSAL    ; Load HL pair with address of UNIVERSAL
    MVI E, 0BH          ; Load E register with 0BH
    RST 1               ; Restart, call address 8

    LXI H, 0501H        ; Load HL pair with address 0501H
    MVI E, 0AH          ; Load E register with 0AH
    RST 1               ; Restart, call address 8
    LXI H, TEN          ; Load HL pair with address of TEN
    MVI E, 0BH          ; Load E register with 0BH
    RST 1               ; Restart, call address 8

    call dlyz           ; Call delay subroutine

RES4:   MVI A, 00001100B   ; Load accumulator with binary value 00001100 (set mask)
    SIM                 ; Set interrupt masking
    EI                  ; Enable interrupts

    LXI H, 0500H        ; Load HL pair with address 0500H
    MVI E, 0AH          ; Load E register with 0AH
    RST 1               ; Restart, call address 8
    LXI H, UNIVERSAL    ; Load HL pair with address of UNIVERSAL
    MVI E, 0BH          ; Load E register with 0BH
    RST 1               ; Restart, call address 8

    LXI H, 0501H        ; Load HL pair with address 0501H
    MVI E, 0AH          ; Load E register with 0AH
    RST 1               ; Restart, call address 8
    LXI H, TEN          ; Load HL pair with address of TEN
    MVI E, 0BH          ; Load E register with 0BH
    RST 1               ; Restart, call address 8

    LDA BUFFER+5        ; Load accumulator with value from BUFFER+5
    LXI H, SEVSEGDATA   ; Load HL pair with address of SEVSEGDATA
    MVI D, 0            ; Load D register with 0
    MOV E, A            ; Move value in accumulator to E register
    DAD D               ; Add DE pair to HL pair
    MOV A, M            ; Move value at memory location in HL pair to accumulator
    STA DIGIT+5         ; Store accumulator value to DIGIT+5
    CALL DISPSEVSEG     ; Call display seven-segment subroutine
    CALL DLY            ; Call delay subroutine

    CALL DISPSEVSEG     ; Call display seven-segment subroutine
    LDA BUFFER+4        ; Load accumulator with value from BUFFER+4
    LXI H, SEVSEGDATA   ; Load HL pair with address of SEVSEGDATA
    MVI D, 0            ; Load D register with 0
    MOV E, A            ; Move value in accumulator to E register
    DAD D               ; Add DE pair to HL pair
    MOV A, M            ; Move value at memory location in HL pair to accumulator
    STA DIGIT+4         ; Store accumulator value to DIGIT+4
    CALL DISPSEVSEG     ; Call display seven-segment subroutine
    CALL DLY            ; Call delay subroutine

    CALL DISPSEVSEG     ; Call display seven-segment subroutine
    LDA BUFFER+3        ; Load accumulator with value from BUFFER+3
    LXI H, SEVSEGDATA   ; Load HL pair with address of SEVSEGDATA
    MVI D, 0            ; Load D register with 0
    MOV E, A            ; Move value in accumulator to E register
    DAD D               ; Add DE pair to HL pair
    MOV A, M            ; Move value at memory location in HL pair to accumulator
    STA DIGIT+3         ; Store accumulator value to DIGIT+3
    CALL DISPSEVSEG     ; Call display seven-segment subroutine
    CALL DLY            ; Call delay subroutine

    CALL DISPSEVSEG     ; Call display seven-segment subroutine
    LDA BUFFER+2        ; Load accumulator with value from BUFFER+2
    LXI H, SEVSEGDATA   ; Load HL pair with address of SEVSEGDATA
    MVI D, 0            ; Load D register with 0
    MOV E, A            ; Move value in accumulator to E register
    DAD D               ; Add DE pair to HL pair
    MOV A, M            ; Move value at memory location in HL pair to accumulator
    STA DIGIT+2         ; Store accumulator value to DIGIT+2
    CALL DISPSEVSEG     ; Call display seven-segment subroutine
    CALL DLY            ; Call delay subroutine

    CALL DISPSEVSEG     ; Call display seven-segment subroutine
    LDA BUFFER+1        ; Load accumulator with value from BUFFER+1
    LXI H, SEVSEGDATA   ; Load HL pair with address of SEVSEGDATA
    MVI D, 0            ; Load D register with 0
    MOV E, A            ; Move value in accumulator to E register
    DAD D               ; Add DE pair to HL pair
    MOV A, M            ; Move value at memory location in HL pair to accumulator
    STA DIGIT+1         ; Store accumulator value to DIGIT+1
    CALL DISPSEVSEG     ; Call display seven-segment subroutine
    CALL DLY            ; Call delay subroutine

    CALL DISPSEVSEG     ; Call display seven-segment subroutine
    LDA BUFFER          ; Load accumulator with value from BUFFER
    LXI H, SEVSEGDATA   ; Load HL pair with address of SEVSEGDATA
    MVI D, 0            ; Load D register with 0
    MOV E, A            ; Move value in accumulator to E register
    DAD D               ; Add DE pair to HL pair
    MOV A, M            ; Move value at memory location in HL pair to accumulator
    STA DIGIT           ; Store accumulator value to DIGIT
    CALL DISPSEVSEG     ; Call display seven-segment subroutine
    CALL DLY            ; Call delay subroutine

    CALL DISPSEVSEG     ; Call display seven-segment subroutine
    CALL GPIO           ; Call GPIO subroutine

    LDA BUFFER+5        ; Load accumulator with value from BUFFER+5
    INR A               ; Increment accumulator
    STA BUFFER+5        ; Store accumulator value to BUFFER+5
    CPI 9               ; Compare accumulator with 9
    JNZ RES4            ; Jump to RES4 if not zero (not equal)
    CALL NEW1           ; Call NEW1 subroutine

    LDA BUFFER+4        ; Load accumulator with value from BUFFER+4
    INR A               ; Increment accumulator
    STA BUFFER+4        ; Store accumulator value to BUFFER+4
    CPI 9               ; Compare accumulator with 9
    JNZ RES4            ; Jump to RES4 if not zero (not equal)
    CALL NEW2           ; Call NEW2 subroutine

    LDA BUFFER+3        ; Load accumulator with value from BUFFER+3
    INR A               ; Increment accumulator
    STA BUFFER+3        ; Store accumulator value to BUFFER+3
    CPI 9               ; Compare accumulator with 9
    JNZ RES4            ; Jump to RES4 if not zero (not equal)
    CALL NEW3           ; Call NEW3 subroutine

    LDA BUFFER+2        ; Load accumulator with value from BUFFER+2
    INR A               ; Increment accumulator
    STA BUFFER+2        ; Store accumulator value to BUFFER+2
    CPI 9               ; Compare accumulator with 9
    JNZ RES4            ; Jump to RES4 if not zero (not equal)
    CALL NEW4           ; Call NEW4 subroutine

    LDA BUFFER+1        ; Load accumulator with value from BUFFER+1
    INR A               ; Increment accumulator
    STA BUFFER+1        ; Store accumulator value to BUFFER+1
    CPI 9               ; Compare accumulator with 9
    JNZ RES4            ; Jump to RES4 if not zero (not equal)
    CALL NEW5           ; Call NEW5 subroutine

    LDA BUFFER          ; Load accumulator with value from BUFFER
    INR A               ; Increment accumulator
    STA BUFFER          ; Store accumulator value to BUFFER
    CPI 9               ; Compare accumulator with 9
    JNZ RES4            ; Jump to RES4 if not zero (not equal)
    CALL NEW6           ; Call NEW6 subroutine

    JMP kosong4         ; Unconditional jump to 'kosong4'

clr7:
    ; Clear BUFFER array by setting each element to 0
    call NEW1
    call NEW2
    call NEW3
    call NEW4
    call NEW5
    call NEW6

    ; Display contents of BUFFER on seven-segment display
    LDA BUFFER+5        ; Load BUFFER[5] into A
    LXI H, SEVSEGDATA   ; Load SEVSEGDATA address into H
    MVI D, 0            ; Initialize D to 0
    MOV E, A            ; Move A (BUFFER[5]) to E
    DAD D               ; HL = HL + DE (calculate address)
    MOV A, M            ; Move memory content to A (SEVSEGDATA + BUFFER[5])
    STA DIGIT+5         ; Store A in DIGIT+5
    CALL DISPSEVSEG     ; Call subroutine to display on seven-segment display
    CALL DLY            ; Delay

    CALL DISPSEVSEG     ; Repeat above steps for BUFFER[4] to BUFFER[0]
    LDA BUFFER+4
    LXI H, SEVSEGDATA
    MVI D, 0
    MOV E, A
    DAD D
    MOV A, M
    STA DIGIT+4
    CALL DISPSEVSEG
    CALL DLY

    CALL DISPSEVSEG
    LDA BUFFER+3
    LXI H, SEVSEGDATA
    MVI D, 0
    MOV E, A
    DAD D
    MOV A, M
    STA DIGIT+3
    CALL DISPSEVSEG
    CALL DLY

    CALL DISPSEVSEG
    LDA BUFFER+2
    LXI H, SEVSEGDATA
    MVI D, 0
    MOV E, A
    DAD D
    MOV A, M
    STA DIGIT+2
    CALL DISPSEVSEG
    CALL DLY

    CALL DISPSEVSEG
    LDA BUFFER+1
    LXI H, SEVSEGDATA
    MVI D, 0
    MOV E, A
    DAD D
    MOV A, M
    STA DIGIT+1
    CALL DISPSEVSEG
    CALL DLY

    CALL DISPSEVSEG
    LDA BUFFER
    LXI H, SEVSEGDATA
    MVI D, 0
    MOV E, A
    DAD D
    MOV A, M
    STA DIGIT
    CALL DISPSEVSEG
    CALL DLY

    CALL DISPSEVSEG     ; Display the last digit
    ret                 ; Return from subroutine

;------------------------------------------------------------------

DISPSEVSEG:
    MVI C, 00H      ; Select DIG0
    MOV A, C
    ORI 0F0H        ; OR A with 0xF0 for control of 7-segment display
    OUT system_port_c
    LDA DIGIT;0     ; Load DIGIT[0] into A
    OUT system_port_b
    CALL DLY        ; Call delay subroutine
    MVI A, 0        ; Clear A for next operation
    OUT system_port_b

    MVI C, 01H      ; Select DIG1
    MOV A, C
    ORI 0F0H
    OUT system_port_c
    LDA DIGIT+1;1
    OUT system_port_b
    CALL DLY
    MVI A, 0
    OUT system_port_b

    MVI C, 02H      ; Select DIG2
    MOV A, C
    ORI 0F0H
    OUT system_port_c
    LDA DIGIT+2;2
    OUT system_port_b
    CALL DLY
    MVI A, 0
    OUT system_port_b

    MVI C, 03H      ; Select DIG3
    MOV A, C
    ORI 0F0H
    OUT system_port_c
    LDA DIGIT+3;3
    OUT system_port_b
    CALL DLY
    MVI A, 0
    OUT system_port_b

    MVI C, 04H      ; Select DIG4
    MOV A, C
    ORI 0F0H
    OUT system_port_c
    LDA DIGIT+4;4
    OUT system_port_b
    CALL DLY
    MVI A, 0
    OUT system_port_b

    MVI C, 05H      ; Select DIG5
    MOV A, C
    ORI 0F0H
    OUT system_port_c
    LDA DIGIT+5
    OUT system_port_b
    CALL DLY
    MVI A, 0
    OUT system_port_b

    RET             ; Return from subroutine

NEW1:
    MVI A, 0        ; Set A to 0
    STA BUFFER+5    ; Store A in BUFFER[5]
    RET             ; Return from subroutine

NEW2:
    MVI A, 0
    STA BUFFER+4
    RET

NEW3:
    MVI A, 0
    STA BUFFER+3
    RET

NEW4:
    MVI A, 0
    STA BUFFER+2
    RET

NEW5:
    MVI A, 0
    STA BUFFER+1
    RET

NEW6:
    MVI A, 0
    STA BUFFER
    RET


dly12:
    ; Delay subroutine using manual looping

    ; Initialize E register with 020h (32 in decimal)
    MVI E, 020h

LOOPO:
    ; Loop to delay execution
    MVI E, 020h   ; Reset E to 020h (32 in decimal) for each iteration

LOOPD:
    DCR E         ; Decrement E
    JNZ LOOPD     ; Jump back if E is not zero

    DCR D         ; Decrement D
    JNZ LOOPO     ; Jump back to outer loop if D is not zero

    RET           ; Return from subroutine


; Subroutine to scan keyboard and store the key code in 'key'
; Inputs:
;   HL: Pointer to buffer (not used in this snippet)
; Outputs:
;   key: Scan code of pressed key (or -1 if no key pressed)

scan:
        push h              ; Save HL pointer (not used here)
        push b              ; Save registers B
        push d              ; Save registers D

        ; Initialization
        mvi c, 6            ; 6-digit LED display
        mvi e, 0            ; Initialize digit scan code
        mvi d, 0            ; Initialize key position
        mvi a, 0ffh         ; Initialize key to -1 (no key pressed)
        sta key             ; Store key status

scan1:
        mov a, e            ; Load digit scan code into A
        ori 0f0h            ; Set high nibble to 1111 (active digit)
        out system_port_c   ; Output to system port C for digit activation

        mvi b, 1            ; Initialize delay counter for transition process

wait1:
        dcr b               ; Decrement delay counter
        jnz wait1           ; Loop until delay counter is zero

        in system_port_a    ; Read input port A to check if any key is pressed

        ; Analyze the 8-bit data read from port A (bit=0 means a key is pressed)
        mvi b, 8            ; Check all 8 rows

shift_key:
        rar                 ; Rotate accumulator right through carry
        jc next_key         ; If carry = 1, no key pressed

        push psw            ; Save accumulator and flags into stack
        mov a, d            ; Copy position counter D to accumulator A
        sta key             ; Store key position in 'key'
        pop psw             ; Restore accumulator and flags

next_key:
        inr d               ; Increment key position
        dcr b               ; Decrement row counter
        jnz shift_key       ; Loop until all rows are checked

        mvi a, 0            ; Clear accumulator A
        inr e               ; Move to next digit scan code
        dcr c               ; Decrement column counter
        jnz scan1           ; Loop until all columns are checked

        ; Finish scanning all keys
        ; Key position has been saved to 'key'

        pop d               ; Restore registers D
        pop b               ; Restore registers B
        pop h               ; Restore HL pointer
        ret                 ; Return from subroutine


;-----------------------------------------------------------------
	
; Interrupt Service Routine for ISR_5_5
ISR_5_5:
        R5:             ; Label R5
                MVI E, 07H
                RST 1       ; Software interrupt 1 (RST 1)
                CALL dlyz   ; Call delay subroutine
                MVI E, 09H
                RST 1       ; Software interrupt 1 (RST 1)
                CALL dlyz   ; Call delay subroutine
                CALL DISPSEVSEG ; Call display subroutine

                LXI H, 0301H    ; Load address for 2nd line display
                MVI E, 0AH      ; Set display instruction
                RST 1           ; Software interrupt 1 (RST 1)
                LXI H, PAUSE1   ; Load address for PAUSE1 message
                MVI E, 0BH      ; Set display instruction
                RST 1           ; Software interrupt 1 (RST 1)

                LXI H, 0102H    ; Load address for 3rd line display
                MVI E, 0AH      ; Set display instruction
                RST 1           ; Software interrupt 1 (RST 1)
                LXI H, PAUSE2   ; Load address for PAUSE2 message
                MVI E, 0BH      ; Set display instruction
                RST 1           ; Software interrupt 1 (RST 1)

                MVI A, 0        ; Clear accumulator A
                STA GP          ; Store A in GP

ii:             
                CALL DISPSEVSEG ; Call display subroutine

                EI              ; Enable interrupts
                CALL DISPSEVSEG ; Call display subroutine again

                MVI H, 00H      ; Initialize HL register for counter
                MVI L, 07H      ; Initialize HL register for counter
                SHLD ctr        ; Store HL pair in ctr
                CALL scan       ; Call scan subroutine
                LDA key         ; Load key from memory
                CPI 1DH         ; Compare with scan code 1DH (example value)
                JNZ ii          ; Jump if not zero (loop if key != 1DH)

                CALL DISPSEVSEG ; Call display subroutine
                MVI E, 07H      ; Initialize LCD
                RST 1           ; Software interrupt 1 (RST 1)
                CALL dlyz       ; Call delay subroutine
                MVI E, 09H      ; Clear LCD
                RST 1           ; Software interrupt 1 (RST 1)
                CALL dlyz       ; Call delay subroutine
                RET             ; Return from ISR_5_5

; --------------------------------------------------------------------

; Interrupt Service Routine for ISR_6_5
ISR_6_5:
                MVI E, 07H
                RST 1       ; Software interrupt 1 (RST 1)
                CALL dlyz   ; Call delay subroutine
                MVI E, 09H
                RST 1       ; Software interrupt 1 (RST 1)
                CALL dlyz   ; Call delay subroutine
                CALL DISPSEVSEG ; Call display subroutine

                LXI H, 0001H    ; Load address for INT6.5_1 message
                MVI E, 0AH      ; Set display instruction
                RST 1           ; Software interrupt 1 (RST 1)
                LXI H, INT6.5_1 ; Load address for INT6.5_1 message
                MVI E, 0BH      ; Set display instruction
                RST 1           ; Software interrupt 1 (RST 1)

                LXI H, 0002H    ; Load address for INT6.5_2 message
                MVI E, 0AH      ; Set display instruction
                RST 1           ; Software interrupt 1 (RST 1)
                LXI H, INT6.5_2 ; Load address for INT6.5_2 message
                MVI E, 0BH      ; Set display instruction
                RST 1           ; Software interrupt 1 (RST 1)

pp:             ; Label pp
                MVI H, 00H      ; Initialize HL register for counter
                MVI L, 07H      ; Initialize HL register for counter
                SHLD ctr        ; Store HL pair in ctr
                CALL scan       ; Call scan subroutine
                LDA key         ; Load key from memory
                CPI 02H         ; Compare with scan code 02H (example value)
                JZ START        ; Jump to START if equal

                CALL DISPSEVSEG ; Call display subroutine
                EI              ; Enable interrupts
                JMP pp          ; Jump to pp (loop)
                RET             ; Return from ISR_6_5

GPIO:
                MVI A, 0FH      ; Load accumulator A with 0FH
                OUT 00H         ; Output A to port 00H
                CALL dlyz       ; Call delay subroutine
                MVI A, 00H      ; Load accumulator A with 00H
                OUT 00H         ; Output A to port 00H
                RET             ; Return from GPIO

GPIO1:
                CALL DISPSEVSEG ; Call display subroutine
                LDA GP          ; Load GP from memory
                OUT 00H         ; Output GP to port 00H
                CALL dlyz       ; Call delay subroutine
                MVI A, 00H      ; Load accumulator A with 00H
                OUT 00H         ; Output A to port 00H
                LDA GP          ; Load GP from memory
                CPI 0FH         ; Compare with 0FH (example value)
                CZ RESGP        ; Call RESGP if equal
                RET             ; Return from GPIO1

RESGP:
                MVI A, 0        ; Clear accumulator A
                STA GP          ; Store A in GP
                RET             ; Return from RESGP

dlyz:
                LXI H, 10FAH    ; Load delay value into HL
                MVI E, 01H      ; Set delay count
                RST 1           ; Software interrupt 1 (RST 1)
                RET             ; Return from dlyz

DLY:
                MVI D, 02H      ; Load D with delay count
LOOPs:
                MVI E, 0FFH     ; Load E with FFH (delay loop)
LOOPf:
                DCR E           ; Decrement E
                JNZ LOOPf       ; Loop until E is zero
                DCR D           ; Decrement D
                JNZ LOOPs       ; Loop until D is zero
                RET             ; Return from DLY

; Memory allocation
org 0e000h
BUFFER:     dfs 6           ; Allocate space for BUFFER array
DIGIT:      dfs 6           ; Allocate space for DIGIT array
ctr:        dfs 2           ; Allocate space for ctr (2 bytes)
key:        dfs 1           ; Allocate space for key (1 byte)
GP:         DFS 1           ; Allocate space for GP (1 byte)

; Static data
SEVSEGDATA: dfb 3fh, 06H, 5BH, 4FH, 66H, 6DH, 7DH, 07H, 7FH, 6FH, 77H, 7CH, 39H, 5EH, 79H, 71H, 00h ; Seven-segment display data

; Static text messages
MAIN1:      DFB "SORTING COINS, PRESS:", 00H
MAIN50:     DFB "( 1 )->50 cents", 00H
MAIN20:     DFB "( 2 )->20 cents", 00H
MAIN10:     DFB "( 3 )->10 cents", 00H
UNIVERSAL:  DFB "SORTING:", 00H
FIFTY:      DFB "50 CENTS", 00H
TWENTY:     DFB "20 CENTS", 00H
TEN:        DFB "10 CENTS", 00H
INT6.5_1:   DFB "  FINISHED SORTING", 00H
INT6.5_2:   DFB "PRESSED (0) TO RESET", 00H
PAUSE1:     DFB "SYSTEM PAUSE", 00H
PAUSE2:     DFB "PRESS F TO CONTINUE", 00H
