var client = new Paho.MQTT.Client('ws://connect.shiftr.io/javascript?auth=2ba467a7534549c6:d955e5d5a02418a35b0fbb58eefb2844', 'javascript');

client.onConnectionLost = function(res) {
  if(res.errorCode !== 0) {
    console.log('connection has been lost');
  }
};

client.onMessageArrived = function(message) {
  console.log('new message: ', message.payloadString);
};

client.connect({
  onSuccess: function() {
    client.subscribe("/input");
    message = new Paho.MQTT.Message('Hello world!');
    message.destinationName = "/input";
    console.log(message);
    client.send(message);
  },
  onFailure: function(lala) {
    console.log(lala);
    console.log('not connected');
  }
});
