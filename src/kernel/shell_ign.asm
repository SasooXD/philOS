; This is an example of an implementation of a simple shell, the real one should be under
; "kernel.asm". This code should not be part of the final ROM image.

CPU 8086
BITS 16
ORG 0xF0000 ; Kernel image starting address

start:
