#!/usr/bin/env python3

# Lil script that splits the ROM image into two cus of 8086 bus thingy.
# see this for more info idk <https://electronics.stackexchange.com/q/436110>.

import sys
import os

def split_bin_image(input_file):
	with open(input_file, 'rb') as f:
		data = f.read()

	low_bytes = bytearray()
	high_bytes = bytearray()

	for i in range(0, len(data), 2):
		low_bytes.append(data[i])
		if i + 1 < len(data):
			high_bytes.append(data[i + 1])
		else:
			high_bytes.append(0x00)  # padding if lenght is odd

	base_name, ext = os.path.splitext(input_file)
	output_low = f"{base_name}_low{ext}"
	output_high = f"{base_name}_high{ext}"

	with open(output_low, 'wb') as f:
		f.write(low_bytes)
	with open(output_high, 'wb') as f:
		f.write(high_bytes)

if __name__ == "__main__":
	if len(sys.argv) != 2:
		print(f"Usage: {sys.argv[0]} <input_file>.")
		sys.exit(1)

	split_bin_image(sys.argv[1])
