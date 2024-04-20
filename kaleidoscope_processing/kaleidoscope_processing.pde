import processing.net.*;
import java.nio.ByteBuffer;

Server myServer;
int PORT = 5204;
float[] previousCoords = new float[2]; // Previous fingertip coordinates
float[] fingertipCoords = new float[2]; // Current fingertip coordinates

import processing.serial.*;
Serial myPort;
String myString = null;
int lf = 10;    // Linefeed in ASCII
float ax = 0;
float ay = 0;
float az=0;
float dx = 0;
float dy = 0;
float dz=0;
float force = 0;
float color1;
float color2;
float color3;
void setup() {
  size(640, 480); // Set canvas size to match webcam resolution
  
  // Start a server on port 5204
  myServer = new Server(this, PORT);
  String portName = Serial.list()[1];  // find the right one from the print port list (see the console output). Your port might not be the first one on the list. 
  myPort = new Serial(this, portName, 115200);  // open the serial port  

}

void draw() {
  // Check if a client is available
  Client client = myServer.available();
  if (client != null) {
    // Read data from the client
    while (client.available() >= 8) { // Assuming 16 bytes for 2 float values (1 float = 4 bytes)
      // Read the received bytes
      byte[] bytes = new byte[8];
      client.readBytes(bytes);
      
      // Decode the bytes to float values
      previousCoords[0] = fingertipCoords[0]; // Save previous x-coordinate
      previousCoords[1] = fingertipCoords[1]; // Save previous y-coordinate
      fingertipCoords = decodeFloats(bytes, 2);
      println(fingertipCoords);
      // Draw line from previous position to current position
      drawLine(previousCoords[0], previousCoords[1], fingertipCoords[0], fingertipCoords[1]);
      
      // Mirror across the canvas like a kaleidoscope
      drawLine(width - previousCoords[0], previousCoords[1], width - fingertipCoords[0], fingertipCoords[1]); // Mirror horizontally
      drawLine(previousCoords[0], height - previousCoords[1], fingertipCoords[0], height - fingertipCoords[1]); // Mirror vertically
      drawLine(width - previousCoords[0], height - previousCoords[1], width - fingertipCoords[0], height - fingertipCoords[1]); // Mirror both horizontally and vertically

    }
  }
}

void drawLine(float x1, float y1, float x2, float y2) {

  while (myPort.available() > 0) {
      myString = myPort.readStringUntil(lf);
      if (myString != null) {
        float[] nums = float(split(myString, ','));
        if (nums.length == 4)
        {
          dx = nums[0];
          dy = nums[1];
          dz = nums[2];
          force=nums[3];
          //println("dx:",dx);
          println("dy:",dy);
          //println("dz:",dz);
        }
      }
  }
  dx=constrain(dx,-500,500);
  dy=constrain(dy,-500,500);
  dz=constrain(dz,-500,500);
  
  color1=map(dy,-500,500,255,0);
  color2=map(dy,-500,500,0,255);
  color3=map(dy,-500,500,0,255);
  // Set a thicker stroke weight
  strokeWeight(4); // Set thickness of the line
  // Draw a line from (x1, y1) to (x2, y2)
  stroke(color1, color2, color3); // Set line color
  line(x1, y1, x2, y2); // Draw line  
}

float[] decodeFloats(byte[] bytes, int floatLength) {
  // Create a ByteBuffer with the received bytes
  ByteBuffer buffer = ByteBuffer.wrap(bytes);
  // Initialize an array to store the float values
  float[] floatValues = new float[floatLength];
  // Read float values from the buffer
  for (int i = 0; i < floatLength; i++) {
    floatValues[i] = buffer.getFloat();
  }
  return floatValues;
}
