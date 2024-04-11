import processing.net.*; 
import java.nio.ByteBuffer; // Import ByteBuffer class

Server myServer;
int PORT = 5204;
float[] fingertipCoords = new float[2]; // Array to store fingertip coordinates

void setup() {
  size(640, 480); // Set canvas size to match webcam resolution
  
  // Start a server on port 5204
  myServer = new Server(this, PORT);
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
      fingertipCoords = decodeFloats(bytes, 2);
      // Draw fingertip coordinates
      drawFingertip(fingertipCoords[0], fingertipCoords[1]);
      
      // Mirror across the canvas like a kaleidoscope
      drawFingertip(width - fingertipCoords[0], fingertipCoords[1]); // Mirror horizontally
      drawFingertip(fingertipCoords[0], height - fingertipCoords[1]); // Mirror vertically
      drawFingertip(width - fingertipCoords[0], height - fingertipCoords[1]); // Mirror both horizontally and vertically
    }
    
    // Close the client connection
    // client.stop();
  }
  
  // Clear the canvas
  // background(255);
  
  // Draw fingertip coordinates
  // drawFingertip(fingertipCoords[0], fingertipCoords[1]);
  
  // Mirror across the canvas like a kaleidoscope
  // drawFingertip(width - fingertipCoords[0], fingertipCoords[1]); // Mirror horizontally
  // drawFingertip(fingertipCoords[0], height - fingertipCoords[1]); // Mirror vertically
  // drawFingertip(width - fingertipCoords[0], height - fingertipCoords[1]); // Mirror both horizontally and vertically
}

void drawFingertip(float x, float y) {
  // Draw a circle representing the fingertip
  fill(255, 0, 0);
  stroke(255,0,0);
  ellipse(x, y, 20, 20);
}

float[] decodeFloats(byte[] bytes, int floatLength) {
  // Create a ByteBuffer with the received bytes
  ByteBuffer buffer = ByteBuffer.wrap(bytes);
  // Initialize an array to store the float values
  float[] floatValues = new float[floatLength];
  // Read 4 float values from the buffer
  for (int i = 0; i < floatLength; i++) {
    floatValues[i] = buffer.getFloat();
  }
  return floatValues;
}