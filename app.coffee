require 'coffee-script'

#Module dependencies.
express = require 'express'
routes = require './routes'
user = require './routes/user'
http = require 'http'
path = require 'path'

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
http.createServer(app).listen app.get("port"), ->
  console.log "Express server listening on port " + app.get("port")