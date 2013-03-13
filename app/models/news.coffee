# news schema
validate = require('mongoose-validate')
mongoose = require("mongoose")

Schema = mongoose.Schema
UserSchema = new Schema(
  url: String
  user: {}
  avatar: String
  hashed_password: String
  salt: String
  group: []
  vkontakte: {}
  google: {}
  facebook: {}
)
