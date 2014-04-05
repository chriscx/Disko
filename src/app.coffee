fs = require 'fs'
https = require 'https'
express = require 'express'
app = express()

# Express Config
app.set 'views', __dirname + '/../views'
app.set 'view engine', 'jade'
app.use express.bodyParser()
app.use express.methodOverride()
app.use app.router
app.use express.static "#{__dirname}/../public"
app.use express.errorHandler
  showStack: true
  dumpExceptions: true

# Https Config
keyPath = __dirname + '/../ssl/server.key'
certPath = __dirname + '/../ssl/server.crt'

options =
    key: fs.readFileSync(keyPath),
    cert: fs.readFileSync(certPath)

# ROUTES
app.get '/', (req, res) ->
  res.render 'index', title: 'Disko'

server = https.createServer options, app
server.listen 3000, () ->
    console.log 'https://localhost:3000'
