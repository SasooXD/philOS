CPU 8086
BITS 16

; PHIL_ header
	db 'PHIL_'
	db 'fib', 0
	times 8 - ($ - $$ - 5) db 0x00

start:
	MOV AL, 0
	MOV BL, 1

fibonacci_loop:
	ADD AL, BL
	XCHG AL, BL
	JNC fibonacci_loop

	JMP start

;! PADDING UNTIL 18432 B FOR DEBUG PURPOSES! SHOULD BE MUCH LESS PER USER PROGRAM!!!
times (18432 - ($ - $$)) db 0xFF
