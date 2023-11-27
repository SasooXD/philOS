ASM=nasm

SRC_DIR=src
BUILD_DIR=build

build/main_floppy.img: build/main.bin
	cp build/main.bin build/main_floppy.img
	truncate -s 1440k build/main_floppy.img
	
build/main.bin: src/main.asm
	nasm src/main.asm -f bin -o build/main.bin