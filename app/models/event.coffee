# news schema
validate = require('mongoose-validate')
mongoose = require("mongoose")

Schema = mongoose.Schema
eventSchema = new Schema(
	dateBegin: Date
	dateEnd: Date
	inStackNews: []
	inTimeLineNews: []
	video: {}
)
mongoose.model "Event", eventSchema
