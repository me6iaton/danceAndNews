// Generated by CoffeeScript 1.6.1
(function() {
  var socket;

  socket = io.connect(window.location.hostname);

  setInterval(function() {
    socket.emit('add-event', {
      message: 'hello'
    });
  }, 1000);

}).call(this);
