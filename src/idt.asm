; This is the interrupt descriptor table (IDT) data structure. This is loaded in the first
; 1024 bytes of the i8086 total memory address space and it contains a pointer for each
; interrupt handled by the system. The pointer points to the handler of each
; interrupt (known as an ISR), which are by default part of the BIOS altough the kernel can make
; other ones, if it wants to. The following structure points to the default ISR in the BIOS.

CPU 8086
BITS 16
ORG 0x00000 ; IDT starting address
; This is an address in RAM, so the IDT must be copied there by the BIOS

; The following is an example of the structure of an element in the IDT:
; - a word (16 bits) for the handler's offset,
; - a word (16 bits) for the handler's segment.
; In total, every entry in the IDT occupies 2 words, or 4 bytes.

; This means that even if we know the absolute address of the handler, if it exceeds the 16 bit
; range, there's not enough space to dictate all 20 bits of it. So we have to do some math:
; we know that physical address = (segment * 16) + offset, so we need to take
; the first 16 bits as the segment (that's the first 4 hexadecimal digits) and the remaining
; 4 bits (that's the last hexadecimal digit) as the offset.

; We will try as best as we can to follow the official Intel IDT layout, but some of it
; is just stupidly made (and/or not useful for our purposes).

; INT 0x00: Division by zero (DIVISION_BY_ZERO)
; TODO: place real handler address here
dw 0x0000
dw 0x0000

; INT 0x01: Single step (SINGLE_STEP)
; TODO: place real handler address here
dw 0x0000
dw 0x0000

; INT 0x02: Non-maskable interrupt (NMI)
; TODO: place real handler address here
dw 0x0000
dw 0x0000

; INT 0x03: Breakpoint (BREAKPOINT)
; TODO: place real handler address here
dw 0x0000
dw 0x0000

; INT 0x04: Overflow (OVERFLOW)
; TODO: place real handler address here
dw 0x0000
dw 0x0000

; INT 0x05: Bound range exceeded (BOUND_RANGE_EXCEEDED)
; TODO: place real handler address here
dw 0x0000
dw 0x0000

; INT 0x06: Invalid opcode (INVALID_OPCODE)
; TODO: place real handler address here
dw 0x0000
dw 0x0000

; INT 0x07: Coprocessor not available (COPROCESSOR_NOT_AVAILABLE)
; TODO: place real handler address here
dw 0x0000
dw 0x0000

; INT 0x08: Double Fault (DOUBLE_FAULT)
; TODO: place real handler address here
dw 0x0000
dw 0x0000

; INT 0x09: Coprocessor Segment Overrun (COPROCESSOR_SEGMENT_OVERRUN)
; TODO: place real handler address here
dw 0x0000
dw 0x0000

; INT 0x0A: Invalid task state segment (INVALID_TASK_STATE_SEGMENT)
; TODO: place real handler address here
dw 0x0000
dw 0x0000

; INT 0x0B: Segment not present (SEGMENT_NOT_PRESENT)
; TODO: place real handler address here
dw 0x0000
dw 0x0000

; INT 0x0B: Stack segment fault (STACK_SEGMENT_FAULT)
; TODO: place real handler address here
dw 0x0000
dw 0x0000

; INT 0x0D: General protection fault (GENERAL_PROTECTION_FAULT)
; TODO: place real handler address here
dw 0x0000
dw 0x0000

; INT 0x0E: Page fault (PAGE_FAULT)
; TODO: place real handler address here
dw 0x0000
dw 0x0000

; INT 0x0F: Emergency jump to BIOS (JUMP_TO_BIOS)
dw 0x000F
dw 0xF09F

; INT 0x10: Emergency jump to kernel in safe mode (JUMP_TO_ROM_KERNEL)
dw 0x0000
dw 0x0040

; INT 0x11: Alignment check (ALIGNMENT_CHECK)
; TODO: place real handler address here
dw 0x0000
dw 0x0000

; INT 0x12: Machine check (MACHINE_CHECK)
; TODO: place real handler address here
dw 0x0000
dw 0x0000

; INT 0x13: SIMD floating-point exception (SIMD_FLOATING_POINT_EXCEPTION)
; TODO: place real handler address here
dw 0x0000
dw 0x0000

; INT 0x14: Virtualization exception (VIRTUALIZATION_EXCEPTION)
; TODO: place real handler address here
dw 0x0000
dw 0x0000

; INT 0x15:
; TODO: place real handler address here
dw 0x0000
dw 0x0000

; INT 0x16:
; TODO: place real handler address here
dw 0x0000
dw 0x0000

; INT 0x17:
; TODO: place real handler address here
dw 0x0000
dw 0x0000

; INT 0x18:
; TODO: place real handler address here
dw 0x0000
dw 0x0000

; INT 0x19:
; TODO: place real handler address here
dw 0x0000
dw 0x0000

; INT 0x1A:
; TODO: place real handler address here
dw 0x0000
dw 0x0000

; INT 0x1B:
; TODO: place real handler address here
dw 0x0000
dw 0x0000

; INT 0x1C:
; TODO: place real handler address here
dw 0x0000
dw 0x0000

; INT 0x1D:
; TODO: place real handler address here
dw 0x0000
dw 0x0000

; INT 0x1E:
; TODO: place real handler address here
dw 0x0000
dw 0x0000

; INT 0x1F:
; TODO: place real handler address here
dw 0x0000
dw 0x0000

; INT 0x20: Hardware generated from IRQ0 pin (IRQ_0)
; TODO: place real handler address here
dw 0x0000
dw 0x0000

; INT 0x21: Hardware generated from IRQ1 pin (IRQ_1)
; TODO: place real handler address here
dw 0x0000
dw 0x0000

; INT 0x22: Hardware generated from IRQ2 pin (IRQ_2)
; TODO: place real handler address here
dw 0x0000
dw 0x0000

; INT 0x23: Hardware generated from IRQ3 pin (IRQ_3)
; TODO: place real handler address here
dw 0x0000
dw 0x0000

; INT 0x24: Hardware generated from IRQ4 pin (IRQ_4)
; TODO: place real handler address here
dw 0x0000
dw 0x0000

; INT 0x25: Hardware generated from IRQ5 pin (IRQ_5)
; TODO: place real handler address here
dw 0x0000
dw 0x0000

; INT 0x26: Hardware generated from IRQ6 pin (IRQ_6)
; TODO: place real handler address here
dw 0x0000
dw 0x0000

; INT 0x27: Hardware generated from IRQ7 pin (IRQ_7)
; TODO: place real handler address here
dw 0x0000
dw 0x0000

; Padding until 1024 B
times (1024 - ($ - $$)) db 0xFF
