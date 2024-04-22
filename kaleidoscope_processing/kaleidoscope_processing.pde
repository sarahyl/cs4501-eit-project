import processing.net.*;
import processing.serial.*;
import java.nio.ByteBuffer;

Serial myPort1; // For COM15
Serial myPort2; // For COM3
String myString1 = null;
String myString2 = null;
int lf = 10;    // Linefeed in ASCII
float dx = 0;
float dy = 0;
float dz = 0;
float force = 0;

FloatList xPosList;
FloatList yPosList;
FloatList forceList;

int clearValue = 0;
Server myServer;
int PORT = 5204;
float[] previousCoords = new float[2]; // Previous fingertip coordinates
float[] fingertipCoords = new float[2]; // Current fingertip coordinates

void setup() {
  background(255);
  size(640, 480); // Set canvas size to match webcam resolution
  
  // Start a server on port 5204
  myServer = new Server(this, PORT);
  
  //Arduino
  println(Serial.list());  // prints serial port list
  String[] portList = Serial.list();
  
  // Initialize Serial objects for COM15 and COM3
  for (int i = 0; i < portList.length; i++) {
    if (portList[i].equals("COM15")) {
      myPort1 = new Serial(this, portList[i], 115200);
    }
    if (portList[i].equals("COM3")) {
      myPort2 = new Serial(this, portList[i], 115200);
    }
  }
  
  xPosList = new FloatList();  
  yPosList = new FloatList();
  forceList = new FloatList();
}

void draw() {
   //Read data from COM15 (Arduino connected to COM15)
  while (myPort1 != null && myPort1.available() > 0) {
    myString1 = myPort1.readStringUntil(lf);
    if (myString1 != null) {
      float[] nums = float(split(myString1, ','));
      if (nums.length == 1) {
        force = nums[0];
        println("Force value from COM15: " + force);
        
        if(force > 500) {
          background(255);
        }
      }
    }
  }

  // Read data from COM3 (Arduino connected to COM3)
  while (myPort2 != null && myPort2.available() > 0) {
    myString2 = myPort2.readStringUntil(lf);
    if (myString2 != null) {
      float[] nums = float(split(myString2, ','));
      if (nums.length == 3) {
        dx = nums[0];
        dy = nums[1];
        dz = nums[2];
        //force = nums[2];
        println("dx: " + dx + ", dy: " + dy + ", dz: " + dz);
        
      }
    }
  }
  
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
      
      // Draw line from previous position to current position
      
      // Mirror across the canvas like a kaleidoscope
      drawLine(width - previousCoords[0], previousCoords[1], width - fingertipCoords[0], fingertipCoords[1]); // Mirror horizontally
      drawLine(previousCoords[0], height - previousCoords[1], fingertipCoords[0], height - fingertipCoords[1]); // Mirror vertically
      drawLine(width - previousCoords[0], height - previousCoords[1], width - fingertipCoords[0], height - fingertipCoords[1]); // Mirror both horizontally and vertically
    }
  }
}

void drawLine(float x1, float y1, float x2, float y2) {
  // Set a thicker stroke weight
  strokeWeight(4); // Set thickness of the line
  // Draw a line from (x1, y1) to (x2, y2)
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
