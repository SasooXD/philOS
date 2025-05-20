const int AD[]     = {22, 23, 24, 25, 26, 27, 28, 29, 30, 31, 32, 33, 34, 35, 36, 37, 38, 39, 40, 41}; // Address and data multiplexed signals
const int ALE      = 46;
const int RD       = 47;
const int WR       = 48;
const int MIO      = 49;
const int BHE      = 50;
int AA0             = 1;
int AA18            = 1;

const int CS_ROM1  = 42; // ROM #1 chip select signal
const int CS_ROM2  = 43; // ROM #2 chip select signal
const int CS_RAM1  = 44; // RAM #1 chip select signal
const int CS_RAM2  = 45; // RAM #2 chip select signal
const int CS_LCD  =  53; // LCD chip select signal

void setup() {
	pinMode(CS_ROM1, OUTPUT);
 	pinMode(CS_ROM2, OUTPUT);
 	pinMode(CS_RAM1, OUTPUT);
 	pinMode(CS_RAM2, OUTPUT);
 	pinMode(CS_LCD, OUTPUT);

 	pinMode(ALE, INPUT);
 	pinMode(RD, INPUT);
 	pinMode(WR, INPUT);
 	pinMode(MIO, INPUT);

for (int i = 0; i < 20; i++) {
	pinMode(AD[i], INPUT);
}

	digitalWrite(CS_ROM1, HIGH);
	digitalWrite(CS_ROM2, HIGH);
 	digitalWrite(CS_RAM1, HIGH);
 	digitalWrite(CS_RAM2, HIGH);
 	digitalWrite(CS_LCD, LOW);
}

int aus = 0;

void loop()
{
  if(digitalRead(ALE) == HIGH){
    if(digitalRead(AD[0]) == LOW){
      AA0 = 0;
    }else{
      AA0 = 1;
    }
    if(digitalRead(AD[18]) == LOW){
      AA18 = 0;
    }else{
      AA18 = 1;
    }
  }

  //rom bassa
  if(digitalRead(ALE) == LOW and digitalRead(RD) == LOW and digitalRead(WR) == HIGH and digitalRead(MIO) == HIGH and AA0 == 0 and AA18 == 1){
    digitalWrite(CS_ROM1, LOW);
    Serial.println("ROM1 accesa11111");
  }else{
    digitalWrite(CS_ROM1, HIGH);
  }

  //rom alta
  if(digitalRead(ALE) == LOW and digitalRead(RD) == LOW and digitalRead(WR) == HIGH and digitalRead(BHE) == LOW and AA18 == 1 and digitalRead(MIO) == HIGH){
    digitalWrite(CS_ROM2, LOW);
    Serial.println("ROM2 accesa2222");
  }else{
    digitalWrite(CS_ROM2, HIGH);
  }

 //ram bassa
  if(digitalRead(ALE) == LOW and digitalRead(RD) !=digitalRead(WR) and digitalRead(MIO) == HIGH and AA0 == 0 and AA18 == 0){
    digitalWrite(CS_RAM1, LOW);
  }else{
    digitalWrite(CS_RAM1, HIGH);
  }

  //ram alta
  if(digitalRead(ALE) == LOW and digitalRead(RD) != digitalRead(WR) and digitalRead(BHE) == LOW and AA18 == 0 and digitalRead(MIO) == HIGH){
    digitalWrite(CS_RAM2, LOW);
  }else{
    digitalWrite(CS_RAM2, HIGH);
  }

//lcd
if(digitalRead(ALE) == LOW and digitalRead(RD) != digitalRead(WR) and digitalRead(MIO) == LOW){
    digitalWrite(CS_LCD, HIGH);
  }else{
    digitalWrite(CS_LCD, LOW);
  }
}
