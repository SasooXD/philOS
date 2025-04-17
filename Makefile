# Compiler and assembler, their respective flags along as the cleaning script and an interpreter
ASM := nasm
ASM_FLAGS := -f bin
CC := ia16-elf-gcc
C_FLAGS := -S -Os -ffreestanding -fno-builtin -masm=intel \
	-fomit-frame-pointer -fno-exceptions \
	-fno-asynchronous-unwind-tables
INTERPRETER := python3
CLEANING_SCRIPT := tools/clean.py

# Build directories
# BUILD_DIR contains all binaries
# ASM_DIR is a subdirectory of BUILD_DIR and contains compiled code from C source code
BUILD_DIR := build/
ASM_DIR := $(BUILD_DIR)/asm/

# Source code files in the src/ directory and all of its subdirectories
ASM_FILES := $(shell find src -type f -name '*.asm')
C_FILES := $(shell find src -type f -name '*.c')

# Binary files for every source code file found
ASM_BINS := $(patsubst src/%.asm,$(BUILD_DIR)/$(notdir %.bin),$(ASM_FILES))
C_ASM_FILES := $(patsubst src/%.c,$(ASM_DIR)/$(notdir %.s),$(C_FILES))
C_BINS := $(patsubst $(ASM_DIR)/%.s,$(BUILD_DIR)/%.bin,$(C_ASM_FILES))

# Mark files in ASM_DIR as secondary to prevent them from being deleted
.SECONDARY: $(C_ASM_FILES)

# Build all binaries
all: $(ASM_BINS) $(C_BINS)
	@echo "All done."

# Create build directories if they do not exist
$(BUILD_DIR):
	@mkdir -p $(BUILD_DIR)
$(ASM_DIR):
	@mkdir -p $(ASM_DIR)

# Compile C source code into assembly and clean it for NASM compatibility
$(ASM_DIR)/%.s: src/%.c | $(ASM_DIR)
	@echo "$(CC): Compiling \"$<\" to \"$(ASM_DIR)/$(notdir $@)\"."
	@if ! $(CC) $(C_FLAGS) $< -o  $(ASM_DIR)/$(notdir $@); then \
		echo "$(CC): Error when compiling \"$<\", aborting."; \
		false; \
	fi

	@echo "$(INTERPRETER): Cleaning \"$(ASM_DIR)/$(notdir $@)\"."
	@if ! $(INTERPRETER) $(CLEANING_SCRIPT) $(ASM_DIR)/$(notdir $@); then \
		echo "$(INTERPRETER): Error when cleaning \"$(ASM_DIR)/$(notdir $@)\", aborting."; \
		false; \
	fi

# Assemble C-derived assembly code into binary
$(BUILD_DIR)/%.bin: $(ASM_DIR)/%.s | $(BUILD_DIR)
	@echo "$(ASM): Assembling \"$(ASM_DIR)/$(notdir $<)\" to \"$(BUILD_DIR)/$(notdir $@)\"."
	@if ! $(ASM) $(ASM_FLAGS) $(ASM_DIR)/$(notdir $<) -o $(BUILD_DIR)/$(notdir $@); then \
		echo "$(ASM): Error when assembling \"$(ASM_DIR)/$(notdir $<)\", aborting."; \
		exit 1; \
	fi

# Assemble native assembly source code into binary
$(BUILD_DIR)/%.bin: src/%.asm | $(BUILD_DIR)
	@echo "$(ASM): Assembling \"$<\" to \"$(BUILD_DIR)/$(notdir $@)\"."
	@if ! $(ASM) $(ASM_FLAGS) $< -o $(BUILD_DIR)/$(notdir $@); then \
		echo "$(ASM): Error when assembling \"$<\", aborting."; \
		exit 1; \
	fi

# Cleanup (make clean)
clean:
	@rm -rf $(BUILD_DIR)
	@echo "Cleanup done."

.PHONY: all clean
