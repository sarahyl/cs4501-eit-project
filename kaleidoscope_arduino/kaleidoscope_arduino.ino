void setup() {
  Serial.begin(115200);
  //Wire.begin();          // Initiating I2C Communication
  //Wire.setClock(400000); // Setting up I2C Communication Speed

}

void loop() {

  if ( Serial.available() )   // When the IMU is ready to send data,
  {
    x = Serial.readString();  
    Serial.println(x);
    delay(10);           // Wait 10 milliseconds
  }
}