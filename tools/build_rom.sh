#!/bin/bash

# Script that concatenates all compiled files to build the ROM image.
# Remember that the image still needs to be split into two parts!

# This is the expected size of the full ROM image, basically the size of a single ROM chip
EXPECTED_ROM_SIZE=65536  # 64 KiB

# Check parameter
if [ -z "$1" ]; then
	echo "Usage: $0 <build_directory>."
	exit 1
fi

BUILD_DIR="$1"
OUT_ROM="$BUILD_DIR/rom.bin"

# Clean temporary binaries if they already exist
rm -f "$BUILD_DIR/isr.bin" "$BUILD_DIR/os.bin" "$BUILD_DIR/bios_full.bin"

# Generate isr.bin by concatenating all isr*.bin files in sorted order and remove them afterwards
cat $(ls "$BUILD_DIR"/isr*.bin 2>/dev/null | sort) > "$BUILD_DIR/isr.bin"

# Build bios_full.bin = idt.bin + isr.bin + bios.bin + reset.bin
cat "$BUILD_DIR/idt.bin" "$BUILD_DIR/isr.bin" "$BUILD_DIR/bios.bin" "$BUILD_DIR/reset.bin" > "$BUILD_DIR/bios_full.bin"
rm -f "$BUILD_DIR"/isr*.bin

# List of already used binaries
USED_FILES=(
	"idt.bin"
	"isr.bin"
	"bios.bin"
	"bios_full.bin"
	"reset.bin"
	"rom.bin"
)

# Find unused binaries
REMAINING_FILES=()
for f in "$BUILD_DIR"/*.bin; do
fname=$(basename "$f")
	if [[ ! " ${USED_FILES[@]} " =~ " ${fname} " && "$fname" != "kernel.bin" ]]; then
		REMAINING_FILES+=("$f")
	fi
done

# Create os.bin = kernel.bin + all remaining binaries
cat "$BUILD_DIR/kernel.bin" "${REMAINING_FILES[@]}" > "$BUILD_DIR/os.bin"

# Create final ROM image: os.bin + bios_full.bin
cat "$BUILD_DIR/os.bin" "$BUILD_DIR/bios_full.bin" > "$OUT_ROM"

# Nuke everything if the rom image is not exactly the expected size
ROM_SIZE=$(stat -c%s "$OUT_ROM")
if [ "$ROM_SIZE" -ne "$EXPECTED_ROM_SIZE" ]; then
 	echo "Error: ROM image must be exactly $EXPECTED_ROM_SIZE bytes, got $ROM_SIZE bytes!"
 	rm -rf "$BUILD_DIR"
 	exit 2
fi

# Delete all other binaries except rom.bin
find "$BUILD_DIR" -type f -name '*.bin' ! -name 'rom.bin' -delete

echo "Full ROM image successfully built at $OUT_ROM (65536 byte)"
