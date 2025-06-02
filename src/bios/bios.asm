;! TEST TEST TEST

CPU 8086
BITS 16
ORG 0xFCC00

LCD_DATA equ 0x02 ; LCD data port
LCD_CMD  equ 0x00 ; LCD command port

start:
	MOV AL, 0x30
	OUT LCD_CMD, AL

	MOV AL, 0x30
	OUT LCD_CMD, AL

	MOV AL, 0x30
	OUT LCD_CMD, AL

	MOV AL, 0x38
	OUT LCD_CMD, AL
	
	MOV AL, 0x08
	OUT LCD_CMD, AL
	
	MOV AL, 0x01
	OUT LCD_CMD, AL
	
	MOV AL, 0x06
	OUT LCD_CMD, AL	
	
	MOV AL, 0x0C
	OUT LCD_CMD, AL
	
copy_idt:
	CLI                     ; Disabilita gli interrupt (opzionale ma consigliato)

	MOV SI, 0x0000          ; Offset sorgente
	MOV DI, 0x0000          ; Offset destinazione

	MOV AX, 0xFA80          ; Segmento sorgente (ROM, nuova IDT)
	MOV DS, AX

	MOV AX, 0x0000          ; Segmento destinazione (RAM, vera IVT)
	MOV ES, AX

	MOV CX, 1024            ; Numero di byte da copiare

	CLD                     ; Assicurati che DF sia 0 (incrementa)
	REP MOVSB              ; Copia i CX byte da DS:SI a ES:DI

	STI                     ; Riabilita gli interrupt (se li avevi disabilitati)
	
	MOV AL, 'I'
	OUT LCD_DATA, AL
	MOV AL, 'N'
	OUT LCD_DATA, AL
	MOV AL, 'T'
	OUT LCD_DATA, AL
	
write:
	; scrittura in ram e da lcd
	MOV AL, 'K'
	OUT LCD_DATA, AL
	
	INT 0x00
	
	JMP write
	
; Padding until 13296 B
times (13296 - ($ - $$)) db 0xFF
