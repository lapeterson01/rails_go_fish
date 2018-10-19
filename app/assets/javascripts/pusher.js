// .gitignor in production
Pusher.logToConsole = true;

var pusher = new Pusher('2fb86689f70af2fa9b6a', {
  cluster: 'us2',
  forceTLS: true
});

pusher.connection.bind('connected', function() {
  var xhr = new XMLHttpRequest();
  xhr.open("POST", '/set-socket-id', true);
  xhr.setRequestHeader('Content-Type', 'application/json');
  xhr.send(JSON.stringify({
    socket_id: pusher.connection.socket_id
  }));
});

var channel = pusher.subscribe('go-fish');
channel.bind("refresh", function(data) {
  if(window.location.pathname == '/games' || window.location.pathname == `/games/${data.id}`) {
    window.location.reload();
  };
});
channel.bind("game-refresh", function(data) {
  if(window.location.pathname == `/games/${data.id}`) {
    window.location.reload();
  }
})