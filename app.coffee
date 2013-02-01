require 'coffee-script'

#Module dependencies.
express = require 'express'
routes = require './config/routes/'
user = require './config/routes/user'
http = require 'http'
path = require 'path'
io = require 'socket.io'
mongoose = require 'mongoose'
mongoStore = require 'connect-mongodb'
passport = require 'passport'

app = express()

dbUri = process.env.MONGOLAB_URI || process.env.MONGOHQ_URL ||'mongodb://localhost/danceAndNews'
port = process.env.PORT || 3000

# db connect
mongoOptions = { db: { safe: true }}
db = mongoose.connect dbUri, mongoOptions, (err, res) ->
	if err
		console.log "ERROR connecting to: " + dbUri + ". " + err
	else
		console.log "Succeeded connected to: " + dbUri
	return

# CONFIGURATION

# Load configurations
require('./config/config')(app)



app.configure 'development', ->
	app.use express.errorHandler { dumpExceptions: true, showStack: false }
	return
app.configure 'production', ->
	app.use express.errorHandler()
	return

app.configure ->
	app.use express.favicon()
	app.use express.logger('dev')
	app.use express.bodyParser()
	app.use express.methodOverride()
	app.use express.cookieParser("secretdancenews")
	app.use express.session { store: mongoStore(app.set('db-uri') , secret: 'keyboard cat') }
	app.use passport.initialize()
	app.use passport.session()
	app.use app.router
	app.use express.static(path.join(__dirname, 'public'))
	return

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
	io.set('log level', 1)
	return

io.sockets.on "connection", (socket) ->
	socket.emit "news",
		hello: "hello"
	socket.on "my other event", (data) ->
		console.log data
		return
	return
