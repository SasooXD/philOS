; In reality, this is absolutely not a "bootloader", it just jumps to the BIOS.
; It's the BIOS' job to, among other things, bootstrap the kernel.

BITS 16
ORG 0xFFF0 ; The i8086 will begin execution here after RESET

start:
	JMP	FAR		[jump_target] ; Jump away, we don't have space here

jump_target:
	dw			0x0000
	dw			0xF000
