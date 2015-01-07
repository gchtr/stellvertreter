import processing.mqtt.*;

MQTTClient client;

void setup() {
  frameRate(5);
  background(255);
  size(200, 200);
  client = new MQTTClient(this);
  client.connect("mqtt://2ba467a7534549c6:d955e5d5a02418a35b0fbb58eefb2844@connect.shiftr.io", "teet-alpha");
}

void draw() {
  
  int val = mouseX;
  
  if (mouseX > width/2) {
    val = 0;
  }
  
  client.publish("/input/front", String.valueOf(val));
}

void keyPressed() {
  exit();
}

/**
 * This function is required for the shiftr connection to work
 */
void messageReceived(String topic, byte[] payload) {
  //println("new message: " + topic + " - " + new String(payload));
}
