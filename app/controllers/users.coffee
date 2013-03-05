mongoose = require("mongoose")
User = mongoose.model("User")
passport = require("passport")

exports.signin =  (req, res) ->
#	console.log(req.profile)
	res.redirect "/"
	return

# login
exports.login = (req, res) ->
	res.render "users/login",
		title: "Login"
		message: req.flash("error")
	return

# auth callback
exports.authCallback = (req, res, next) ->
	res.redirect "/"
	return

# auth add email callback
exports.authGetEmailCallback =  (req, res) ->
	res.render "users/getEmail",
	title: "getEmail"
	message: req.flash("error")

exports.create =  (req, res, next) ->
	passport.authenticate("vkontakte-email", (err, user, info) ->
		return next(err)  if err
		return res.redirect("/login")  unless user
		res.redirect '/'
		return
#    req.logIn user, (err) ->
#      return next(err)  if err
#      res.redirect "/users/" + user.username
#      return
	) req, res, next
	return

exports.test = (req, res, next) ->
	console.log(req)
	next()
	return

# sign up
exports.signup = (req, res) ->
	res.render "users/signup",
		title: "Sign up"
		user: new User()
	return

# logout
exports.logout = (req, res) ->
	req.logout()
	res.redirect "/login"


## session
exports.session = (req, res) ->
	res.redirect "/"
	return

#exports.create = (req, res) ->
#	debugger
#	return
## signup
#exports.create = (req, res) ->
#	user = new User(req.body)
#	user.provider = "local"
#	user.save (err) ->
#		if err
#			return res.render("users/signup",
#				errors: err.errors
#				user: user
#			)
#		req.logIn user, (err) ->
#			return next(err)  if err
#			res.redirect "/"
#			return
#		return
#	return

## show profile
#exports.show = (req, res) ->
#  user = req.profile
#  res.render "users/show",
#    title: user.name
#    user: user
#	return
