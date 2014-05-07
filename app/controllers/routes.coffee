passport = require 'passport'
Account = require('../models/account').Account;
Playlist = require('../models/playlist').Playlist

module.exports = (app) ->

  app.get '/', (req, res) ->
    console.log('GET view index')
    res.render 'index',
    title: 'Disko'

  app.get '/player', (req, res) ->
    console.log('GET view player')
    res.render 'player',
    title: 'Disko'

  app.get '/playlists', (req, res) ->
    console.log('GET view playlists')
    res.render 'playlists'
    title: 'Disko'

  app.get '/data/:user/:playlist.json', (req, res) ->
    console.log('GET playlist ' + req.params.playlist + ' JSON object')
    Playlist.find {id: req.params.id}, (err, data) ->
      unless err
        res.json {result: 'OK', content: data}
      else
        res.json {result: 'error', content: null}

  app.get '/data/playlists.json', (req, res) ->
    console.log('GET playlist' + req.params.id + ' JSON object')
    Playlist.find {}, (err, data) ->
      if !err
        res.json {result: 'OK', content: data}
      else
        res.json {result: 'error', content: null}

  app.get '/signup', (req, res) ->
    res.render 'signup',
      title: 'Disko'
  
  app.post '/signup', (req, res) ->
    Account.register new Account(username: req.body.username), req.body.password, (err, account) ->
      if err
        res.render 'signup',
          info: "Sorry. That username already exists. Try again."
  
      passport.authenticate 'local', (req, res) ->
        res.redirect '/'
  
  app.get '/login', (req, res) ->
    res.render 'login',
      title: 'Disko'
  
  app.post '/login', passport.authenticate 'local', (req, res) ->
    res.redirect '/'
  
  app.get '/logout', (req, res) ->
    req.logout()
    res.redirect '/'

  app.get '/ping', (req, res) ->
    res.send 'pong!', 200
