CPU 8086
BITS 16
ORG 0xF0A00 ; BIOS starting address (ROM segment, 2nd block)

; -------------------------------------------------
; Starting point of the BIOS, first thing loaded
; @destroys: AX, DS, ES, SS, SP
; TODO: actually implement
; -------------------------------------------------
start:
	CLI						; Clear interrupt flag
	MOV		AX,	0xF09F		; ROM Segment
	MOV		DS,	AX
	MOV		ES,	AX
	MOV		SS,	AX
	MOV		SP,	0x0FFEE		; Stack setup near the end of ROM
	STI						; Re-enable interrupts

	CALL	init_screen		; Init video
	CALL	print_banner	; Print message

	CALL	clear_ram		; Init video
	CALL	bootstrap	; Print message

	; All done, goodbye BIOS!
	;JMP FAR		0x0FE01
	; TODO: absolutely not done btw, implement some checks before jumping

; -------------------------------------------------
; Initializes screen mode
; @destroys: AX
; TODO: actually implement
; -------------------------------------------------
init_screen:
	MOV		AX,	0x03		; Text mode 80x25
	INT		0x10
	RET

; -------------------------------------------------
; Prints a message to screen
; @destroys: AL, AH, SI
; TODO: actually implement
; -------------------------------------------------
print_banner:
	MOV		SI,	msg

	print_loop:
		LODSB					; Load character in AL
		OR		AL,	AL			; End of string?
		JZ		done
		MOV		AH,	0x0E		; Print character
		INT		0x10
		JMP		print_loop

	done:
		RET

; -------------------------------------------------
; Completely clears the RAM before bootstrapping
; @destroys: AX, CX, DI, ES
; -------------------------------------------------
clear_ram:
	; ES points to RAM segments
	MOV AX,		0x0FE0
	MOV ES, 	AX

	; Load initial RAM offset (0x0001) into DI
	MOV DI,		0x0001

	; Range of RAM, this is the number of byte we have to clean
	MOV CX,		0x7D00

	; Value to write in RAM (0x0000 to clean)
	MOV AX,		0x0000

	clear_ram_loop:
		STOSW							; Write AL in [ES:DI] and increment DI
		LOOP		clear_ram_loop		; Repeat until CX != 0

		RET

; -------------------------------------------------
; Bootstraps the kernel from ROM into RAM
; @destroys: AX, CX, SI, DI, DS, ES
; -------------------------------------------------
bootstrap:
	; DS points to the kernel block (ROM segment, 4th block)
	MOV AX,		0x0040
	MOV DS,		AX

	; Load initial kernel block offset (0x0001) into SI
	MOV SI,		0x0000

	; ES points to RAM segment
	MOV AX,		0x0FE0
	MOV ES,		AX

	; Load initial RAM offset (0x0001) into DI
	MOV DI,		0x0001

	; Range of the kernel block, this is the number of words we have to transfer to RAM
	MOV CX,		0x07C00 / 2

	bootstrap_loop:
		LODSW						; Load a word from [DS:SI] into AX and increment SI by 2
		STOSW						; Write AX in [ES:DI] and increment DI by 2
		LOOP		bootstrap_loop	; Repeat until CX != 0

		RET

msg DB 'Welcome to philOS.', 0

; Should we need to write something, we can borrow some RAM (provided we have the right address)
; but we need to keep track of it, so that we can clean it after use + security stuff: stack
; TODO: Implement stack for this thing

; We should absolutely have some kind of POST and RAM check (i'm thinking read-write for both?)
; (POST: we must know the addresses of the ports beforehand...)
; TODO: POST and RAM check

; TODO: safe mode (OPM)!
; And btw, is there some way to check if we came here from an interrupt? INT 0x05 exists for a
; reason, it's useless if we can't set safe mode on after the interrupt brought us here.

; Padding until 62960  B
times (62960 - ($ - $$)) db 0x00
