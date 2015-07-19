express = require 'express'
glob = require 'glob'

favicon = require 'serve-favicon'
logger = require 'morgan'
cookieParser = require 'cookie-parser'
bodyParser = require 'body-parser'
compress = require 'compression'
methodOverride = require 'method-override'
mongoose = require 'mongoose'
session = require 'express-session'
MongoStore = require('connect-mongo')(session)
csrf = require 'csurf'
flash = require 'express-flash'

module.exports = (app, config) ->
  app.set 'views', config.root + '/app/views'
  app.set 'view engine', 'jade'

  env = process.env.NODE_ENV || 'development'
  app.locals.ENV = env;
  app.locals.ENV_DEVELOPMENT = env == 'development'

  # app.use(favicon(config.root + '/public/img/favicon.ico'));
  app.use logger 'dev'
  app.use bodyParser.json()
  app.use bodyParser.urlencoded(
    extended: true
  )
  app.use cookieParser()
  app.use compress()
  app.use express.static config.root + '/public'
  app.use methodOverride()

  app.use session(
    secret: config.secret
    store: new MongoStore { mongooseConnection: mongoose.connection }
    saveUninitialized: true
    resave: true
  )

  app.use csrf()
  app.use flash()

  #Automatically add session vars to view
  app.use (req, res, next) ->
    app.locals.user = req.session.user
    app.locals.csrf = req.session.csrfSecret
    next()

  controllers = glob.sync config.root + '/app/controllers/**/*.coffee'
  controllers.forEach (controller) ->
    require(controller)(app);

  # catch 404 and forward to error handler
  app.use (req, res, next) ->
    err = new Error 'Not Found'
    err.status = 404
    next err

  # error handlers

  # development error handler
  # will print stacktrace

  if app.get('env') == 'development'
    app.use (err, req, res, next) ->
      res.status err.status || 500
      res.render 'error',
        message: err.message
        error: err
        title: 'error'

  # production error handler
  # no stacktraces leaked to user
  app.use (err, req, res, next) ->
    res.status err.status || 500
    res.render 'error',
      message: 'Oops, something went wrong'
      error: {}
      title: 'error'
