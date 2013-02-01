path = require('path')

module.exports = (app)->
	app.set 'root', path.normalize(__dirname + '/..')
	app.set 'port',  process.env.PORT || 3000
	app.set 'db-uri', process.env.MONGOLAB_URI || process.env.MONGOHQ_URL ||'mongodb://localhost/danceAndNews'
	app.set 'views',  path.normalize(__dirname + '/../app/views')
	app.set 'view engine', 'jade'
	app.set 'passport',
	{
		facebook: {
		clientID: "APP_ID"
		, clientSecret: "APP_SECRET"
		, callbackURL: "http://localhost:3000/auth/facebook/callback"
		},
		twitter: {
		clientID: "CONSUMER_KEY"
		, clientSecret: "CONSUMER_SECRET"
		, callbackURL: "http://localhost:3000/auth/twitter/callback"
		},
		github: {
		clientID: 'APP_ID'
		, clientSecret: 'APP_SECRET'
		, callbackURL: 'http://localhost:3000/auth/github/callback'
		},
		google: {
		clientID: "APP_ID"
		, clientSecret: "APP_SECRET"
		, callbackURL: "http://localhost:3000/auth/google/callback"
		}
	}
	console.log(process.env)
	return app