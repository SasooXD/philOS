CPU 8086
BITS 16
ORG 0x08400 ; User space starting address (ROM segment, 6th block)

start:
	MOV AL, 0
	MOV BL, 1

fibonacci_loop:
	ADD AL, BL
	XCHG AL, BL
	JNC fibonacci_loop

	JMP start
