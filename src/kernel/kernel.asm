CPU 8086
BITS 16
ORG 0x00400 ; Kernel image starting address (ROM segment, 4th block)
;! This is not an address in the RAM segment! This is where the image should lie (in ROM),
;! but unless safe mode is on, we should be in RAM. Otherwise, the address is correct
;! and we can safely continue.

start:
	;TODO: DS and ES must be moved somewhere around here, SS has to be placed better

	; Since it is impossible to write directly to registers DS and ES, register AX is used
	;TODO: Change these with real addresses!!!
	MOV		AX,	0
	MOV		DS,	AX
	MOV		ES,	AX

	; TODO: Correctly setup the stack!!!
	MOV		SS,	AX
	MOV		SP,	0xF0000

; We trust that the BIOS has already done all its checks and has cleaned memory
; (if it ever wrote something in the first place), so no check from our side ALTHOUGH
; we better check that we are indeed in RAM: nuke everything if we can't write.
;TODO: Write check

; We absolutely have no protected mode lol, but we have an Arduino Mega
; . What could happen:
; 	- A user process tries to access our space -> can we track if the illegal access
; 	is coming from a user process? if so, kill it
; 	- We try to overwrite our own space -> well, we can obv do that provided it's intentional,
; 	we might want to keep important addresses into stack.
;TODO: Ostensible protected mode (ostensible)

;TODO: Shell!!!

; Padding until 32000 B
times (32000 - ($ - $$)) db 0x00
