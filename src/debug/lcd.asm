BITS 16
CPU 8086

LCD_CMD equ 0x8 
LCD_DATA equ 0xB

start:

mov al, 0x30 
out LCD_CMD, al

mov al, 0x30 
out LCD_CMD, al

mov al, 0x30 
out LCD_CMD, al

mov al, 0x38
out LCD_CMD, al

mov al, 0x08 
out LCD_CMD, al

mov al, 0x01 
out LCD_CMD, al

mov al, 0x06
out LCD_CMD, al

mov al, 0x0c
out LCD_CMD, al

;Function set command
mov al, 'C'
out LCD_DATA, al

mov al, 'I'
out LCD_DATA, al

mov al, 'A' 
out LCD_DATA, al

mov al, 'O' 
out LCD_DATA, al

jmp $
