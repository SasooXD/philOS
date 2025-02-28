BITS 16
ORG 0x5000

start:
	; Since it is impossible to write directly to registers DS and ES, register AX is used
	MOV	AX,	0
	MOV	DS,	AX
	MOV	ES,	AX

	; Stack setup
	MOV	SS,	AX
	MOV	SP,	0xF0000
