#TODO: reformat everything

# Compiler and assembler, with flags
NASM      := nasm 
#TODO: add NASM flags
CC        := ia16-elf-gcc
CFLAGS    := -S -Os -ffreestanding -fno-builtin -masm=intel -fomit-frame-pointer -fno-exceptions -fno-asynchronous-unwind-tables

SHELL := /bin/bash

# Finds file in src/ directory
ASM_FILES := $(shell find src -type f -name "*.asm")
C_FILES   := $(shell find src -type f -name "*.c")

# Generates the path of binaries inside bin/ directory
BIN_DIR   := bin
ASM_BINS  := $(ASM_FILES:src/%.asm=$(BIN_DIR)/%.bin)
C_BINS    := $(C_FILES:src/%.c=$(BIN_DIR)/%.bin)

# Every final target
ALL_BINS  := $(ASM_BINS) $(C_BINS)

# ???
all: $(ALL_BINS)

# Assemble assembly file rule
$(BIN_DIR)/%.bin: src/%.asm | $(BIN_DIR)
	$(NASM) -f bin $< -o $@

# Compile C file rule
$(BIN_DIR)/%.bin: src/%.c | $(BIN_DIR)
	$(CC) $(CFLAGS) $< -o $@

# Creates bin/ directory if not there (should always be there)
$(BIN_DIR):
	mkdir -p $(BIN_DIR)

# Cleanup
clean:
	rm -rf $(BIN_DIR)

.PHONY: all clean
