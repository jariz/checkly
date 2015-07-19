mongoose = require 'mongoose'
Schema   = mongoose.Schema

UserSchema = new Schema(
  user: Object
  subreddits: Array
)

UserSchema.methods.findSimilar = (cb) ->
  @model('User').find(
    subreddits:
      $in: this.subreddits #match at least one of our subreddits
    'user.name':
      $ne: this.user.name
  , cb)

mongoose.model 'User', UserSchema
