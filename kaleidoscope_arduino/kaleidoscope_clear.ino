const int forceSensorPin = A0;  // Analog input pin for force sensor

void setup() {
    Serial.begin(9600);           // Initialize serial communication
}

void loop() {
    int sensorValue = analogRead(forceSensorPin);  // Read sensor value
    Serial.println(sensorValue);                   // Print sensor value to serial monitor
    Serial.write(sensorValue);                     // Send sensor value to host
    
    // if (sensorValue > 500) {
    //     Serial.println("Force sensor value is over 500: ", sensorValue);
    //     Serial.write(1);
    // } else {
    //     Serial.write(0);
    // }

    delay(30);  // Delay for stability
}
