# Compiler and assembler, their respective flags along as some scripts
ASM := nasm
ASM_FLAGS := -f bin
CC := ia16-elf-gcc
C_FLAGS := -S -Os -ffreestanding -fno-builtin -masm=intel \
	-fomit-frame-pointer -fno-exceptions \
	-fno-asynchronous-unwind-tables
INTERPRETER := python3
CLEANING_SCRIPT := tools/clean.py
SPLITTER_SCRIPT := tools/split_rom.py
BUILDER_SCRIPT := tools/build_rom.sh

# Build directories
BUILD_DIR := build/
ASM_DIR := $(BUILD_DIR)asm/

# Source code files
ASM_FILES := $(shell find src -type f -name '*.asm')
C_FILES := $(shell find src -type f -name '*.c')

# Binary outputs
ASM_BINS := $(patsubst src/%.asm,$(BUILD_DIR)$(notdir %.bin),$(ASM_FILES))
C_ASM_FILES := $(patsubst src/%.c,$(ASM_DIR)/$(notdir %.s),$(C_FILES))
C_BINS := $(patsubst $(ASM_DIR)/%.s,$(BUILD_DIR)%.bin,$(C_ASM_FILES))

.SECONDARY: $(C_ASM_FILES)

# Default target, makes single indipendent binaries
all: $(ASM_BINS) $(C_BINS)
	@echo "All done."

$(BUILD_DIR):
	@mkdir -p $(BUILD_DIR)
$(ASM_DIR):
	@mkdir -p $(ASM_DIR)

$(ASM_DIR)/%.s: src/%.c | $(ASM_DIR)
	@echo "$(CC): Compiling \"$<\" to \"$(ASM_DIR)$(notdir $@)\"."
	@if ! $(CC) $(C_FLAGS) $< -o  $(ASM_DIR)$(notdir $@); then \
		echo "$(CC): Error when compiling \"$<\", exiting."; \
		false; \
	fi

	@echo "$(INTERPRETER): Cleaning \"$(ASM_DIR)$(notdir $@)\"."
	@if ! $(INTERPRETER) $(CLEANING_SCRIPT) $(ASM_DIR)$(notdir $@); then \
		echo "$(INTERPRETER): Error when cleaning \"$(ASM_DIR)$(notdir $@)\", exiting."; \
		false; \
	fi

$(BUILD_DIR)%.bin: $(ASM_DIR)/%.s | $(BUILD_DIR)
	@echo "$(ASM): Assembling \"$(ASM_DIR)$(notdir $<)\" to \"$(BUILD_DIR)$(notdir $@)\"."
	@if ! $(ASM) $(ASM_FLAGS) $(ASM_DIR)$(notdir $<) -o $(BUILD_DIR)$(notdir $@); then \
		echo "$(ASM): Error when assembling \"$(ASM_DIR)$(notdir $<)\", exiting."; \ exit 1; \
	fi

$(BUILD_DIR)%.bin: src/%.asm | $(BUILD_DIR)
	@echo "$(ASM): Assembling \"$<\" to \"$(BUILD_DIR)$(notdir $@)\"."
	@if ! $(ASM) $(ASM_FLAGS) $< -o $(BUILD_DIR)$(notdir $@); then \
		echo "$(ASM): Error when assembling \"$<\", exiting."; \
		exit 1; \
	fi

# Release target, makes two ROM binaries, one for each physical ROM chip
release: all
	@echo "Building ROM image..."
	@$(BUILDER_SCRIPT) $(BUILD_DIR)
	
	@echo "Splitting ROM image..."
	@$(INTERPRETER) $(SPLITTER_SCRIPT) $(BUILD_DIR)rom.bin
	
	@echo "Release done."

clean:
	@rm -rf $(BUILD_DIR)
	@echo "Cleanup done."

.PHONY: all release clean
