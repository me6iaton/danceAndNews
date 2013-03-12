exports.addEvent = (req, res) ->
#	debugger
#	io.sockets.on "connection", (socket) ->
#		socket.emit "news",
#			hello: "hello"
#		socket.on "my other event", (data) ->
#			console.log data
#			return
#		return
	debugger
	req.app.io.route 'add-event', (req)->
		console.log(req.data)
		return
	res.render "events/addEvent", title: "add Event", scripts: ['/js/events.client.js']
	return
