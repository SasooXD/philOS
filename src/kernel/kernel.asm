CPU 8086
BITS 16

start:
	;TODO: DS and ES must be moved somewhere around here, SS has to be placed better

	;TODO: Change these with real addresses!!!
	MOV AX, 0
	MOV DS, AX
	MOV ES, AX

	; TODO: Correctly setup the stack!!!
	MOV SS, AX
	MOV SP, 0xF0000

; TODO: Shell!!!

; Padding until 32000 B
times (24576 - ($ - $$)) db 0xFF
