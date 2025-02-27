# Compiler and assembler, each with their respective flags
ASM			:= nasm
ASM_FLAGS	:= -f bin
CC			:= ia16-elf-gcc
C_FLAGS		:= -S -Os -ffreestanding -fno-builtin -masm=intel -fomit-frame-pointer -fno-exceptions -fno-asynchronous-unwind-tables
CLEAN_TOOL	:= python3 tools/clean.py

# Build directories; BUILD_DIR contains binaries while ASM_DIR is a subdirectory of BUILD_DIR and contains compiled code from C source code
BUILD_DIR	:= build
ASM_DIR		:= $(BUILD_DIR)/asm

# Files in the src/ directory and all of its subdirectories
ASM_FILES	:= $(shell find src -type f -name '*.asm')
C_FILES		:= $(shell find src -type f -name '*.c')

# List of binary files for every source code file found
ASM_BINS	:= $(patsubst src/%.asm,$(BUILD_DIR)/$(notdir %.bin),$(ASM_FILES))
C_ASM_FILES	:= $(patsubst src/%.c,$(ASM_DIR)/$(notdir %.s),$(C_FILES))
C_BINS		:= $(patsubst $(ASM_DIR)/%.s,$(BUILD_DIR)/%.bin,$(C_ASM_FILES))

# Mark .s files in ASM_DIR as secondary to prevent them from being deleted
.SECONDARY: $(C_ASM_FILES)

# Build all binary files
all: $(ASM_BINS) $(C_BINS)

# Create build directories if they do not exist
$(BUILD_DIR):
	mkdir -p $(BUILD_DIR)

$(ASM_DIR):
	mkdir -p $(ASM_DIR)

# Compile C source code into assembly
$(ASM_DIR)/%.s: src/%.c | $(ASM_DIR)
	$(CC) $(C_FLAGS) $< -o $@
	$(CLEAN_TOOL) $@  # Pulisce il file .s appena generato

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
