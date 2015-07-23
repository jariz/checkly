# checkly
Find another you, with your Reddit account!

##What is it?
Checkly is a simple website that matches you with another Redditor that has similar subscriptions.  
You can start a conversation with them if you like, and see the subreddits that you both have in common.  
You can also remove your account again, at any time you like.  

##How does it work?  
- You sign in and give Checkly access to your subreddits and profile. It needs these 2 to match you with others and display your username to others.  
- Checkly immediately matches you with other checkly users!  

##Screenshots  
![](http://i.imgur.com/g7bwZGP.png) ![](http://i.imgur.com/KkQwYiZ.png)

##What is it build on?  
Node, Coffeescript, Express, Jade and MongoDB.

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
