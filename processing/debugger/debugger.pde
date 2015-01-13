import processing.mqtt.*;

MQTTClient client;

int leftFront;
int leftBack;
int rightFront;
int rightBack;

int sensorThreshold = 950;

void setup() {
  frameRate(10);
  size(200, 200);
  client = new MQTTClient(this);
  client.connect("mqtt://7dc71b64220f9034:60277088aaf9b5e71e1a5dfbeef76156@connect.shiftr.io", "debugger");
}

void draw() {
  background(255);
  
  if (keyPressed) {
    switch(key) {
      case '1':
        leftFront = sensorThreshold;
        break;
      case '2':
        leftBack = sensorThreshold;
        break;
      case '3':
        rightFront = sensorThreshold;
        break;
      case '4':
        rightBack = sensorThreshold;
    }
  }
  
  
  String line = String.valueOf(leftFront) + "," + String.valueOf(leftBack) + "," + String.valueOf(rightFront) + "," + String.valueOf(rightBack) + ",";
  sendLine(line);
  
  leftFront = 0;
  leftBack = 0;
  rightFront = 0;
  rightBack = 0;
}

/**
 * Output line on keypress
 */
void keyPressed() {
  
  
}

void sendLine(String line)
{
  printLine(line);

  client.publish("/input", line);
}

void printLine(String line) {
  String[] values = split(line, ",");

  for (int j = 0; j < values.length; j++) {
    print(values[j] + "\t");
  }
  println();
}

void messageReceived(String topic, byte[] payload)
{
  //println("new message: " + topic + ": " + new String(payload));
}

