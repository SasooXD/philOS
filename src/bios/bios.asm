CPU 8086
BITS 16
ORG 0xF0400 ; BIOS starting address (ROM segment, 2nd block)

; ------------------------------------------------
; Starting point of the BIOS, first thing loaded
; @destroys: AX, DS, ES, SS, SP
; TODO: actually implement
; ------------------------------------------------
start:
	CLI

	; ROM Segment
	MOV AX, 0xF09F
	MOV DS, AX
	MOV ES, AX
	MOV SS, AX

	; Stack setup near the end of ROM
	MOV SP, 0x0FFEE

	STI

	CALL init_screen
	CALL print_banner
	CALL clear_ram
	CALL bootstrap

	; All done, goodbye BIOS!
	;JMP FAR 0x0FE01
	; TODO: absolutely not done btw, implement some checks before jumping

; ------------------------------------------------
; Initializes screen mode
; @destroys: AX
; TODO: actually implement
; ------------------------------------------------
init_screen:
	MOV AX,	0x03
	INT 0x10
	RET

; ------------------------------------------------
; Prints a message to screen
; @destroys: AL, AH, SI
; TODO: actually implement
; ------------------------------------------------
print_banner:
	MOV SI, msg

	; Print until end of string
	print_loop:
		LODSB
		OR AL, AL
		JZ done
		MOV AH, 0x0E
		INT 0x10
		JMP print_loop

	done:
		RET

; ------------------------------------------------
; Completely clears the RAM before bootstrapping
; @destroys: AX, CX, DI, ES
; ------------------------------------------------
clear_ram:
	; ES points to RAM segments
	MOV AX, 0x0FE0
	MOV ES, AX

	; Load initial RAM offset (0x0001) into DI
	MOV DI, 0x0001

	; Range of RAM, this is the number of byte we have to clean
	MOV CX, 0x7D00

	; Value to write in RAM (0x0000 to clean)
	MOV AX, 0x0000

	clear_ram_loop:
		; Write AL in [ES:DI] and increment DI
		STOSW
		; Repeat until CX != 0
		STOSW
		LOOP clear_ram_loop

		RET

; ------------------------------------------------
; Bootstraps the kernel from ROM into RAM
; @destroys: AX, CX, SI, DI, DS, ES
; ------------------------------------------------
bootstrap:
	; DS points to the kernel block (ROM segment, 4th block)
	MOV AX, 0x0040
	MOV DS, AX

	; Load initial kernel block offset (0x0001) into SI
	MOV SI, 0x0000

	; ES points to RAM segment
	MOV AX, 0x0FE0
	MOV ES, AX

	; Load initial RAM offset (0x0001) into DI
	MOV DI, 0x0001

	; Range of the kernel block, number of words we have to transfer to RAM
	MOV CX, 0x07C00 / 2

	bootstrap_loop:
		; Load a word from [DS:SI] into AX and increment SI by 2
		LODSW
		; Write AX in [ES:DI] and increment DI by 2
		STOSW
		; Repeat until CX != 0
		LOOP bootstrap_loop

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
