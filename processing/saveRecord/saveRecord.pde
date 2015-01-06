import processing.mqtt.*;

MQTTClient client;
PrintWriter output;

void setup() {
  frameRate(10);
  background(255);
  size(200, 200);
  client = new MQTTClient(this);
  client.connect("mqtt://2ba467a7534549c6:d955e5d5a02418a35b0fbb58eefb2844@connect.shiftr.io", "teet-alpha");
  
  client.subscribe("/input/+");
  output = createWriter("output/mousePos.txt");
}

void draw() {
  // nothing to do here
}

// save output on keypress
void keyPressed() {
  output.flush();
  output.close();
  exit();
}

void messageReceived(String topic, byte[] payload) {
  //println("new message: " + topic + " - " + new String(payload));
  output.println(new String(payload));
}
