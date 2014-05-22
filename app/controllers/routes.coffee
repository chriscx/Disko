passport = require 'passport'
Account = require('../models/account').Account;
Playlist = require('../models/playlist').Playlist
Getters = require './getter'

module.exports = (app) ->

  app.get '/', (req, res) ->
    console.log('GET view index')
    res.render 'index',
    title: 'Disko'

  # DEV - TEMPORARY
  app.get '/player', (req, res) ->
    console.log('GET view player')
    res.render 'player',
    title: 'Disko'

  # DEV - TEMPORARY
  app.get '/playlists', (req, res) ->
    console.log('GET view playlists')
    res.render 'playlists'
    title: 'Disko'

  # if user is logged, use user login otherwise use a hash stored in cookie
  app.get '/:user/:playlist', (req, res) ->
    console.log('GET playlist ' + req.params.playlist + 'view')
    res.render 'player'

  app.get '/data/:user/:playlist.json', (req, res) ->
    console.log('GET playlist ' + req.params.playlist + ' JSON object')
    Playlist.find {id: req.params.id}, (err, data) ->
      unless err
        res.json {result: 'OK', content: data}
      else
        res.json {result: 'error', content: null}


  app.get '/:user', (req, res) ->
    console.log('GET user ' + req.params.playlist + 'view')
    res.render 'player'

  # TODO add login check
  app.get '/data/:user/info.json', (req, res) ->
    console.log('GET user info ' + req.params.playlist + ' JSON object')
    Account.find {nickname: req.params.user}, (err, data) ->
      unless err or data.length < 1
        res.json {result: 'OK', content: data}
      else
        res.json {result: 'error', content: null}

  # DEV - TEMPORARY
  app.get '/data/playlists.json', (req, res) ->
    console.log('GET playlist ' + req.params.id + ' JSON object')
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

  # just a ping to check if server is running
  app.get '/ping', (req, res) ->
    res.send 'pong!', 200

  #TEMPORARY?
  app.get '/getter', (req, res) ->
    #here fix url before we have views to select one
    console.log req.query.url
    Getters.dispatch req.query.url, (data) ->
      res.send data

  #
  #     `error redirection page`
  #    ----------------------------
  #     :error param is error nb  (404,500...)
  app.get '/error/:error', (req, res) ->
    res.render 'error'
