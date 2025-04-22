// Note(s):
// - most of the CS (chip select) signals are actually inverted.
// - Some of the here named "CS" signals aren't actually named CS in datasheets (enable, chip enable).

const int AD[]     = {22, 23, 24, 25, 26, 27, 28, 29, 30, 31, 32, 33, 34, 35, 36, 37, 38, 39, 40, 41}; // Address and data multiplexed signals
const int ALE      = 45; // ALE (Address Latch Enable) signal
const int RD       = 49; // Read signal inverted.
const int WR       = 51; // Write signal inverted. 
const int MIO      = 46; // M/IO signal from the M/IO pin, it's 1 when accessing memory, 0 when accessing I/O
const int CS_8251  = 48; // i8251 (UART chip) chip select signal
const int CS_LCD   = 52; // LCD chip select signal
const int CS_8255  = 50; // i8255 (PPI) chip select signal
const int CS_8259  = 47; // i8259 (PIC) chip select signal
const int CS_RAM   = 42; // RAM chip select signals, this signal is connected to two physical ram chips
const int CS_ROM1  = 43; // ROM #1 chip select signal
const int CS_ROM2  = 44; // ROM #2 chip select signal
const int MMU_INT  = 53; // This is an interrupt triggered by an memory segmentation fault, see the docs for more info

void setup() {
  // Inizializza pin CS come output
  pinMode(CS_ROM1, OUTPUT);
  pinMode(CS_ROM2, OUTPUT);
  pinMode(CS_RAM, OUTPUT);
  pinMode(CS_8251, OUTPUT);
  pinMode(CS_LCD, OUTPUT);
  pinMode(CS_8255, OUTPUT);
  pinMode(CS_8259, OUTPUT);

  //inizializza i pin di configurazione come input
  pinMode(ALE, INPUT);
  pinMode(RD, INPUT);
  pinMode(WR, INPUT);
  pinMode(MIO, INPUT);

  // Inizializza AD come input
  for (int i = 0; i < 20; i++) {
    pinMode(AD[i], INPUT);
  }

  // Imposta CS disattivi 
  digitalWrite(CS_ROM1, HIGH);
  digitalWrite(CS_ROM2, HIGH);
  digitalWrite(CS_RAM, HIGH);
  digitalWrite(CS_8251, HIGH);
  digitalWrite(CS_LCD, LOW);
  digitalWrite(CS_8255, HIGH);
  digitalWrite(CS_8259, HIGH);
}

void loop() {

}
