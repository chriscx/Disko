fs = require 'fs'
path = require 'path'
https = require 'https'
http = require 'http'
express = require 'express'
# passport = require 'passport'
# LocalStrategy = require('passport-local').Strategy
mongoose = require 'mongoose'
stylus = require 'stylus'
passport = require 'passport'
Account = require('./models/account').Account

app = express()

# Express Config
app.set 'views', path.normalize(__dirname + '/views')
app.set 'view engine', 'jade'
app.set 'view options', pretty: true
app.use express.bodyParser()
app.use express.methodOverride()
app.use express.cookieParser("your secret here")
app.use express.session()
app.use app.router
app.use stylus.middleware "#{__dirname}/../public"
app.use express.static "#{__dirname}/../public"

app.configure "development", ->
  app.use express.errorHandler
    dumpExceptions: true
    showStack: true

app.configure "production", ->
  app.use express.errorHandler()

passport.use Account.createStrategy()

passport.serializeUser Account.serializeUser()
passport.deserializeUser Account.deserializeUser()

# mongoose
# mongoose.connect "mongodb://localhost/passport_local_mongoose"
mongoose.connect 'mongodb://localhost/disko_dev'

require('./controllers/routes') app

# # Https Config
# keyPath = __dirname + '/../ssl/server.key'
# certPath = __dirname + '/../ssl/server.crt'
#
# options =
#     key: fs.readFileSync(keyPath),
#     cert: fs.readFileSync(certPath)

# server = https.createServer options, app
# server.listen 3000, () ->
#     console.log 'https://localhost:3000'
server = http.createServer app
server.listen 3000, () ->
    console.log 'http://localhost:3000'
