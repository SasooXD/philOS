; This contains one or more interrupt service routine(s) (ISR(s)). Each ISR contains
; a block of code associated with a specific interrupt. When that interrupt is issued,
; the 8086 will look up the associated ISR on the IDT. When found, the processor will jump
; to the right block and its content will be executed. For this reason, the address of
; each handler is crucial because it precisely needs to follow what the entry in the IDT
; points to. Read the documentation on interrupts for more info.

CPU 8086
BITS 16
ORG 0xFAC00 ; ISR 0x00 starting address

; INT 0x00: Division by zero
int00_handler:
CPU 8086
BITS 16

start:
	PUSH AX
	PUSH BX
	PUSH CX
	PUSH DX
	PUSH SI
	PUSH DI
	PUSH BP
	PUSH DS
	PUSH ES
	PUSH SS

	MOV AL, 'c'
	OUT 0x02, AL
	
	MOV AL, 'i'
	OUT 0x02, AL
	
	MOV AL, 'a'
	OUT 0x02, AL

	MOV AL, 'o'
	OUT 0x02, AL
	
	POP ES
	POP DS
	POP BP
	POP DI
	POP SI
	POP DX
	POP CX
	POP BX
	POP AX
	
	IRET

;! FOR DEBUGGING PURPOSES, THIS HANDLER ALONE IS PADDING FOR ALL OF THE ISR MEMORY SPACE.
;! BY DEFAULT, THIS VALUE UNDER HERE SHOULD BE 128! REMEMBER TO CHANGE THIS!
times 8192 - ($ - int00_handler) DB 0xFF
