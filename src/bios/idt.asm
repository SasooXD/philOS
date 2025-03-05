; This is the interrupt descriptor table (IDT) data structure. This is loaded in the first
; 1024 bytes of the i8086 total address space and it contains a pointer for each
; interrupt handled by the system. The pointer points to the handler of each
; interrupt, which is usually part of the BIOS (could also be in the kernel for OPM stuff).

CPU 8086
BITS 16
ORG 0x00000 ; IDT starting address (ROM segment, 1st block)

; The following is an example of the structure of an element in the IDT:
; - double word (16 bit) for the handler's offset,
; - double word (16 bit) for the handler's segment.
; In total, every entry in the IDT occupies 2 double words, or 4 bytes.

; This means that even if we know the absolute address of the handler, if it exceeds the 16 bit
; range, there's not enough space to dictate all 20 bits of it. So we have to do some math:
; we know that physical address = (segment * 16) + offset, so we need to take
; the first 16 bits as the segment (that's the first 4 hexadecimal digits) and the remaining
; 4 bits (that's the last hexadecimal digit) as the offset.

; We will try as best as we can to follow the official Intel IDT layout, but some of it
; is just stupidly made (and/or not useful for our purposes).

; INT 0x00: Division by zero
; TODO: place real handler address here
dw	0x0000
dw	0x0000

; INT 0x01: Single stepping (trap flag)
; TODO: place real handler address here
dw	0x0000
dw	0x0000

; INT 0x02: NMI (non-maskable interrupt)
; TODO: place real handler address here
dw	0x0000
dw	0x0000

; INT 0x03: Breakpoint
; TODO: place real handler address here
dw	0x0000
dw	0x0000

; INT 0x04: Emergency jump to BIOS (0xF09FF) (no IRET)
dw 0x000F
dw 0xF09F

; INT 0x05: Emergency jump to kernel in safe mode (0x00400) (no IRET)
dw 0x0000
dw 0x0040

; Padding until 1024 B
times (1024 - ($ - $$)) db 0x00
