#include "ICM_20948.h"
ICM_20948_I2C myICM;

void setup() {
 Serial.begin(115200);
 Wire.begin();
 Wire.setClock(400000);
 myICM.begin(Wire, 1);
}

void loop() {

  int force = analogRead(0);
  Serial.print(force);
   Serial.println();
   delay(20);

}
