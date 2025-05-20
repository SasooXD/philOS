; This is the interrupt descriptor table (IDT) data structure. This is loaded in the first
; 1024 bytes of the i8086 total memory address space and it contains a pointer for each
; interrupt handled by the system. These handlers (known as the ISRs) are by default
; part of the ROM image altough the kernel can change them (and the IDT itself), if it wants to.
; The following structure points to the default ISRs, starting at 0xFAC00, 128 B per handler.

CPU 8086
BITS 16

; Nothing much to see here, it's a word write loop.
; Check the docs for a list of implemented interrupts.

%assign i 0
%assign isr_starting_address 0xFAC00

%rep 64
	dw 0x0000
	dw (isr_starting_address + i * 128) >> 4
%assign i i+1
%endrep

times (1024 - ($ - $$)) db 0xFF
