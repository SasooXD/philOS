CPU 8086
BITS 16

LCD_CMD     EQU 0x00
LCD_DATA    EQU 0x02

; Put the stack pointer at the end of the RAM block
memory_setup:
	MOV AX, 0x1FFF   ; segment: (0x1FFF << 4) = 0x1FFF0
	MOV SS, AX
	MOV SP, 0x0010   ; offset: 0x1FFF0 + 0x0010 = 0x20000

mov cx, 0xFFFF  ; es. ~16ms a 620kHz
.delay:
    dec cx
    jnz .delay

copy_idt:
	CLI                     ; disable interrupts just for safety

	MOV SI, 0x0000          ; source offset (RAM)
	MOV DI, 0x0000          ; dst offset (RAM)

	MOV AX, 0xFA80          ; source segment (ROM)
	MOV DS, AX

	MOV AX, 0x0000          ; dst segment (RAM)
	MOV ES, AX

	MOV CX, 1024            ; number of bytes to copy over

	CLD
	REP MOVSB              ; copy!!

	STI                     ; enable interrupts

init:
        mov cx, 0x0600
.1:     dec cx
        jnz .1

        mov al, 0x30
        out LCD_CMD, al

        mov cx, 0x0100
.2:     dec cx
        jnz .2

        mov al, 0x30
        out LCD_CMD, al

        mov cx, 0x0020
.3:     dec cx
        jnz .3

        mov al, 0x38    ; function set
        out LCD_CMD, al

        mov cx, 0x0010
.4:     dec cx
        jnz .4

        mov al, 0x08    ; display off
        out LCD_CMD, al

        mov cx, 0x0010
.5:     dec cx
        jnz .5

        mov al, 0x01    ; clear display
        out LCD_CMD, al

        mov cx, 0x0200
.6:     dec cx
        jnz .6

        mov al, 0x02    ; return home
        out LCD_CMD, al

        mov cx, 0x0200
.7:     dec cx
        jnz .7

        mov al, 0x06    ; entry mode set
        out LCD_CMD, al

        mov cx, 0x0010
.8:     dec cx
        jnz .8

        mov al, 0x0c    ; display on, no cursor
        out LCD_CMD, al

        mov cx, 0x0010
.9:     dec cx
        jnz .9

        mov al, 'C'
        out LCD_DATA, al

        mov cx, 0x0010
.10:    dec cx
        jnz .10

        mov al, 'i'
        out LCD_DATA, al

        mov cx, 0x0010
.11:    dec cx
        jnz .11

        mov al, 'a'
        out LCD_DATA, al

        mov cx, 0x0010
.12:    dec cx
        jnz .12

        mov al, 'o'
        out LCD_DATA, al

        INT 0x00

        JMP $

; padding until 13296 b
times (13296 - ($ - $$)) db 0xFF
