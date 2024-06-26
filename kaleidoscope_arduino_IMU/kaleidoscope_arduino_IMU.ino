#include "ICM_20948.h"
ICM_20948_I2C myICM;

void setup() {
 Serial.begin(115200);
 Wire.begin();
 Wire.setClock(400000);
 myICM.begin(Wire, 1);
}

void loop() {
    // Getting IMU data
 if ( myICM.dataReady() ) {
   myICM.getAGMT();
   float ax = myICM.accX();
   float ay = myICM.accY();
   float az = myICM.accZ();

   Serial.print(ax, 1);
   Serial.print(", ");
   Serial.print(ay, 1);
   Serial.print(", ");
   Serial.print(az, 1);
   Serial.println();
 }
 delay(20);
}