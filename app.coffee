require 'coffee-script'

#Module dependencies.
fs = require 'fs'
express = require 'express.io'
http = require 'http'
path = require 'path'
io = require 'socket.io'
mongoose = require 'mongoose'
mongoStore = require('connect-mongo')(express)
flash = require('connect-flash')
passport = require 'passport'
viewHelpers = require './config/middlewares/view'
expressError = require 'express-error'

app = express()

dbUri = process.env.MONGOLAB_URI || process.env.MONGOHQ_URL ||'mongodb://localhost/danceAndNews'
port = process.env.PORT || 3000

# CONFIGURATION
# Load configurations
require('./config/config')(app)
# db connect
dbUrl =  app.get 'dbUrl'
mongoOptions = { db: { safe: true }}
db = mongoose.connect dbUrl, mongoOptions, (err, res) ->
	if err
		console.log "ERROR connecting to: " +dbUrl + ". " + err
	else
		console.log 'Succeeded connected to: ' + dbUrl
	return

# Load models
models_path = __dirname + '/app/models'
fs.readdirSync(models_path).forEach (file)->
	require(models_path+'/'+file) if file.slice(-6) == "coffee"

# passport config
require('./config/passport')(app)

app.configure 'development', ->
	app.use express.errorHandler { dumpExceptions: true, showStack: false }
	app.use expressError.express3 {contextLinesCount: 3, handleUncaughtException: true}
	return
app.configure 'production', ->
	app.use express.errorHandler()
	return
app.configure ->
	app.use viewHelpers app
	app.use express.favicon()
	app.use express.logger('dev')
	app.use express.bodyParser()
	app.use express.methodOverride()
	app.use express.cookieParser "secret-dance-and-news"
	app.use express.session {
		secret: 'secret-dance-and-news',
		store: new mongoStore {
			url: app.get('dbUrl'),
			collection : 'sessions'
			}
		}
	app.use flash()
	app.use passport.initialize()
	app.use passport.session()
	app.use app.router
	app.use express.static(path.join(__dirname, 'public'))
	return

# SERVER
app.http().io()
app.listen app.get("port"), ->
	console.log "Express server listening on port " + app.get("port")
#Heroku won't actually allow us to use WebSockets
#so we have to setup polling instead.
#https://devcenter.heroku.com/articles/using-socket-io-with-node-js-on-heroku
app.io.configure ->
#		app.io.enable('browser client minification')
#		app.io.enable('browser client gzip')
	app.io.set "transports", ["xhr-polling"]
	app.io.set "polling duration", 10
	app.io.set('log level', 1)
	return
#
#app.io.on 'add-event', (data)->
#	console.log(data)
#	return


#io.configure ->
#	io.set "transports", ["xhr-polling"]
#	io.set "polling duration", 10
#	io.set('log level', 1)
#	return
#
#io.sockets.on "connection", (socket) ->
#	socket.emit "news",
#		hello: "hello"
#	socket.on "my other event", (data) ->
#		console.log data
#		return
#	return

# ROUTES
require('./config/routes')(app)
