import processing.net.*; 
import java.nio.ByteBuffer; // Import ByteBuffer class

Server myServer;
int PORT = 5204;

void setup() {
  size(200, 200);
  
  // Start a server on port 5204
  myServer = new Server(this, PORT);
}

void draw() {
  // Check if a client is available
  Client client = myServer.available();
  if (client != null) {
    // Read data from the client
    while (client.available() >= 8) { // Assuming 16 bytes for 4 float values (1 float = 4 bytes), YOU NEED TO CHANGE THIS AND OTHER VARIABLES IN THIS SECTION BASED ON THE DATA YOU ARE SENDING FROM PYTHON
      // Read the received bytes
      byte[] bytes = new byte[8];
      client.readBytes(bytes);
      
      // Decode the bytes to float values
      float[] floatValues = decodeFloats(bytes, 2);
      
      // Print received float values
      print("Received float values: ");
      for (float value : floatValues) {
        print(value + " ");
      }
      println();
    }
    
    // Close the client connection
    // This code is commented out, but you can uncomment it based on some logic to close the python program if needed
    //client.stop();
  }
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
