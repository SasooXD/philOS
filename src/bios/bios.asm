BITS 16
ORG 0xFFF0

start:
JMP FAR [jump_target]

jump_target:
	dw 0x0000
	dw 0xF000
