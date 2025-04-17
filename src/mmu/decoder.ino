// Note(s):
// - All of the CS (chip select) signals are actually inverted.
// - Some of the here named "CS" signals aren't actually named CS in datasheets (enable, chip enable).

const uint AD[]     = {22, 23, 24, 25, 26, 27, 28, 29, 30, 31, 32, 33, 34, 35, 36, 37, 38, 39, 40, 41}; // Address and data multiplexed signals
const uint ALE      = 42; // ALE (Address Latch Enable) signal
const uint WR       = 43; // Read signal inverted. THIS IS THE RD PIN!!!
const uint RD       = 44; // Write signal inverted. THIS IS THE WR PIN!!!
const uint MIO      = 45; // M/IO signal from the M/IO pin, it's 1 when accessing memory, 0 when accessing I/O
const uint CS_8251  = 46; // i8251 (UART chip) chip select signal
const uint CS_LCD   = 47; // LCD chip select signal
const uint CS_8255  = 48; // i8255 (PPI) chip select signal
const uint CS_8259  = 49; // i8259 (PIC) chip select signal
const uint CS_RAM   = 50; // RAM chip select signals, this signal is connected to two physical ram chips
const uint CS_ROM1  = 51; // ROM #1 chip select signal
const uint CS_ROM2  = 52; // ROM #2 chip select signal
const uint MMU_INT  = 53; // This is an interrupt triggered by an memory segmentation fault, see the docs for more info

void setup() {
	// Inizializza pin CS come output
	pinMode(CS_ROM1, OUTPUT);
	pinMode(CS_ROM2, OUTPUT);
	pinMode(CS_RAM, OUTPUT);

	// Inizializza AD come input
	for (int i = 0; i < 20; i++) {
		pinMode(AD[i], INPUT);
	}

	// Imposta CS disattivi (HIGH)
	digitalWrite(CS_ROM1, HIGH);
	digitalWrite(CS_ROM2, HIGH);
	digitalWrite(CS_RAM, HIGH);
}

void loop() {
	uint32_t address = readAddress();

	// Disattiva tutti i CS all'inizio
	digitalWrite(CS_ROM1, HIGH);
	digitalWrite(CS_ROM2, HIGH);
	digitalWrite(CS_RAM,  HIGH);

	// Attiva solo quello giusto
	if ((address >= 0x00000 && address <= 0x003FF) ||
		(address >= 0xF0A00 && address <= 0xFFFEF) ||
		(address >= 0xFFFF0 && address <= 0xFFFFF)) {
			digitalWrite(CS_ROM1, LOW); // Attiva ROM1
		}
	else if ((address >= 0x00400 && address <= 0x080FF) ||
		(address >= 0x08100 && address <= 0x0FDFF)) {
			digitalWrite(CS_ROM2, LOW); // Attiva ROM2
	}
	else if (address >= 0x0FE00 && address <= 0x17AFF) {
		digitalWrite(CS_RAM, LOW); // Attiva RAM
	}

	// !TODO: ALE or M/IO to sync
}

// Legge i 20 bit da AD[0..19] e restituisce l'indirizzo come uint32_t
uint32_t readAddress() {
	uint32_t addr = 0;

	for (int i = 0; i < 20; i++) {
		if (digitalRead(AD[i])) {
		addr |= (1UL << i);
		}
	}

	return addr;
}
