import processing.mqtt.*;

MQTTClient client;

String lines[];
long lastMillis = 0;
int interval = 100;
int i = -100;

void setup() {
  frameRate(10);
  size(200, 200);
  client = new MQTTClient(this);
  client.connect("mqtt://7dc71b64220f9034:60277088aaf9b5e71e1a5dfbeef76156@connect.shiftr.io", "playRecord");
  noLoop();

  selectFile();
}

void draw() {
  background(255);

  if (i >= 0 && i < lines.length) {
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

/**
 * Select new file on keypress
 */
void keyPressed() {

  // stop sending
  i = -100;

  // select new file
  selectFile();
}

void selectFile()
{
  selectInput("Select a file to process:", "processFile");
}

void processFile(File selectedFile)
{
  lines = loadStrings(selectedFile);
  i = 0;
  lastMillis = millis();
  loop();
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

