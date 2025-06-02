; This contains one or more interrupt service routine(s) (ISR(s)). Each ISR contains
; a block of code associated with a specific interrupt. When that interrupt is issued,
; the 8086 will look up the associated ISR on the IDT. When found, the processor will jump
; to the right block and its content will be executed. For this reason, the address of
; each handler is crucial because it precisely needs to follow what the entry in the IDT
; points to. Read the documentation on interrupts for more info.

CPU 8086
BITS 16

start:
	OUT 0x02, AL

	IRET

;! FOR DEBUGGING PURPOSES, THIS HANDLER ALONE IS PADDING FOR ALL OF THE ISR MEMORY SPACE.
;! BY DEFAULT, THIS VALUE UNDER HERE SHOULD BE 128! REMEMBER TO CHANGE THIS!
times 8192 - ($ - $$) db 0xFF
