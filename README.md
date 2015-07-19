# checkly
Find another you, with your Reddit account!

##How to install
- Make sure gulp, npm, sass, compass, bower, etc etc are installed.
- Copy `config/config.default.coffee` to `config/config.coffee`
- Enter mongodb details & reddit app tokens.
- `bower install && npm install`

###Develop:
```
gulp
```
This will start everything you'll need to develop. SASS automatic compiling, automatic restarting of the app, etc.

###Production:
```
NODE_ENV=production npm start
```
Using forever.js is recommended.
```
NODE_ENV=production forever start app.js
```
