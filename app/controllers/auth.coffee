express  = require 'express'
router = express.Router()
mongoose = require 'mongoose'
User = mongoose.model 'User'
redditoauth = require 'reddit-oauth'
config = config = require('../../config/config')
reddit = new redditoauth config.reddit

state = 'abcdefghijkl'

module.exports = (app) ->
  app.use '/auth', router

router.get '/', (req, res, next) ->
  if req.query.code
    reddit.oAuthTokens state, req.query, (success) ->
      if not success then next new Error('Auth failed')
      else
        req.session.regenerate ->
          req.session.access_token = reddit.access_token
          req.session.refresh_token = reddit.refresh_token
          req.session.save ->
            reddit.request '/api/v1/me', {}, (error, response, body) ->
              if error then error
              else
                try
                  user = JSON.parse body
                catch e
                  next e
                  return

                req.session.user = user
                res.redirect '/match'

  else
    url = reddit.oAuthUrl state, [ 'identity', 'mysubreddits' ]
    res.redirect url

router.get '/remove', (req, res, next) ->
  # I know this is not how you're supposed to use csurf,
  # but I just need a good random string that doesn't change inbetween requests.
  if req.query.csrf != req.session.csrfSecret then next new Error('Invalid CSRF')
  else
    User.findOneAndRemove
      'user.name': req.session.user.name
    , (err) ->
      if not err
        req.session.regenerate ->
          if req.query.reauth
            res.redirect '/auth'
          else
            req.flash 'info', '<strong>You have removed your account from checkly</strong>, it won\'t appear in match results of other users anymore. If you want it to appear again, click \'Authorize\' at the top.'
            res.redirect '/'
      else next err

router.get '/logout', (req, res, next) ->
  if req.query.csrf != req.session.csrfSecret then next new Error('Invalid CSRF')
  else
    req.session.regenerate ->
      req.flash 'info', 'You have logged out.'
      res.redirect '/'
