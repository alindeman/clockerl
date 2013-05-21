$(function() {
  var socket = new WebSocket('ws://localhost:8080/websocket')

  socket.onmessage = function(event) {
    var message = JSON.parse(event.data)
    $('ul.clock').append($('<li>').text(message['data']))
  };
})
