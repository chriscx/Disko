passport = require 'passport'
# Account = require('../models/account').Account;
Playlist = require('../models/playlist').Playlist

module.exports = (app) ->

  app.get '/', (req, res) ->
    console.log('GET view index')
    res.render 'index',
    title: 'Disko'

  # app.get '/css/:filename.css', (req, res) ->
  #   res.sendfile('../../public/css/' + req.params.filename + '.css');

  app.get '/player', (req, res) ->
    console.log('GET view playlist')
    res.render 'player',
    title: 'Disko'

  app.get '/data/:user/:playlist.json', (req, res) ->
    console.log('GET playlist ' + req.params.playlist + ' JSON object')
    Playlist.find {id: req.params.id}, (err, data) ->
      if !err
        res.json {result: 'OK', content: data}
      else
        res.json {result: 'error', content: null}

# //temp
  app.get '/data/playlists.json', (req, res) ->
    console.log('GET playlist' + req.params.id + ' JSON object')
    Playlist.find {}, (err, data) ->
      if !err
        res.json {result: 'OK', content: data}
      else
        res.json {result: 'error', content: null}

  # app.get '/register', (req, res) ->
  #   res.render 'register',
  #     title: 'Disko'
  #     {}
  #
  # app.post '/register', (req, res) ->
  #   Account.register new Account(username: req.body.username), req.body.password, (err, account) ->
  #     if err
  #       res.render 'register',
  #         info: "Sorry. That username already exists. Try again."
  #
  #     passport.authenticate 'local', (req, res) ->
  #       res.redirect '/'
  #
  # app.get '/login', (req, res) ->
  #   res.render 'login',
  #     title: 'Disko'
  #     user: req.user
  #
  # app.post '/login', passport.authenticate 'local', (req, res) ->
  #   res.redirect '/'
  #
  # app.get '/logout', (req, res) ->
  #   req.logout()
  #   res.redirect '/'

  app.get '/ping', (req, res) ->
    res.send 'pong!', 200
