require 'coffee-script'

#Module dependencies.
express = require 'express'
routes = require './routes'
user = require './routes/user'
http = require 'http'
path = require 'path'
io = require 'socket.io'

app = express()

# CONFIGURATION
app.configure ->
  app.set 'port', process.env.PORT || 3000
  app.set "views", "#{__dirname}/views"
  app.set 'view engine', 'jade'
  app.use express.favicon()
  app.use express.logger('dev')
  app.use express.bodyParser()
  app.use express.methodOverride()
  app.use express.cookieParser('your secret here')
  app.use express.session()
  app.use app.router
  app.use express.static(path.join(__dirname, 'public'))

app.configure 'development', ->
  app.use express.errorHandler { dumpExceptions: true, showStack: true }

app.configure 'production', ->
  app.use express.errorHandler()



# ROUTES
app.get '/', routes.index
app.get '/users', user.list

# SERVER
server = http.createServer(app)
io = io.listen server
server.listen app.get("port"), ->
  console.log "Express server listening on port " + app.get("port")


#Heroku won't actually allow us to use WebSockets
#so we have to setup polling instead.
#https://devcenter.heroku.com/articles/using-socket-io-with-node-js-on-heroku
io.configure ->
  io.set "transports", ["xhr-polling"]
  io.set "polling duration", 10
  return

io.sockets.on "connection", (socket) ->
  socket.emit "news",
    hello: "world"
  socket.on "my other event", (data) ->
    console.log data
    return
  return
