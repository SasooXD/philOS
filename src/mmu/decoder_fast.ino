//! doesn't work :P

// ALE and M/IO pins
const uint8_t ALE = 45;
const uint8_t MIO = 46;

// /RD /WR pins, not actually used here
const uint8_t RD = 49;
const uint8_t WR = 51;

// Chip select bitmask (based on Arduino Mega pinout)
#define CS_8251_BIT  _BV(0)  // Pin 48, PORTH0
#define CS_8255_BIT  _BV(3)  // Pin 50, PORTH3
#define CS_8259_BIT  _BV(1)  // Pin 47, PORTH1
#define CS_LCD_BIT   _BV(1)  // Pin 52, PORTB1
#define CS_RAM_BIT   _BV(7)  // Pin 42, PORTL7
#define CS_ROM1_BIT  _BV(6)  // Pin 43, PORTL6
#define CS_ROM2_BIT  _BV(5)  // Pin 44, PORTL5

void setup()
{
    // Set AD0–AD7 on PORTA, AD8–AD15 on PORTC and AD16–AD19 on PORTK as input
    DDRA = 0x00;
    DDRC = 0x00;
    DDRK = 0x00;

	DDRL &= ~(_BV(4)); // ALE input (PL4)
	DDRL &= ~(_BV(3)); // MIO input (PL3)

    // Configure CS pins as output
    DDRH |= CS_8251_BIT | CS_8255_BIT | CS_8259_BIT;
    DDRB |= CS_LCD_BIT;
    DDRL |= CS_RAM_BIT | CS_ROM1_BIT | CS_ROM2_BIT;

    // Deactive all CS pins at start
    PORTH |= CS_8251_BIT | CS_8255_BIT | CS_8259_BIT;
    PORTB |= CS_LCD_BIT;
    PORTL |= CS_RAM_BIT | CS_ROM1_BIT | CS_ROM2_BIT;
}

void loop()
{
    uint32_t address;

    // Wait for ALE (Pin 45 -> PL4)
    while (!(PINL & _BV(4)));
    while (PINL & _BV(4));  // Wait for ALE to drop low

    // Latch and compute full address (20 bit)
    uint8_t ad_low  = PINA; // AD0–AD7
    uint8_t ad_mid  = PINC; // AD8–AD15
    uint8_t ad_high = PINK & 0x0F; // AD16–AD19
    address = ((uint32_t)ad_high << 16) | (ad_mid << 8) | ad_low;

    // Deactive every CS
    PORTH |= CS_8251_BIT | CS_8255_BIT | CS_8259_BIT;
    PORTB |= CS_LCD_BIT;
    PORTL |= CS_RAM_BIT | CS_ROM1_BIT | CS_ROM2_BIT;

    // Decode access
    if (PINL & _BV(3))  // Memory access
    {
        if (address < 0x00400UL || // IDT (ROM #1)
        (address >= 0xF0400UL && address <= 0xFFFEFUL)) // ISR, BIOS, bootloader (ROM #1)
        {
            PORTL &= ~CS_ROM1_BIT;
        }
        else if (address >= 0x00400UL && address <= 0x103FFUL)  // OS (ROM #2)
        {
            PORTL &= ~CS_ROM2_BIT;
        }
        else //if (address >= 0x10400UL && address <= 0x183FFUL) // RAM
        {
            PORTL &= ~CS_RAM_BIT;
        }
    }
    else // IO access
    {
        switch (address & 0xFFFFF)
        {
            case 0x00000: case 0x00001: case 0x00002: case 0x00003: // 8255
                PORTH &= ~CS_8255_BIT;
                break;
            case 0x00004: case 0x00005: // 8259
                PORTH &= ~CS_8259_BIT;
                break;
            case 0x00006: case 0x00007: //8251
                PORTH &= ~CS_8251_BIT;
                break;
            case 0x00008: case 0x00009: //LCD
                PORTB &= ~CS_LCD_BIT;
                break;
        }
    }
