#include <Bridge.h>
#include <YunClient.h>
#include <MQTTClient.h>

#define PIN_PUMP_LEFT_FRONT 5
#define PIN_PUMP_LEFT_BACK 6
#define PIN_PUMP_RIGHT_FRONT 10
#define PIN_PUMP_RIGHT_BACK 11

int leftFront = 0;
int leftBack = 0;
int rightFront = 0;
int rightBack = 0;

YunClient net;
MQTTClient client("connect.shiftr.io", 1883, net);

void setup()
{
  Bridge.begin();
  Serial.begin(9600);
  
  pinMode(PIN_PUMP_LEFT_FRONT, OUTPUT);
  pinMode(PIN_PUMP_LEFT_BACK, OUTPUT);
  pinMode(PIN_PUMP_RIGHT_FRONT, OUTPUT);
  pinMode(PIN_PUMP_RIGHT_BACK, OUTPUT);
  
  Serial.println("connecting...");
  if (client.connect("teet-alpha-outputDoubleFoot", "2ba467a7534549c6", "d955e5d5a02418a35b0fbb58eefb2844")) {
    Serial.println("connected!");
  }
  else {
    Serial.println("not connected!");
  }
  
  client.subscribe("/input");
}

void loop()
{
  client.loop();
  
  if (leftFront > 900) {
    digitalWrite(PIN_PUMP_LEFT_FRONT, HIGH);
  }
  else {
    digitalWrite(PIN_PUMP_LEFT_FRONT, LOW);
  }
  
  if (leftBack > 900) {
    digitalWrite(PIN_PUMP_LEFT_BACK, HIGH);
  }
  else {
    digitalWrite(PIN_PUMP_LEFT_BACK, LOW);
  }
  
  if (rightFront > 900) {
    digitalWrite(PIN_PUMP_RIGHT_FRONT, HIGH);
  }
  else {
    digitalWrite(PIN_PUMP_RIGHT_FRONT, LOW);
  }
  
  if (rightBack > 900) {
    digitalWrite(PIN_PUMP_RIGHT_BACK, HIGH);
  }
  else {
    digitalWrite(PIN_PUMP_RIGHT_BACK, LOW);
  }
  
}

void messageReceived(String topic, char * payload, unsigned int length)
{
  char * a = strtok(payload, ",");
  char * b = strtok(NULL, ",");
  char * c = strtok(NULL, ",");
  char * d = strtok(NULL, ",");
  
  leftFront = atoi(a);
  leftBack = atoi(b);
  rightFront = atoi(c);
  rightBack = atoi(d);
  
  // manually set back payload
  memset(payload, 0, 0);
  
  //Serial.println(String(leftFront) + "," + String(leftBack) + "," + String(rightFront) + "," + String(rightBack));
}
