express  = require 'express'
router = express.Router()
mongoose = require 'mongoose'
User = mongoose.model 'User'

module.exports = (app) ->
  app.use '/', router

router.get '/', (req, res, next) ->
  res.render 'index',
    title: 'Checkly - Find similar people like you, with your reddit account!'

router.get '/match', (req, res, next) ->
  if not req.session.access_token or not req.session.refresh_token or not req.session.user then res.redirect '/auth'
  else
    User.findOne { 'user.name': req.session.user.name }, (error, model) ->
      res.render 'match',
        title: 'Checkly - Find similar people like you, with your reddit account!'
        firsttime: model == null
