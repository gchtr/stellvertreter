// ws://7dc71b64220f9034:60277088aaf9b5e71e1a5dfbeef76156@connect.shiftr.io:1884/

var uri = URI('ws://7dc71b64220f9034:60277088aaf9b5e71e1a5dfbeef76156@connect.shiftr.io:1884/');

var client = new Paho.MQTT.Client('ws://' + uri.host() + '/', 'webPlayer');

client.onConnectionLost = function(res) {
  if (res.errorCode !== 0) {
    console.log('connection has been lost');
  }
  console.log(res);
};

client.onMessageArrived = function(message) {
  var msg = message.payloadString;
  //console.log('new message: ', message.payloadString);

  printData(msg);
};

client.connect({
  userName: uri.username(),
  password: uri.password(),
  onSuccess: function() {
    client.subscribe("/input");
  },
  onFailure: function(failure) {
    console.log(failure);
    console.log('not connected');
  }
});
