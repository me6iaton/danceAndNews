# news schema
validate = require('mongoose-validate')
mongoose = require("mongoose")

Schema = mongoose.Schema
newsSchema = new Schema(
	_eventId: Schema.Types.ObjectId
	user: {_id:  Schema.Types.ObjectId, name: String, avatar: String}
	url: String
	header: String
	picture: String
	text: String
	video: {}
	music: {}
	vote: Number
	time: Number
	dateBegin: Date
	inTimeLine: Boolean
)
mongoose.model "News", newsSchema
