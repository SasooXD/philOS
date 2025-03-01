BITS 16
ORG 0xF09FF ; BIOS starting address (ROM segment, 2nd block)

start:
	CLI						; Clear interrupt flag
	MOV		AX,	0x0F000		; ROM Segment
	MOV		DS,	AX
	MOV		ES,	AX
	MOV		SS,	AX
	MOV		SP,	0x0FFFE		; Stack setup near the end of ROM
	STI						; Re-enable interrupts

	CALL	init_screen		; Init video
	CALL	print_banner	; Print message

loop_forever:
	HLT						; Halt CPU until interrupt arrives
	JMP		loop_forever

; -------------------------------------------------
; Initialize screen mode (to implement)
; -------------------------------------------------
init_screen:
	MOV		AX,	0x03		; Text mode 80x25
	INT		0x10
	RET

; -------------------------------------------------
; Print a message to screen (to implement)
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

msg DB 'Welcome to philOS.', 0

; -------------------------------------------------
; ROM segment termination
; -------------------------------------------------
TIMES (0x10000 - ($ - $$)) DB 0xFF

;TODO: Interrupt vector!!!

; Should we need to write something, we can borrow some RAM (provided we have the right address)
; but we need to keep track of it, so that we can clean it after use + security stuff: stack
; TODO: Implement stack for this thing

; We should absolutely have some kind of POST and RAM check (i'm thinking read-write for both?)
; (POST: we must know the addresses of the ports beforehand...)
; TODO: POST and RAM check

;? Bootloader? If we can save the kernel image on a separate EEPROM we could try transferring
;? that into RAM, otherwise we would need the full image of the kernel concatenated
;? to the binary of the BIOS, pretty large stuff: might want to change address for this.
;? extremely cursed: we could also not make any bootloader at all
; TODO: Bootloader


