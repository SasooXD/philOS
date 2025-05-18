CPU 8086
BITS 16
ORG 0x00000

LCD_DATA equ 0x00 ; LCD data port
LCD_CMD equ 0x02 ; LCD command port

section .text
start:
	; Initialize HD44780 in 8-bit mode
	CALL lcd_init

	; Write a message
	MOV SI, msg

.write_loop:
	LODSB
	OR AL, AL
	JZ .done
	CALL lcd_write_data
	JMP .write_loop

.done:
	HLT

; =============================
; Write command
; =============================
lcd_write_cmd:
	MOV DX, LCD_CMD
	OUT DX, al
	CALL lcd_delay
	RET

; =============================
; Write data
; =============================
lcd_write_data:
	MOV DX, LCD_DATA
	OUT DX, al
	CALL lcd_delay
	RET

; =============================
; Lil delay thingy
; =============================
lcd_delay:
	PUSH CX
    MOV CX, 0xFFFF
.delay_loop:
	LOOP .delay_loop
	POP CX
	RET

; =============================
; Initializes LCD
; =============================
lcd_init:
	; Function set: 8-bit, 2 rows, 5x8 font
	MOV AL, 0x38
	CALL lcd_write_cmd

	; Display ON, cursor OFF, blink OFF
	MOV AL, 0x0C
	CALL lcd_write_cmd

	; Entry mode set: increment, no shift
	MOV AL, 0x06
	CALL lcd_write_cmd

	; Clear display
	MOV AL, 0x01
	CALL lcd_write_cmd

	RET

section .data
msg db 'CIAO', 0
