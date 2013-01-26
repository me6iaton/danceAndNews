// Generated by CoffeeScript 1.4.0
(function() {
  var app, express, http, io, mongoOptions, mongoose, path, port, routes, server, uristring, user;

  require('coffee-script');

  express = require('express');

  routes = require('./routes');

  user = require('./routes/user');

  http = require('http');

  path = require('path');

  io = require('socket.io');

  mongoose = require("mongoose");

  port = process.env.PORT || 3000;

  console.log(process.env.MONGOLAB_URI);

  uristring = process.env.MONGOLAB_URI || process.env.MONGOHQ_URL || 'mongodb://localhost/danceAndNews';

  mongoOptions = {
    db: {
      safe: true
    }
  };

  mongoose.connect(uristring, mongoOptions, function(err, res) {
    if (err) {
      console.log("ERROR connecting to: " + uristring + ". " + err);
    } else {
      console.log("Succeeded connected to: " + uristring);
    }
  });

  app = express();

  app.configure(function() {
    app.set('port', port);
    app.set("views", "" + __dirname + "/views");
    app.set('view engine', 'jade');
    app.use(express.favicon());
    app.use(express.logger('dev'));
    app.use(express.bodyParser());
    app.use(express.methodOverride());
    app.use(express.cookieParser('your secret here'));
    app.use(express.session());
    app.use(app.router);
    return app.use(express["static"](path.join(__dirname, 'public')));
  });

  app.configure('development', function() {
    return app.use(express.errorHandler({
      dumpExceptions: true,
      showStack: false
    }));
  });

  app.configure('production', function() {
    return app.use(express.errorHandler());
  });

  app.get('/', routes.index);

  app.get('/users', user.list);

  server = http.createServer(app);

  io = io.listen(server);

  server.listen(app.get("port"), function() {
    return console.log("Express server listening on port " + app.get("port"));
  });

  io.configure(function() {
    io.set("transports", ["xhr-polling"]);
    io.set("polling duration", 10);
  });

  io.sockets.on("connection", function(socket) {
    socket.emit("news", {
      hello: process.env.MONGOLAB_URI
    });
    socket.on("my other event", function(data) {
      console.log(data);
    });
  });

}).call(this);
