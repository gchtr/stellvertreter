#include <Bridge.h>
#include <YunClient.h>
#include <MQTTClient.h>

#define PRESSURE_LEFT_FRONT A0
#define PRESSURE_LEFT_BACK A1
#define PRESSURE_RIGHT_FRONT A2
#define PRESSURE_RIGHT_BACK A3

int pressureLeftFront = 0;
int pressureLeftBack = 0;
int pressureRightFront = 0;
int pressureRightBack = 0;

unsigned long lastMillis = 0;

void callback(char* topic, byte* payload, unsigned int length) {
  Serial.print("incoming: ");
  Serial.write(payload, length);
  Serial.println();
}

YunClient net;
MQTTClient client("connect.shiftr.io", 1883, net);

void setup()
{
  Bridge.begin();
  Serial.begin(9600);

  pinMode(PRESSURE_LEFT_FRONT, INPUT);
  pinMode(PRESSURE_LEFT_BACK, INPUT);
  pinMode(PRESSURE_RIGHT_FRONT, INPUT);
  pinMode(PRESSURE_RIGHT_BACK, INPUT);
  
  Serial.println("connecting...");
  if (client.connect("teet-alpha-inputDoubleFoot", "2ba467a7534549c6", "d955e5d5a02418a35b0fbb58eefb2844")) {
   Serial.println("connected!");
 } else {
   Serial.println("not connected!");
 }
}

void loop()
{
  client.loop();
  
  pressureLeftFront = analogRead(PRESSURE_LEFT_FRONT);
  pressureLeftBack = analogRead(PRESSURE_LEFT_BACK);
  pressureRightFront = analogRead(PRESSURE_RIGHT_FRONT);
  pressureRightBack = analogRead(PRESSURE_RIGHT_BACK);
  
  Serial.println(String(pressureLeftFront) + "," + String(pressureLeftBack));
  
  if (millis() - lastMillis > 100) {
    lastMillis = millis();
    sendData();
  }
}

void sendData()
{
  String stringToSend = String(pressureLeftFront) + "," + String(pressureLeftBack) + "," + String(pressureRightFront) + "," + String(pressureRightBack) + ",";  
  client.publish("/input", stringToSend);
}
