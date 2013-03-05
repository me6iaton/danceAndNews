path = require('path')
module.exports = (app)->
	domenName =  process.env.DOMEN || 'localhost'
	port = process.env.PORT || 3000
	app.set 'root', path.normalize(__dirname + '/..')
	app.set 'port', port
	app.set 'domenName', domenName
	app.set 'dbUrl', process.env.MONGOLAB_URI || process.env.MONGOHQ_URL ||'mongodb://localhost/danceAndNews'
	app.set 'views',  path.normalize(__dirname + '/../app/views')
	app.set 'view engine', 'jade'
	app.set 'passport',
	{
		vkontacte: {clientID:     "3433077"# VK.com docs call it 'API ID'
		, clientSecret: "k8H98vnd1257p9ceHh6v"
		,callbackURL: "http://"+domenName+":"+port+"/auth/vkontakte/callback"
		,getEmailURL: "/auth/vkontakte/addemail"
		,emailField: "email"
		},
		facebook: {clientID: "492849577442620"
		, clientSecret: "fa4effa2d52075da11cf5dd21de34a2a"
		, callbackURL: "http://"+domenName+":"+port+"/auth/facebook/callback"
		},
		google: {clientID: "18339876807.apps.googleusercontent.com"
		, clientSecret: "ya6m5BdZKilfbx7h30gEgKv8"
		, callbackURL: "http://"+domenName+":"+port+"/auth/google/callback"
		}
	}
	app.set 'app',
	{
		name: "DanceAndNews"
	}
	app.set 'title', 'DanceAndNews application'
	return
