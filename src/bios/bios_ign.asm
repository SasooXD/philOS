;! TEST TEST TEST

CPU 8086
BITS 16
ORG 0xFCC00

LCD_DATA equ 0x00 ; LCD data port
LCD_CMD  equ 0x02 ; LCD command port

start:
	MOV AX, 0x0000
	MOV DS, AX

	MOV SI, 0x0200
	MOV BYTE [DS:SI], 0x55

	MOV AL, [DS:SI]

	; Set: 8-bit, 2 rows, 5x8 fonts
	MOV AL, 0x38
	OUT LCD_CMD, AL

	; Display ON, cursor OFF, blink OFF
	MOV AL, 0x0C
	OUT LCD_CMD, AL

	; Entry mode: increment, no shift
	MOV AL, 0x06
	OUT LCD_CMD, AL

	; Clear display
	MOV AL, 0x01
	OUT LCD_CMD, AL

	; Write 'O'
	MOV AL, 'O'
	OUT LCD_DATA, AL

	; Write 'N'
	MOV AL, 'N'
	OUT LCD_DATA, AL
