socket = io.connect window.location.hostname

#socket.on 'news', (data) ->
#	console.log data
#	socket.emit 'my other event', { my: 'data' }
#	return

socket.emit('add-event')

socket.on 'add-event', ->
	console.log data
