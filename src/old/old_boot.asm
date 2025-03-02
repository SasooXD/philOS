org 0x7C00 ; ORG directive: all labels and variables' addresses are to be calculated with this offset.
bits 16 ; emulating an i8086

; NULL (endl) character macro
%define ENDL 0X0D, 0x0A

;* FAT12 Header
jmp short start
nop

; Bios parameter block (BPB) variables - https://wiki.osdev.org/FAT#BPB_.28BIOS_Parameter_Block.29
bdb_oem: db "MSWIN4.1" ; 8 bytes
bdb_bytes_per_sector: dw 512
bdb_sector_per_cluster: db 1
bdb_reserved_sector: dw 1
bdb_fat_count: db 2
bdb_dir_entries_count: dw 0E0h
bdb_total_sectors: dw 2880 ; 2080 * 512 = 1.44mb
bdb_media_descriptor_type: db 0F0h ; F0 = 3.5" floppy disk
bdb_sector_per_fat: dw 9 ; 9 sectors/fat
bdb_sector_per_track: dw 18
bdb_heads: dw 2
bdb_hidden_sectors: dd 0
bdb_large_sector_count: dd 0

; Extended Boot Record (EBR) variables - https://wiki.osdev.org/FAT#Extended_Boot_Record
ebr_drive_number: db 0 ; 0x00: floppy disk
db 0 ; reserved
ebr_signature: db 28h
ebr_volume_id: db 1h, 6h, 3h, 2h ; serial number - the number doesn't matter and here it display Spinoza's birth year
ebr_volume_label: db 'BARUCH     ' ; 11 bytes, padded with spaces
ebr_system_id: db 'FAT12   ' ;system FAT type identifier - 8 bytes



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

	; Reads something from the disk
	; BIOS should set dl to the drive number
	mov [ebr_drive_number], dl

	mov ax, 1 ; LBA=1, second sector from the disk
	mov cl, 1 ;1 sector to read
	mov bx, 0x7E00 ; this should be far enough after the bootloader
	call disk_read

	; Printing section
	mov si, msg_hello ; si has now the address of the message
 	call puts

	cli
	hlt

floppy_error:
	mov si, msg_error_read_failed
	call puts
	jmp wait_keypress_and_reboot

wait_keypress_and_reboot:
	mov ah, 0
	int 16h ; BIOS interrupt that waits for a keypres
	jmp 0FFFFh:0 ; jumpts to the beginning of the BIOS, should reboot
.halt:
	cli ; disable interrupts, this way the CPU can't get out of the "halt" state
	hlt



;* Disk routines

;*Converts an LBA adress to a CHS register
;@params ax: LBA address
;@returns cx [bits 0-5]: sector number, cx [bits 6-15]: cylinder, dh:head
lba_to_chs:
	push ax
	push dx

	xor dx, dx ; dx = 0
	div word [bdb_sector_per_track]

	inc dx
	mov cx, dx
	xor dx, dx
	div word[bdb_heads]

	mov dh, dl
	mov ch, al
	shl ah, 6
	or cl, ah

	pop ax
	mov dl, al
	pop ax
	ret

;* Reads sectors from disk
;@params ax: LBA adress, cl: numbers of sectors to read (-128), dl: drive number, es:bx: memory address where to store read data
disk_read:

	; Save all the registers that are gonna be modified to the stack
	push ax
	push bx
	push cx
	push dx
	push di

	push cx ; temporarily saves CL (number of sectors to read)
	call lba_to_chs ; computes CHS by calling the lba_to_chs function
	pop ax

	mov ah, 02h
	mov di, 3 ; retry count 3 times do to real-world floppy fails

.retry:
	pusha ; saves all register since it's impossible to know what will the BIOS modify
	stc  ; sets the carry flag since some BIOS'es doesn't
	int 13h ; carry flag cleared = success
	jnc .done ; exits the loop

	; The carry flag is not cleared, operation has failed
	popa
	call disk_reset ; a disk reset is neccesary to address the problem.

	dec di ; decremets di
	test di, di ; checks if di is 0,
	jnz .retry ; if not, it retries once again

.fail:
	; All attempts are exhausted, the boot process cannot continue: an error message is displayed
	jmp floppy_error

.done:
	popa

	; Restores all the registers that were previously modified to the stack
	pop ax
	pop bx
	pop cx
	pop dx
	pop di

	ret

;* Reset the disk controller
;@param dl: drive number
disk_reset:
	pusha

	mov ah, 0
	int 13h
	jc floppy_error ; if operation fails, once again the floppy error message get shown

	popa

	ret


msg_hello: db 'Hello, world!', ENDL, 0 ; variable containing the Hello world! message
msg_error_read_failed: db 'Failed to read from disk.', ENDL, 0 ; variable containing the read fail error message

times 510-($-$$) db 0 ; it cycles until the total size of the program is 510, minus the beggininning of the current line ($: ORG offset, $-$$: total lenght of program so far in bytes)
dw 0AA55h ; signature of the program
