import processing.mqtt.*;

MQTTClient client;

String lines[];
long lastMillis = 0;
int interval = 100;
boolean sending = false;

void setup() {
  frameRate(10);
  size(200, 200);
  client = new MQTTClient(this);
  client.connect("mqtt://2ba467a7534549c6:d955e5d5a02418a35b0fbb58eefb2844@connect.shiftr.io", "teet-alpha-playRecord");

  selectInput("Select a file to process:", "processFile");
}

void draw() {
  background(255);
}

/**
 * Select new file on keypress
 */
void keyPressed() {
  sending = false;
  selectInput("Select a file to process:", "processFile");
}

void processFile(File selectedFile) {
  lines = loadStrings(selectedFile); 
  sending = true; 
  readLines();
}

void readLines() {
  
  int i = 0;
  lastMillis = millis();
  
  while (i < lines.length && sending) {
    String line = String.valueOf(lines[i]);
    
    // add trailing delimiter
    if (!line.endsWith(",")) {
      line += ","; 
    }
    
    // send a line in intervals
    if (millis() - lastMillis > interval) {
      sendLine(line);
      
      lastMillis = millis();
      i++;
    }
  }
}

void sendLine(String line)
{
  println(line);
  client.publish("/input", line);
}

void messageReceived(String topic, byte[] payload)
{
  //println("new message: " + topic + ": " + new String(payload));
}

