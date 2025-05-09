; This contains one or more interrupt service routine(s) (ISR(s)). Each ISR contains
; A block of code associated with a specific interrupt. When that interrupt is issued,
; the 8086 will look up the associated ISR on the IDT. When found, the processor jumps
; to the right block and its content are executed. For this reason, the address of
; each handler is crucial because it precisely needs to follow what the entry in the IDT
; points to. Read the documentation on interrupts for more info.

CPU 8086
BITS 16
ORG 0x00000 ; TODO: pick a real address

; INT 0x01: Single stepping (trap flag)
int01_handler:
	PUSH AX
	PUSH DS

	; DS actually points to data segment
	MOV AX, 0x0000 ; TODO: pick a real address
	MOV DS, AX

	; Print error message
	MOV SI, int01_message ; TODO: actually print message

	; Restore registers
	POP DS
	POP AX

	IRET

	; Interrupt message (max 32 characters)
	int01_message db "Single step!", 0

	; Full 128 byte padding
	TIMES 128 - ($ - int01_handler) DB 0x00
