# This is a script that "translates" the output of ia16-elf-gcc -S into something that nasm
# can understand better. By default, gcc compilation creates assembly files that are then
# fed into gas which has different directives and other things that we don't need/need to remove.
# The -masm=intel flag from ia16-elf-gcc is still needed tho, because not a chance i'm
# reading/writing assembly with that absolutely horrendous and complete dogshit of at&t syntax.

#TODO: rewrite this (kinda works for our purposes but needs to be translated and reformatted)

import re
import sys

def clean_assembly(input_file):
    with open(input_file, 'r') as infile:
        lines = infile.readlines()

    cleaned_lines = []
    for line in lines:
        line = re.sub(r'^[ ]+', '\t', line)

        if any(directive in line for directive in [
            ".arch", ".code16", ".intel_syntax", "#NO_APP",
            ".section", ".global", ".type", ".size", ".ident"
        ]):
            continue

        line = re.sub(r'\b([a-z]+)\b', lambda m: m.group(1).upper(), line)
        line = re.sub(r'\t+', ' ', line)
        line = re.sub(r'\bMAIN\b', 'start', line)

        if line.strip():
            cleaned_lines.append(line)

    with open(input_file, 'w', newline='\n') as outfile:
        outfile.writelines(cleaned_lines)

if __name__ == "__main__":
    if len(sys.argv) != 2:
        print(f"Uso: {sys.argv[0]} <file_input>")
        sys.exit(1)

    clean_assembly(sys.argv[1])
