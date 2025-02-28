BITS 16
ORG 0xF000

start:
	CLI						; Clear interrupt flag
	MOV	AX,	0xF000			; ROM Segment
	MOV	DS,	AX
	MOV	ES,	AX
	MOV	SS,	AX
	MOV	SP,	0xFFFE			; Stack setup near the end of ROM
	STI						; Riabilita gli interrupt

	CALL	init_screen		; Init video
	CALL	print_banner	; Print message

loop_forever:
	HLT						; Halt CPU until interrupt arrives
	JMP		loop_forever

; -------------------------------------------------
; Initialize screen mode (to implement)
; -------------------------------------------------
init_screen:
	MOV	AX,	0x03			; text mode 80x25
	INT		0x10
	RET

; -------------------------------------------------
; Print a message to screen (to implement)
; -------------------------------------------------
print_banner:
	MOV	SI,	msg
print_loop:
	LODSB					; Load character in AL
	OR	AL,	AL				; end of string?
	JZ	done
	MOV	AH,	0x0E			; print character
	INT	0x10
	JMP	print_loop
done:
	RET

msg DB 'Welcome to philOS', 0

; -------------------------------------------------
; ROM segment termination
; -------------------------------------------------
TIMES (0x10000 - ($ - $$)) DB 0xFF
