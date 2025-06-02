CPU 8086
BITS 16

start:
	; Add a lil initial delay (I/O is slow ass and may need time to initialize)
	MOV CX, 700 ; ~120 ms @ 9765.625 Hz
	.loop:
		DEC CX
		JNZ .loop

; Zeroes all registers
registers_setup:
	XOR AX, AX
	XOR BX, BX
	XOR CX, CX
	XOR DX, DX
	XOR SI, SI
	XOR DI, DI
	XOR BP, BP
	XOR SP, SP ;! EXTREMELY DANGEROUS! DO NOT USE STACK UNTIL NEXT LABEL!!!

	MOV DS, AX
	MOV ES, AX
	MOV SS, AX

	PUSH AX
	POPF ;! this is prob also very dangerous lol

; Setup all of the memory segment
; We don't care about zeroing it, maybe the OS will, we don't have time for that here.
memory_setup:
	CLI ; We don't wanna be bothered
	; Btw, and this is important, the no-interrupt will stay in place until we will POST.
	; If an NMI happens it will check if the OS is in memory, and if it is not, it will
	; nuke everything.

	; Stack segment (SS) and pointer (SP)
	MOV AX, 0x1FFF
	MOV SS, AX
	MOV SP, 0x000F ; Last address decoded in RAM

	; Data segment (DS)
	MOV AX, 0x0000
	MOV DS, AX

	; Extra segment (ES)
	MOV AX, 0x1000
	MOV ES, AX

; Copy the IDT in the first 1 KiB of RAM
copy_idt:
	; Save real segments in the stack
	PUSH DS
	PUSH ES

	; Destination and source offset (RAM and ROM)
	MOV SI, 0x0000
	MOV DI, 0x0000

	; Source segment (ROM)
	MOV AX, 0xFA80
	MOV DS, AX

	; Destination segment (RAM)
	MOV AX, 0x0000
	MOV ES, AX

	MOV CX, 1024 ; Number of bytes to copy over

	; Copy!!!
	CLD
	REP MOVSB

	; Load real segments from the stack
	POP ES
	POP DS

; Main BIOS part where we can actually use functions n shi
main:
	STI ; Interrupts are back!

	; Configure the I/O
	CALL conf_lcd
	;CALL conf_pic
	;CALL conf_usart
	;CALL conf_ppi

	; Now, we POST a little
	;CALL rom_post
	;CALL ram_post
	;CALL io_post
	;CALL int_post

	; After estabilishing that (at least ONE) interrupt(s) work, we can talk!!!
	MOV AL, 'O'
	INT 0x00
	MOV AL, 'K'
	INT 0x00

	; Before bootstrapping, check if the provided address is the correct one
	;CALL check_bootstrapping

	; We can boostrap!
	;CALL bootstrap

	; Goodbye!!!
	;JMP WORD KERNEL_SEGMENT:KERNEL_OFFSET

; Configures the LCD in a standard 16x2, no cursor configuration
;@destroys AL
conf_lcd:
	LCD_DATA equ 0x02
	LCD_CMD equ 0x00

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

	RET

; Padding until 13296 B
times (13296 - ($ - $$)) db 0xFF
