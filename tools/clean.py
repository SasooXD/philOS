import re

def clean_assembly(input_file, output_file):
    with open(input_file, 'r') as infile:
        lines = infile.readlines()

    cleaned_lines = []
    for line in lines:
        # Sostituisce lo spazio iniziale con un tab
        line = re.sub(r'^[ ]+', '\t', line)
        
        # Rimuove direttive inutili o incompatibili con NASM
        if any(directive in line for directive in [
            ".arch", ".code16", ".intel_syntax", "#NO_APP",
            ".section", ".global", ".type", ".size", ".ident"
        ]):
            continue
        
        # Converte nomi di registri e istruzioni in maiuscolo
        line = re.sub(r'\b([a-z]+)\b', lambda m: m.group(1).upper(), line)
        
        # Sostituisce i tab tra operandi con uno spazio
        line = re.sub(r'\t+', ' ', line)

        # Aggiunge la linea pulita solo se non è vuota
        if line.strip():
            cleaned_lines.append(line)
        
        # Converte "main" in "start"
        line = re.sub(r'\bMAIN\b', 'start', line)

    # Scrive il file di output
    with open(output_file, 'w', newline='\n') as outfile:
        outfile.writelines(cleaned_lines)

# Esegui lo script
clean_assembly('output.s', 'final.asm')


with open('final.asm', 'r') as infile, \
     open('final.assm', 'w', newline='\n') as outfile:
    outfile.writelines(infile.readlines())