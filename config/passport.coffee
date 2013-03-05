mongoose = require("mongoose")
passport = require("passport")

LocalStrategy = require('passport-local').Strategy
FacebookStrategy = require("passport-facebook").Strategy
VkontakteStrategy = require("../fork_node_modules/passport-vkontakte-email").Strategy
GoogleStrategy = require("passport-google-oauth").OAuth2Strategy
User = mongoose.model("User")

module.exports = (app) ->
	# serialize sessions
	config = app.get("passport")

	passport.serializeUser (user, done) ->
		done null, user.id
		return

	passport.deserializeUser (id, done) ->
		User.findOne
			_id: id
		, (err, user) ->
			done err, user
			return
		return

	# use vkontacte strategy
	passport.use new VkontakteStrategy(
		clientID: config.vkontacte.clientID
		clientSecret: config.vkontacte.clientSecret
		callbackURL: config.vkontacte.callbackURL
		getEmailURL: config.vkontacte.getEmailURL
		emailField: config.vkontacte.emailField
		,(req, accessToken, refreshToken, profile, done) ->
			if req.session.vkontacte.profile.email
				profile = req.session.vkontacte.profile
				User.findOne "email": req.session.vkontacte.profile.email , (err, user) ->
					return done(err)  if err
					unless user
						user = new User(
							name: profile.displayName
							username: profile.username
							email: profile.email
							avatar: profile.photos[0].value
							vkontakte: profile._json
						)
						user.save (err) ->
							console.log err  if err
							done err, user
					else
						unless user.vkontakte
							user.set("vkontakte", profile._json)
							user.save (err) ->
								console.log err  if err
								done err, user
						else
							done err, user
			return
	)
#  use facebook strategy
	passport.use new FacebookStrategy(
		clientID: config.facebook.clientID
		clientSecret: config.facebook.clientSecret
		callbackURL: config.facebook.callbackURL
	, (accessToken, refreshToken, profile, done) ->
		User.findOne
			"email": profile.emails[0].value
		, (err, user) ->
			return done(err)  if err
			unless user
				user = new User(
					name: profile.displayName
					email: profile.emails[0].value
					username: profile.username
					avatar: 'https://graph.facebook.com/'+profile.id+'/picture?type=large'
					facebook: profile._json
				)
				user.save (err) ->
					console.log err  if err
					done err, user
				return
			else
				unless user.facebook
					user.set("facebook", profile._json)
					user.save (err) ->
						console.log err  if err
						done err, user
				else
					done err, user
	)
	# use google strategy
	passport.use new GoogleStrategy(
		clientID: config.google.clientID
		clientSecret: config.google.clientSecret
		callbackURL: config.google.callbackURL
	, (accessToken, refreshToken, profile, done) ->
		User.findOne
			"email": profile.emails[0].value
		, (err, user) ->
			unless user
				user = new User(
					name: profile.displayName
					email: profile.emails[0].value
					username: profile.username
					avatar: profile._json.picture
					google: profile._json
				)
				user.save (err) ->
					console.log err  if err
					done err, user
			else
				unless user.google
					user.set("google", profile._json)
					user.save (err) ->
						console.log err  if err
						done err, user
				else
					done err, user
	)
# use local strategy
