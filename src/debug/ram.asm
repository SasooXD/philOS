CPU 8086
BITS 16

start:
	MOV AX, 0
	MOV ES, AX

	MOV AX, 0xA55A

	MOV DI, 0x2000
	MOV [ES:DI], AX

read_loop:
	MOV DI, 0x2000
	MOV BX, [es:di]

	JMP read_loop
