fs = require 'fs'
https = require 'https'
http = require 'http'
express = require 'express'
app = express()

# Express Config
app.set 'views', __dirname + '/../views'
app.set 'view engine', 'jade'
app.use express.bodyParser()
app.use express.methodOverride()
app.use app.router
app.use express.static "#{__dirname}/../../public"
app.use express.errorHandler
  showStack: true
  dumpExceptions: true

require('./routes') app

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
