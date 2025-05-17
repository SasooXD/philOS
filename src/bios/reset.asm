; 0xFFFF0 is the first address read by the i8086 after reset. This code just jumps to the BIOS.

CPU 8086
BITS 16
ORG 0xFFFF0 ; Reset vector starting address

start:
	JMP WORD 0xFCC0:0x0000 ; Jump to BIOS, we don't have space here

; Padding until 16 B (DOES matter bc of mr. build_rom.sh)
times (16 - ($ - $$)) db 0xFF
