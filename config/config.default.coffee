path     = require 'path'
rootPath = path.normalize __dirname + '/..'
env      = process.env.NODE_ENV || 'development'

config =
  development:
    root: rootPath
    app:
      name: 'checkly'
    port: 3000
    db: 'mongodb://localhost/checkly-development'
    secret: 'changeme'
    reddit:
      app_id: ''
      app_secret: ''
      redirect_uri: 'http://localhost:3000/auth' #your domain + /auth

  production:
    root: rootPath
    app:
      name: 'checkly'
    port: 3000
    db: 'mongodb://localhost/checkly-production'
    secret: 'changeme'
    reddit:
      app_id: ''
      app_secret: ''
      redirect_uri: 'http://localhost:3000/auth' #your domain + /auth

module.exports = config[env]
