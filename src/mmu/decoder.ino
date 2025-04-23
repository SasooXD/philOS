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
uint32_t address;//indirizzo letto

void setup() {
  pinMode(CS_ROM1, OUTPUT);
  pinMode(CS_ROM2, OUTPUT);
  pinMode(CS_RAM, OUTPUT);
  pinMode(CS_8251, OUTPUT);
  pinMode(CS_LCD, OUTPUT);
  pinMode(CS_8255, OUTPUT);
  pinMode(CS_8259, OUTPUT);

  pinMode(ALE, INPUT);
  pinMode(RD, INPUT);
  pinMode(WR, INPUT);
  pinMode(MIO, INPUT);

  for (int i = 0; i < 20; i++) {
    pinMode(AD[i], INPUT);
  }

  digitalWrite(CS_ROM1, HIGH);
  digitalWrite(CS_ROM2, HIGH);
  digitalWrite(CS_RAM, HIGH);
  digitalWrite(CS_8251, HIGH);
  digitalWrite(CS_LCD, LOW);
  digitalWrite(CS_8255, HIGH);
  digitalWrite(CS_8259, HIGH);
}

void loop() {
  if(digitalRead(ALE) == LOW){
    address = readAddress();
  }else{
    digitalWrite(CS_ROM1, HIGH);
    digitalWrite(CS_ROM2, HIGH);
    digitalWrite(CS_RAM, HIGH);
    digitalWrite(CS_8251, HIGH);
    digitalWrite(CS_LCD, LOW);
    digitalWrite(CS_8255, HIGH);
    digitalWrite(CS_8259, HIGH);

    if(digitalRead(MIO) == HIGH and digitalRead(RD) != digitalRead(WR)){
      if (((address >= 0x00000 && address <= 0x003FF) ||
        (address >= 0xF0400 && address <= 0xFFFEF) ||
        (address >= 0xFFFF0 && address <= 0xFFFFF))
        and (digitalRead(RD) == LOW)) {
          digitalWrite(CS_ROM1, LOW); // Attiva ROM1
        }
      else if ((address >= 0x00400 && address <= 0x083FF)
        and (digitalRead(RD) == LOW)) {
          digitalWrite(CS_ROM2, LOW); // Attiva ROM2
      }
      else if (address >= 0x10400 && address <= 0x183FF) {
        digitalWrite(CS_RAM, LOW); // Attiva RAM
      }
    }else if(digitalRead(MIO) == LOW and digitalRead(RD) != digitalRead(WR)){
      if(address == 0b00000000000000000000 || address == 0b00000000000000000001 || address == 0b00000000000000000010 || address == 0b00000000000000000011){
        digitalWrite(CS_8255, LOW); // PPI
      }
      else if(address == 0b00000000000000000100 || address == 0b00000000000000000101){
        digitalWrite(CS_8259, LOW); // PIC
      }
      else if(address == 0b00000000000000000110 || address == 0b00000000000000000111){
        digitalWrite(CS_8251, LOW); // UART
      }
      else if(address == 0b00000000000000001000 || address == 0b00000000000000001001){
        digitalWrite(CS_LCD, HIGH); // LCD
      }
    }
  }
}

uint32_t readAddress() {
  uint32_t addr = 0;
  for (int i = 0; i < 20; i++) {
    if (digitalRead(AD[i])) {
      addr |= (1UL << i);
    }
  }
  return addr;
}
