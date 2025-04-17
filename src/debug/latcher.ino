#include <Arduino.h>

const int inputPins[16] = {22, 23, 24, 25, 26, 27, 28, 29, 30, 31, 32, 33, 34, 35, 36, 37};
const int outputPins[16] = {38, 39, 40, 41, 42, 43, 44, 45, 46, 47, 48, 49, 50, 51, 52, 53};
const int ALE = 2;
const int RD = 3;
const int M = 4;
const int ROM = 5

const int buttonPin = 12; // Pulsante con debouncing
const int ledPin = 13; // LED associato al pulsante con debouncing

// Variables will change:
int ledState = HIGH;        // the current state of the output pin
int buttonState;            // the current reading from the input pin
int lastButtonState = LOW;  // the previous reading from the input pin

unsigned long lastDebounceTime = 0;
const unsigned long debounceDelay = 50;

void setup() {
	Serial.begin(9600); // Inizializza la comunicazione seriale

	// Imposta i pin di input
	for (int i = 0; i < 16; i++) {
		pinMode(inputPins[i], INPUT);
	}

	// Imposta i pin di output
	for (int i = 0; i < 16; i++) {
		pinMode(outputPins[i], OUTPUT);
		digitalWrite(outputPins[i], LOW);
	}

	// Imposta il pin del pulsante
	pinMode(buttonPin, INPUT_PULLUP);

	// Imposta i pin per il debouncing
	pinMode(buttonPin, INPUT);
	pinMode(ledPin, OUTPUT);

	//pin memoria
	pinMode(ALE, INPUT);
	pinMode(M, INPUT);
	pinMode(RD, INPUT);
	pinMode(ROM, OUTPUT);
	digitalWrite(ROM, HIGH);
}

void loop() {
	// Gestione pulsante principale
	if (digitalRead(ALE) == HIGH) {  // Se il pulsante è premuto
		for (int i = 0; i < 16; i++) {
			int value = digitalRead(inputPins[i]);
			digitalWrite(outputPins[i], value);
		}
	}else{
		if (digitalRead(RD) == LOW and digitalRead(M) == HIGH) {
			digitalWrite(ROM, LOW);
		} else {
			digitalWrite(ROM, HIGH);
		}
	}

	// read the state of the switch into a local variable:
	int reading = digitalRead(buttonPin);

	// check to see if you just pressed the button
	// (i.e. the input went from LOW to HIGH), and you've waited long enough
	// since the last press to ignore any noise:

	// If the switch changed, due to noise or pressing:
	if (reading != lastButtonState) {
		// reset the debouncing timer
		lastDebounceTime = millis();
	}

	if ((millis() - lastDebounceTime) > debounceDelay) {
	// whatever the reading is at, it's been there for longer than the debounce
	// delay, so take it as the actual current state:

		// if the button state has changed:
		if (reading != buttonState) {
				buttonState = reading;
			// only toggle the LED if the new button state is HIGH
			if (buttonState == HIGH) {
				ledState = !ledState;
			}
		}
	}

	// set the LED:
	digitalWrite(ledPin, ledState);

	// save the reading. Next time through the loop, it'll be the lastButtonState:
	lastButtonState = reading;
}
