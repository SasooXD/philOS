CPU 8086
BITS 16
ORG 0x08400 ; User space starting address (ROM segment, 6th block)

start:
	MOV AX, 0
	MOV BX, 1

fibonacci_loop:
	ADD AX, BX
	XCHG AX, BX
	JNC fibonacci_loop

	JMP start
