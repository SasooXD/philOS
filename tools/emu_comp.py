import re

def process_assembly(file_path, output_path):
    # Modello per identificare indirizzamenti diretti con offset
    pattern = re.compile(r"\[([a-z]{2})\s*([\+\-])\s*(\d+)\]")
    
    with open(file_path, 'r') as f:
        lines = f.readlines()
    
    new_lines = []
    for line in lines:
        match = pattern.search(line)
        if match:
            base_reg = match.group(1)  # Registro base (es. bp)
            operator = match.group(2)  # Operatore + o -
            offset = int(match.group(3))  # Valore dell'offset

            # Calcola l'istruzione per il calcolo dell'indirizzo
            new_lines.append(f"    mov si, {base_reg}\n")
            if operator == '+':
                new_lines.append(f"    add si, {offset}\n")
            else:
                new_lines.append(f"    sub si, {offset}\n")

            # Sostituisci l'offset diretto con l'uso di [si]
            modified_line = re.sub(r"\[[a-z]{2}\s*[\+\-]\s*\d+\]", "[si]", line)
            new_lines.append(modified_line)
        else:
            new_lines.append(line)
    
    with open(output_path, 'w') as f:
        f.writelines(new_lines)

    print(f"File processato e salvato in: {output_path}")

# Specifica il file di input e output
input_file = "output.s"  # Nome del file assembly originale
output_file = "output.asm"  # Nome del file assembly modificato

# Esegui la funzione di elaborazione
process_assembly(input_file, output_file)
