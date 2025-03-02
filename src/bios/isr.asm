; This is the interrupt service routine (ISR). It contains blocks of code each associated
; with a specific interrupt. Here lies an handler for each interrupt managed by the system
; and the address (location) of each handler is crucial because it precisely needs to follow
; what the IDT says.

CPU 8086
BITS 16
ORG 0x00000 ; TODO: pick a real address

; INT 0x00: Division by zero
int00_handler:
	PUSH		AX
	PUSH		DS

	; DS actually points to data segment
	MOV	AX,		0x0000 	; TODO: pick a real address
	MOV	DS,		AX

	; Print error message
	MOV	SI,		int00_message
	; TODO: actually print message

	; Restore registers
	POP			DS
	POP			AX

	IRET

	; Full 128 byte padding
	TIMES 128 - ($ - int00_handler) DB 0x00

section .data
int00_message db "Error! division by zero!", 0
