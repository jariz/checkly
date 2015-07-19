express  = require 'express'
router = express.Router()
mongoose = require 'mongoose'
User = mongoose.model 'User'
redditoauth = require 'reddit-oauth'
config = config = require('../../config/config')
reddit = new redditoauth config.reddit

module.exports = (app) ->
  app.use '/async', router

getProfile = (req, next, cb) ->
  reddit.access_token = req.session.access_token
  reddit.refresh_token = req.session.refresh_token

  subs = []

  getSubs = ->
    user = req.session.user

    #check if profile is already in db
    User.findOne { 'user.name': user.name}, (error, user_model) ->
      if not error and user_model then cb user_model
      else
        #get subscribed reddits
        reddit.getListing '/subreddits/mine/subscriber', [], (error, response, body, getNext) ->
          if error then next error
          else
            console.log "Subscriber listing... (got " + subs.length + " already)"
            try
              listing = JSON.parse body
            catch e
              next e
              return

            subs.push sub.data.display_name for sub in listing.data.children

            if getNext then getNext()
            else
              #done
              console.log "all done. got " + subs.length + " subs"
              console.log "saving......................"
              usermodel = new User
                user: user,
                subreddits: subs

              usermodel.save ->
                cb usermodel

  #check if profile(+subs) are already in db (based on session)
  if req.session.user and typeof req.session.user.name is 'string'
    User.findOne { 'user.name': req.session.user.name }, (error, user) ->
      if not error and user then cb user
      else getSubs()
  else getSubs()

router.get '/match', (req, res, next) ->
  if not req.session.access_token or not req.session.refresh_token or not req.session.user then next new Error('Not logged in')
  else
    getProfile req, next, (user) ->
      user.findSimilar (err, similars) ->
        if err then next err

        output = []
        for similar in similars
          samesubs = []
          samesubs.push(subreddit) for subreddit in similar.subreddits when user.subreddits.indexOf(subreddit) != -1

          output.push
            name: similar.user.name
            similar: samesubs
            score: ((samesubs.length / user.subreddits.length) * 100).toFixed(2)

        output.sort (a, b) -> a.score < b.score
        output.splice 10, Number.MAX_VALUE

        res.send output

