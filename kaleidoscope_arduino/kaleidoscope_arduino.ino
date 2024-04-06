void setup() {
  Serial.begin(115200);
  //Wire.begin();          // Initiating I2C Communication
  //Wire.setClock(400000); // Setting up I2C Communication Speed

}

void loop() {
   while (!Serial.available()); // check until there is data available
    String x = Serial.readString();  
    Serial.println(x);
    delay(10);    
}