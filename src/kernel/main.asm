BITS 16
ORG 0xF0000

start:
	; Since it is impossible to write directly to registers ds/es, register ax is used
	MOV AX, 0
	MOV DS, AX
	MOV ES, AX

	; Stack setup
	MOV SS, AX
	mov SP, 0xF0000
