import processing.serial.*;
Serial myPort;
String myString = null;
int lf = 10;    // Linefeed in ASCII
//float ax = 0;
//float ay = 0;
float dx = 0;
float dy = 0;
//float force = 0;
float xPos = 0;
float yPos = 0;

FloatList xPosList;
FloatList yPosList;
//FloatList forceList;


void setup() {
  size(1000, 700);
  println(Serial.list());  // prints serial port list
  String portName = Serial.list()[0];  // find the right one from the print port list (see the console output). Your port might not be the first one on the list. 
  myPort = new Serial(this, portName, 115200);  // open the serial port  

  // Lists storing x/y positions and force 
  xPosList = new FloatList();  
  yPosList = new FloatList();
  //forceList = new FloatList();

  // Initiate x/y cursor positions
  xPos = width/2;
  yPos = height/2;
}

void draw() {
  background(255);
  stroke(0);

  float gain = 5;  // TODO: Set Movement Gain that looks good to you. 
  while (myPort.available() > 0) {
    myString = myPort.readStringUntil(lf);
    if (myString != null) {
      float[] nums = float(split(myString, ','));
      print(nums);
      //if (nums.length == 3)
      //{
      //  dx = nums[0] / 1023.0;
      //  dy = -nums[1] / 1023.0;
      //  force = nums[2];
      //}
    }
  }   

  xPos = xPos + dx * gain;
  yPos = yPos + dy * gain;  

  xPosList.append(xPos);
  yPosList.append(yPos);  
  //forceList.append(force/10);       // TODO: Change this to use values in forceList to be used as diameter

  fill(0); // Sets the fill color
  for (int i = 0; i < xPosList.size(); i++)
  {
    ellipse(xPosList.get(i), yPosList.get(i), 220, 220);    // Draw points in the list
  }  
  fill(255, 255, 0, 100);
  ellipse(xPos, yPos, 30, 30);    // Draw a cursor
}

void keyPressed() {
  xPosList.clear();
  yPosList.clear();
  //forceList.clear();
  xPos = width/2;
  yPos = height/2;
}
