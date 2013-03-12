socket = io.connect window.location.hostname

#socket.on 'news', (data) ->
#	console.log data
#	socket.emit 'my other event', { my: 'data' }
#	return


setTimeout(->
	socket.emit 'add-event', {message: 'hello'}
	return
, 100)
