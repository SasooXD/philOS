;! TEST TEST TEST

CPU 8086
BITS 16
ORG 0xFCC00

LCD_DATA equ 0x02 ; LCD data port
LCD_CMD  equ 0x00 ; LCD command port

; Put the stack pointer at the end of the RAM block
memory_setup:
	MOV AX, 0x1FFF   ; segment: (0x1FFF << 4) = 0x1FFF0
	MOV SS, AX
	MOV SP, 0x0010   ; offset: 0x1FFF0 + 0x0010 = 0x20000

; Send the necessary configuration messages for the LCD display
; (note that this can be changed by the mythical LCD_RESET interrupt)
lcd_conf:
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

; Send the necessary configuration messages to initialize the USART i8251 device
usart_conf:
	MOV AL, 0x4E       ; mode word: async, 8N1, div/64
	OUT 0x12, AL       ; A0 = 1 (control port)

	MOV AL, 0x0F       ; command word: enable RX, TX, DTR, RTS
	OUT 0x12, AL

	wait_tx:
		IN AL, 0x12    ; read status
		TEST AL, 02h   ; is TX ready?
		JZ wait_tx     ; wait

		MOV AL, 'A'
		OUT 0x10, AL       ; send 'A' for testing with terminal

; Send the necessary configuration messages to initialize the PIC i8259 device
pic_conf:
	MOV AL, 0x11      ; ICW1: start init, edge, ICW4 needed
	OUT 0x20, AL      ; Command port (A0 = 0)

	MOV AL, 0x00      ; ICW2: base vector = 0x00 (IR0 -> INT 0x00)
	OUT 0x21, AL      ; Data port (A0 = 1)

	MOV AL, 0x00      ; ICW3: no slave
	OUT 0x21, AL

	MOV AL, 0x01      ; ICW4: mode 8086
	OUT 0x21, AL

; Copy the IDT in the absolute first 1 KiB block in RAM
copy_idt:
	CLI                     ; disable interrupts just for safety

	MOV SI, 0x0000          ; source offset (RAM)
	MOV DI, 0x0000          ; dst offset (RAM)

	MOV AX, 0xFA80          ; source segment (ROM)
	MOV DS, AX

	MOV AX, 0x0000          ; dst segment (RAM)
	MOV ES, AX

	MOV CX, 1024            ; number of bytes to copy over

	CLD
	REP MOVSB              ; copy!!

	STI                     ; enable interrupts

; Announce that the process should be complete
	MOV AL, 'I'
	OUT LCD_DATA, AL

	MOV AL, 'N'
	OUT LCD_DATA, AL

	MOV AL, 'T'
	OUT LCD_DATA, AL

; Simple RAM POST
write:
	MOV AL, 'K'
	OUT LCD_DATA, AL

	JMP write

; Padding until 13296 B
times (13296 - ($ - $$)) db 0xFF
