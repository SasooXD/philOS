#!/usr/bin/env python3

# Lil script that splits the ROM image into two cus of 8086 bus thingy.
# See this for more info idk <https://electronics.stackexchange.com/q/436110>.

import sys
import os

def split_bin_image(input_file, remove_original=False):
	with open(input_file, 'rb') as f:
		data = f.read()

	low_bytes = bytearray()
	high_bytes = bytearray()

	for i in range(0, len(data), 2):
		low_bytes.append(data[i])
		if i + 1 < len(data):
			high_bytes.append(data[i + 1])
		else:
			high_bytes.append(0x00)  # padding if length is odd

	base_name, ext = os.path.splitext(input_file)
	output_low = f"{base_name}_low{ext}"
	output_high = f"{base_name}_high{ext}"

	with open(output_low, 'wb') as f:
		f.write(low_bytes)
	with open(output_high, 'wb') as f:
		f.write(high_bytes)

	print(f"{input_file} successfully split into {output_low} and {output_high}.")

	if remove_original:
		os.remove(input_file)

if __name__ == "__main__":
    # Check parameters
	if len(sys.argv) < 2 or len(sys.argv) > 3:
		print(f"Usage: {sys.argv[0]} [-r] <input_file>.")
		sys.exit(1)

	# Detect if "-r" is used (removes the original input file after the split)
	if sys.argv[1] == "-r":
		if len(sys.argv) != 3:
			print(f"Usage: {sys.argv[0]} [-r] <input_file>.")
			sys.exit(1)
		input_file = sys.argv[2]
		remove = True
	else:
		input_file = sys.argv[1]
		remove = False

	split_bin_image(input_file, remove_original=remove)
