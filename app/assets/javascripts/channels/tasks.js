function fayeSubscribe(senderChannel) {
  // Global
  url = 'http://' + document.location.host + '/faye';
  client = new Faye.Client(url);
  console.log("Became server client."); // TODO For testing purpose only

  subscription = client.subscribe(senderChannel, function(message) {
    console.log(message.text);
    if (message.text) {
      addReceivedMessageText(message.text);
    }
  });

  console.log("Subscribed to channel " + senderChannel +"."); // TODO For testing purpose only
}

function addReceivedMessageText(messageText) {
  addMessageText(messageText, "received-notification");
}

function addMessageText(messageText, className) {
  var div = document.createElement('div');
  div.className = className;
  div.innerHTML = messageText;
  nc = document.getElementById('notifications-container');
  nc.style.display = "block";
  nc.appendChild(div);
}
