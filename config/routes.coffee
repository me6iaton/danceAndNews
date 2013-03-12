mongoose = require("mongoose")
passport = require("passport")
User = mongoose.model("User")

module.exports = (app) ->
	# user routes
	users = require('../app/controllers/users.coffee')
	app.get '/login', users.login
	app.get '/signup', users.signup
	app.get '/logout', users.logout
	app.post('/users', users.create)
	#  app.post '/users', users.create
	app.get '/auth/vkontakte', passport.authenticate('vkontakte-email'
		,{scope: ['audio','video','offline']
		,failureRedirect: '/login'
		,failureFlash: true}
	), users.signin
	app.get '/auth/vkontakte/callback', passport.authenticate('vkontakte-email'
		,{failureRedirect: '/login'
		,failureFlash: true})
	app.get '/auth/vkontakte/addemail', users.authGetEmailCallback
	app.post '/auth/vkontakte/addemail', passport.authenticate('vkontakte-email'
		,{failureRedirect: '/login'
		,failureFlash: true}
	), users.authCallback
	app.get '/auth/facebook', passport.authenticate('facebook'
		,{scope: [ 'email', 'user_about_me']
		,failureRedirect: '/login'
		,failureFlash: true}
	), users.signin
	app.get '/auth/facebook/callback', passport.authenticate('facebook'
		,{failureRedirect: '/login'
		,failureFlash: true}
	), users.authCallback
	app.get '/auth/google', passport.authenticate('google'
		,{scope: [ 'https://www.googleapis.com/auth/userinfo.email'
			,'https://www.googleapis.com/auth/userinfo.profile'
			,'https://gdata.youtube.com'
			,'https://www.googleapis.com/auth/plus.me']
		,failureRedirect: '/login'
		,failureFlash: true}
	), users.signin
	app.get '/auth/google/callback', passport.authenticate('google'
		,{failureRedirect: '/login'
		,failureFlash: true}
	), users.authCallback

	# index
	index = require('../app/controllers/index.coffee')
	app.get '/', index.index

	# events
	events = require('../app/controllers/events.coffee')
	app.get '/add-event', events.addEvent
