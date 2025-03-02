#define ADDRESS_BITS 20 // 20-bit wide address bus (A0-A19)

// GPIO pins connected to the address bus
const int address_pins[ADDRESS_BITS] = {
	0, 1, 2, 3, 4, 5, 6, 7, 8, 9,
	10, 11, 12, 13, 14, 15, 16, 17, 18, 19};

void setup()
{
	Serial.begin(9600);

	// Set every GPIO address pin as input
	for (int i = 0; i < ADDRESS_BITS; i++)
	{
		pinMode(address_pins[i], INPUT);
	}
}

void loop()
{
	uint32_t address = 0; // Stores one address

	// Read address from address pin
	for (int i = 0; i < ADDRESS_BITS; i++)
	{
		int bit_value = digitalRead(address_pins[i]); // Read one bit
		address |= (bit_value << i);				  // Combine with already read bits
	}

	// Print address in hexadecimal forma to serial port
	Serial.print("Address: 0x");
	Serial.println(address, HEX);

	delay(100); // Wait 100 ms before next reading
}
