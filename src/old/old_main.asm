org 0x7C00 ; ORG directive: all labels and variables' addresses are to be calculated with this offset.
bits 16 ; emulating an i8086

; NULL (endl) character macro
%define ENDL 0X0D, 0x0A

;! No instruction may be put before this section.

;* Dummy function that jumps to the real starting point of the program.
start:
	jmp main

;* Prints a string to the stdio until it encounters a NULL character.
;@param ds:di: pointers to strings.
puts:
	; Save registers which will be modified
	push si
	push ax

;* Loops over all the characters of which DS:SI point to.
.loop:
	lodsb ; loads a byte from DS:SI into AL/AX/EAX, then increments SI by the number of bytes loaded

	; Verifies if next value is null: performing an OR between equal source and destination won't modify neither but will create a zero flag
	or al, al ; performs a bitwise OR operation between source and destination, then stores the result in destination

	; Jumps to destination if the zero flag is set
	jz .done

	mov ah, 0x0e ; Calls the BIOS interrupt
	mov bh, 0
	int 0x10

	; If the previous instruction is ignored, it means the zero flag is not set: the loop must continue. A recursive instruction that jumps to itself is set
	jmp .loop

;* After the loop is over (a NULL character has been inserted) it pops to the stack the offsets of AX and SI, previously pushed in puts.
.done:
	pop ax
	pop si
	ret ; exits



;* Starting point of the program.
main:
	; Since it is impossible to write directly to registers ds/es, register ax is used
	mov ax, 0
	mov ds, ax
	mov es, ax

	; Stack setup
	mov ss, ax
	mov sp, 0x7C00 ; stack continues downwards from where the OS will be loaded in memory, thus it won't override the memory of the program

	; Printing section
	mov si, msg_hello ; si has now the address of the message
 	call puts

	hlt

;* Secondary halt point
.halt:
	jmp .halt

msg_hello: db 	'Hello, world!', ENDL, 0 ; variable containing the Hello world! message
times 510-($-$$) db 0 ; it cycles until the total size of the program is 510, minus the beggininning of the current line ($: ORG offset, $-$$: total lenght of program so far in bytes)
dw 0AA55h ; signature of the program
