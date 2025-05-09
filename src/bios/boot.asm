; In reality, this is absolutely not a "bootloader", it just jumps to the BIOS.
; It's the BIOS' job to, among other things, bootstrap the kernel.

CPU 8086
BITS 16
ORG 0xFFFF0 ; Reset vector (ROM segment, 4th block)

start:
	JMP FAR [jump_target] ; Jump away, we don't have space here

jump_target:
	dw 0x00000
	dw 0xF09FF ; BIOS' starting address (ROM segment, 2nd block)

; Padding until 16 B (doesn't really matter but i'll put it anyways)
times (16 - ($ - $$)) db 0x00
