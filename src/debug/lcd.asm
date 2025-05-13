BITS 16
CPU 8086

LCD_CMD_ADDR equ 0xF008
LCD_DATA_ADDR equ 0xF00B

start:

    mov al, 0x30 
    mov [LCD_CMD_ADDR], al

    mov al, 0x30 
    mov [LCD_CMD_ADDR], al

    mov al, 0x30 
    mov [LCD_CMD_ADDR], al

    mov al, 0x38
    mov [LCD_CMD_ADDR], al

    mov al, 0x08 
    mov [LCD_CMD_ADDR], al

    mov al, 0x01 
    mov [LCD_CMD_ADDR], al

    mov al, 0x06
    mov [LCD_CMD_ADDR], al

    mov al, 0x0C
    mov [LCD_CMD_ADDR], al

    ; Function set command
    mov al, 'C'
    mov [LCD_DATA_ADDR], al

    mov al, 'I'
    mov [LCD_DATA_ADDR], al

    mov al, 'A' 
    mov [LCD_DATA_ADDR], al

    mov al, 'O' 
    mov [LCD_DATA_ADDR], al

    jmp $

