BITS 16
ORG 0x5000 ;! Random ass address, the kernel should't start here
;TODO: Pick a good starting address for the kernel

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

; We absolutely have no protected mode lol, but we should still implement something
; to keep track of the kernel's address space. What could happen:
; 	- A user process tries to access our space -> can we track if the illegal access
; 	is coming from a user process? if so, kill it
; 	- We try to overwrite our own space -> well, we can obv do that provided it's intentional,
; 	we might want to keep important addresses into stack.
;TODO: Simulated protected mode

;TODO: Shell!!!
