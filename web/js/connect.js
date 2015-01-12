// ws://7dc71b64220f9034:60277088aaf9b5e71e1a5dfbeef76156@connect.shiftr.io:1884/

var uri = URI('ws://7dc71b64220f9034:60277088aaf9b5e71e1a5dfbeef76156@connect.shiftr.io:1884/');

var client = new Paho.MQTT.Client('ws://' + uri.host() + '/', 'webPlayer');

client.onConnectionLost = function(res) {
  if(res.errorCode !== 0) {
    console.log('connection has been lost');
  }
};

client.onMessageArrived = function(message) {
  console.log('new message: ', message.payloadString);
};

client.connect({
  userName: uri.username(),
  password: uri.password(),
  onSuccess: function() {
    client.subscribe("/input");
    message = new Paho.MQTT.Message('Hello world!');
    message.destinationName = "/input";
    client.send(message);
  },
  onFailure: function(lala) {
    console.log(lala);
    console.log('not connected');
  }
});
