mongoose = require 'mongoose'
Schema   = mongoose.Schema
defaults = require '../../config/defaults'

removeDefaults = (subs) -> subs.filter (sub) -> defaults.indexOf(sub) is -1

UserSchema = new Schema(
  user: Object
  subreddits: Array
)

UserSchema.virtual('subredditsFiltered').get ->
  removeDefaults @subreddits

UserSchema.methods.findSimilar = (cb) ->
  @model('User').find
    subreddits:
      $in: @subredditsFiltered #match at least one of our subreddits
    'user.name':
      $ne: @user.name
  , (err, model) ->
      cb err, if model is null then null else removeDefaults model

mongoose.model 'User', UserSchema
