const int AD[]     = {22, 23, 24, 25, 26, 27, 28, 29, 30, 31, 32, 33, 34, 35, 36, 37, 38, 39, 40, 41}; // Address and data multiplexed signals
const int ALE      = 45; // ALE (Address Latch Enable) signal
const int RD       = 49; // Read signal inverted (/RD).
const int WR       = 51; // Write signal inverted (/WR).
const int MIO      = 46; // M/IO signal from the M/IO pin, it's 1 when accessing memory, 0 when accessing I/O
const int CS_8251  = 48; // i8251 (UART chip) chip select signal
const int CS_LCD   = 52; // LCD chip select signal
const int CS_8255  = 50; // i8255 (PPI) chip select signal
const int CS_8259  = 47; // i8259 (PIC) chip select signal
const int CS_RAM   = 42; // RAM chip select signals, this signal is connected to two physical ram chips
const int CS_ROM1  = 43; // ROM #1 chip select signal
const int CS_ROM2  = 44; // ROM #2 chip select signal
const int MMU_INT  = 53; // This is an interrupt triggered by an memory segmentation fault, see the docs for more info

uint32_t address; // Address read

String currentPhase = "Idle";

void setup()
{
  pinMode(ALE, INPUT);
  pinMode(RD, INPUT);
  pinMode(WR, INPUT);

  Serial.begin(2000000);
  Serial.println("8086 Bus cycle logger");
}

void loop()
{
  delayMicroseconds(1);
  bool ale = digitalRead(ALE);
  bool rd  = digitalRead(RD);
  bool wr  = digitalRead(WR);

  String phase;

  if (ale == HIGH)
    phase = "T1
  else if ((rd == LOW || wr == LOW) && ale == LOW)
    phase = "T2/T3";  // Could be either of those, indistinguishable without READY pin
  else if (rd == HIGH && wr == HIGH && ale == LOW)
    phase = "T4";
  else
    phase = "Idle";

  if (phase != currentPhase)
  {
    currentPhase = phase;
    Serial.print("Cycle phase: ");
    Serial.println(currentPhase);
  }
}
