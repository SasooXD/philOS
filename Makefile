# Compiler and assembler, each with their respective flags 
ASM			:= nasm 
ASM_FLAGS	:= -f bin
CC			:= ia16-elf-gcc
C_FLAGS		:= -S -Os -ffreestanding -fno-builtin -masm=intel -fomit-frame-pointer -fno-exceptions -fno-asynchronous-unwind-tables

# Build directories; BUILD_DIR contains binaries while ASM_DIR is a subdirectory of BUILD_DIR and contains compiled code from C source code 
BUILD_DIR	:= build
ASM_DIR		:= $(BUILD_DIR)/asm

# Files in the src/ directory and all of its subdirectories
ASM_FILES	:= $(shell find src -type f -name '*.asm')
C_FILES		:= $(shell find src -type f -name '*.c')

# List of binary files for every source code file found
# Only the name of the file, no path
ASM_BINS	:= $(patsubst src/%.asm,$(BUILD_DIR)/%.bin,$(ASM_FILES))
C_ASM_FILES	:= $(patsubst src/%.c,$(ASM_DIR)/%.s,$(C_FILES))

# Build all binary files
all: $(ASM_BINS) $(C_ASM_FILES)

# Create build directories if they do not exist
$(BUILD_DIR):
	mkdir -p $(BUILD_DIR)

$(ASM_DIR):
	mkdir -p $(ASM_DIR)

# Compile C source code into assembly
$(ASM_DIR)/%.s: src/%.c | $(ASM_DIR)
	$(CC) $(C_FLAGS) $< -o $(ASM_DIR)/$(notdir $@)

#TODO: doesn't work, fix this
# Assemble C-derived assembly code into binary
$(BUILD_DIR)/%.bin: $(ASM_DIR)/%.s | $(BUILD_DIR)
	$(ASM) $(ASM_FLAGS) $< -o $@

# Assemble native assembly source code into binary
$(BUILD_DIR)/%.bin: src/%.asm | $(BUILD_DIR)
	$(ASM) $(ASM_FLAGS) $< -o $(BUILD_DIR)/$(notdir $@)

# Cleanup (make clean)
clean:
	rm -rf $(BUILD_DIR)

.PHONY: all clean
