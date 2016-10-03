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
  addMessageText(messageText, "received-notification alert alert-info");
}

function addMessageText(messageText, className) {
  var div = document.createElement('div');
  div.className = className;
  div.innerHTML = messageText;
  nc = document.getElementById('notifications-container');
  nc.style.display = "block";
  nc.appendChild(div);
}
// ----------------------------------------------------------------------------------------------- //

var getNextIndex = (function() {
  var index = 0;
  return function() {return index++; };
})();

var counter = {
  value: 0,

  increment: function() {
    this.value++;
  },

  decrement: function() {
    this.value--;
  }
}

// ----------------------------------------------------------------------------------------------- //

function addSharedEmailContainer(node) {
  if (counter.value > 4) {
    addReceivedMessageText("You can share a task only with 5 emails at once");
  } else {
    var name   = 'emails[' + getNextIndex() + ']';
        counter.increment();
    var input  = createInput("form-control", "text", name);
    var span   = createSpan("glyphicon glyphicon-minus");
    var button = createButton("btn btn-primary", removeDiv);
    var div    = createDiv("shared-email-container");

    button.appendChild(span);
    div.appendChild(input);
    div.appendChild(button);

    node.parentNode.appendChild(div);
  }
}

function createButton(className, onClick) {
  var button = document.createElement("button");
      button.className = className;
      button.onclick = function() { onClick(button); };
  return button;
}

function createSpan(className) {
  var span = document.createElement("span");
      span.className = className;
  return span;
}

function createInput(className, type, name) {
  var input = document.createElement("input");
      input.className = className;
      input.type = type;
      input.name = name;
  return input;
}

function createDiv(className) {
  var div = document.createElement("div");
      div.className = className;
  return div;
}

function removeDiv(node) {
  counter.decrement();
  node.parentNode.parentNode.removeChild(node.parentNode);
}

// ----------------------------------------------------------------------------------------------- //
