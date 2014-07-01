fs = require 'fs'
path = require 'path'
express = require 'express'
bodyParser = require("body-parser")
methodOverride = require("method-override")
# passport = require 'passport'
# LocalStrategy = require('passport-local').Strategy
mongoose = require 'mongoose'
stylus = require 'stylus'
passport = require 'passport'
Account = require('./models/account').Account

logErrors = (err, req, res, next) ->
  console.error err.stack
  next err

clientErrorHandler = (err, req, res, next) ->
  if req.xhr
    res.send 500,
      error: "Something blew up!"
  else
    next err

errorHandler = (err, req, res, next) ->
  res.status 500
  res.render "error",
    error: err

app = express()

app.use (err, req, res, next) ->
  console.error err.stack
  res.send 500, "Something broke!"

app.use bodyParser.urlencoded({extended: true})
app.use bodyParser.json()
app.use methodOverride()
app.use logErrors
app.use clientErrorHandler
app.use errorHandler

# Express Config
app.set 'views', path.normalize(__dirname + '/views')
app.set 'view engine', 'jade'
app.set 'view options', pretty: true

app.use stylus.middleware "#{__dirname}/../public"
app.use express.static "#{__dirname}/../public"

# passport.use Account.createStrategy()
#
# passport.serializeUser Account.serializeUser()
# passport.deserializeUser Account.deserializeUser()

# mongoose
# mongoose.connect "mongodb://localhost/passport_local_mongoose"
mongoose.connect 'mongodb://localhost/disko_dev'

require('./routes') app

server = require('http').Server(app)
io = require('socket.io')(server)

io.on 'connection', (socket) ->
  socket.on 'pl_change', (data) ->
    console.log(data)
    socket.broadcast.emit 'pl_change', my: 'changes forwarded'

server.listen 3000
