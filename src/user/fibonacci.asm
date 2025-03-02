CPU 8086
BITS 16
ORG 0xF0000 ; User space starting address (ROM segment, 5th block)

start:
	MOV		AX,	0
	MOV		BX,	1

fibonacci_loop:
	ADD		AX,	BX
	XCHG	AX,	BX
	JNC		fibonacci_loop

	JMP		start
