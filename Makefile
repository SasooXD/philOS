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

# Default target, makes single binaries
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
	@if ! $(ASM) $(ASM_FLAGS) $(ASM_DIR)$(notdir $<) -o $(BUILD_DIR)$(notdir $@); then \ echo "$(ASM): Error when assembling \"$(ASM_DIR)$(notdir $<)\", exiting."; \ exit 1; \
	fi

$(BUILD_DIR)%.bin: src/%.asm | $(BUILD_DIR)
	@echo "$(ASM): Assembling \"$<\" to \"$(BUILD_DIR)$(notdir $@)\"."
	@if ! $(ASM) $(ASM_FLAGS) $< -o $(BUILD_DIR)$(notdir $@); then \
		echo "$(ASM): Error when assembling \"$<\", exiting."; \
		exit 1; \
	fi

# Release target, makes ROM-ready binaries
release: all
	@echo "Creating ROM directories..."
	@mkdir -p $(BUILD_DIR)rom1 $(BUILD_DIR)rom2

	@echo "Sorting binaries..."
	@cp $(BUILD_DIR)idt.bin $(BUILD_DIR)rom1/
	@cp $(BUILD_DIR)bios.bin $(BUILD_DIR)rom1/
	@cp $(BUILD_DIR)boot.bin $(BUILD_DIR)rom1/
	@cp $(BUILD_DIR)isr*.bin $(BUILD_DIR)rom1/ 2>/dev/null || true
	@cp $(BUILD_DIR)kernel.bin $(BUILD_DIR)rom2/
	@find $(BUILD_DIR) -maxdepth 1 -name '*.bin' ! -name 'rom1.bin' ! -name 'rom2.bin' ! -name 'idt.bin' ! -name 'bios.bin' ! -name 'boot.bin' ! -name 'isr*.bin' ! -name 'kernel.bin' -exec cp {} $(BUILD_DIR)rom2/ \;

	@echo "Building rom1.bin..."
	@cat $(BUILD_DIR)rom1/idt.bin \
		$(BUILD_DIR)rom1/bios.bin \
		$$(find $(BUILD_DIR)rom1 -name 'isr*.bin' | sort -V) \
		$(BUILD_DIR)rom1/boot.bin > $(BUILD_DIR)rom1.bin

	@rom1_size=$$(stat -c%s $(BUILD_DIR)rom1.bin); \
	 if [ $$rom1_size -ne 64000 ]; then \
	   echo "Error: rom1.bin size ($$rom1_size) is not 64000 bytes! Aborting release."; \
	   rm -rf $(BUILD_DIR); \
	   exit 1; \
	 fi

	@echo "Building rom2.bin..."
	@cat $(BUILD_DIR)rom2/kernel.bin \
		$$(find $(BUILD_DIR)rom2 -type f ! -name 'kernel.bin' | sort) > $(BUILD_DIR)rom2.bin

	@rom2_size=$$(stat -c%s $(BUILD_DIR)rom2.bin); \
	 if [ $$rom2_size -gt 64000 ]; then \
	   echo "Error: rom2.bin size ($$rom2_size) exceeds 64000 bytes! Aborting release."; \
	   rm -rf $(BUILD_DIR); \
	   exit 1; \
	 fi

	@echo "Cleaning up build directory..."
	@find $(BUILD_DIR) -type f -name '*.bin' ! -name 'rom1.bin' ! -name 'rom2.bin' -delete
	@rm -rf $(BUILD_DIR)rom1 $(BUILD_DIR)rom2 $(ASM_DIR)

	@echo "Release done."

clean:
	@rm -rf $(BUILD_DIR)
	@echo "Cleanup done."

.PHONY: all release clean
