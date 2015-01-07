import processing.mqtt.*;

MQTTClient client;
PrintWriter output;
String receivedMessage = "0";

void setup() {
  frameRate(10);
  size(200, 200);
  client = new MQTTClient(this);
  client.connect("mqtt://2ba467a7534549c6:d955e5d5a02418a35b0fbb58eefb2844@connect.shiftr.io", "teet-alpha");

  selectOutput("Select a file to write to:", "saveToFile");
}

void draw() {
  background(255);

  // the received values are displayed in the sketch window
  textAlign(CENTER);
  textSize(16);
  fill(0);
  text(receivedMessage, width/2, height/2);
}

/**
 * Save output on keypress
 */
void keyPressed() {
  output.flush();
  output.close();
  exit();
}

void saveToFile(File selectedFile) {
  output = createWriter(selectedFile);
  client.subscribe("/input");
}

void messageReceived(String topic, byte[] payload) {
  //println("new message: " + topic + ": " + new String(payload));

  if (topic.equals("/input")) {
    receivedMessage = new String(payload);
    output.println(new String(payload));
  }
  
  //receivedMessage = new String(payload);
  //output.println(new String(payload));
}

