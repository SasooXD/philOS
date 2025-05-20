CPU 8086
BITS 16

start:
	PUSH AX
	PUSH BX
	PUSH CX
	PUSH DX
	PUSH SI
	PUSH DI
	PUSH BP
	PUSH DS
	PUSH ES

	; NMI 101:
	; 1. Read registers n shi,
	; 2. Logging on monitor and debug logging on LCD,
	; 3. Recovery (if possible),
	; 4. HALT or SOFT RESET.

	POP ES
	POP DS
	POP BP
	POP DI
	POP SI
	POP DX
	POP CX
	POP BX
	POP AX

	IRET
