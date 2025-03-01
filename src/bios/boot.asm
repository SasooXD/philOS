; In reality, this is absolutely not a "bootloader", it just jumps to the BIOS.
; It's the BIOS' job to, among other things, bootstrap the kernel.

BITS 16
ORG 0xFFFF0 ; The i8086 will begin execution here after RESET (ROM segment, 3rd block)

start:
	JMP	FAR		[jump_target] ; Jump away, we don't have space here

jump_target:
	dw			0x00000
	dw			0xF09FF ; BIOS' starting address (ROM segment, 2nd block)
