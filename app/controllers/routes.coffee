path = require 'path'
passport = require 'passport'
Account = require('../models/account').Account;
Playlist = require('../models/playlist').Playlist
Track = require('../models/track').Track
Getters = require './getter'

module.exports = (app) ->

################################################################################
#                                                                              #
#                            Routes for static files                           #
#                                                                              #
################################################################################

  app.get /^\/static(\/.+)/, (req, res) ->
    file = req.params[0]
    dir = (path.resolve '#{__dirname}/../public/') + '/'
    console.log 'GET static ' + dir + file
    res.sendfile dir + file

################################################################################
#                                                                              #
#                            Routes for data                                   #
#                                                                              #
################################################################################

  # TODO add login check
  app.get '/data/:user/info.json', (req, res) ->
    console.log('GET user info ' + req.params.playlist + ' JSON object')
    Account.find {nickname: req.params.user}, (err, data) ->
      unless err or data.length < 1
        res.json {result: 'OK', content: data}
      else
        res.json {result: 'error', content: null}

  app.post '/data/:user/info.json', (req, res) ->
    console.log('POST user info ' + req.params.playlist + ' JSON object')
    newAccount = new Account(
      nickname: req.body.nickname
      birthday: req.body.birthday
    )
    newAccount.save (err) ->
      unless err
        res.json result: 'OK'
      else
        res.json
          result: 'error'
          err: err

  app.put '/data/:user/info.json', (req, res) ->
    console.log('PUT user info ' + req.params.playlist + ' JSON object')
    Account.findOneAndUpdate {'nickname': req.params.user},
      req.body, # replace body by object with user info to not overwrite passport info
      new: true,
        (err, data) ->
          unless err
            res.json result: 'OK'
          else
            res.json
              result: 'error'
              err: err

  app.del '/data/:user/info.json', (req, res) ->
    console.log('DEL user info ' + req.params.playlist + ' JSON object')
    Account.remove {'nickname': req.params.user}, (err, data) ->
      if data > 0 and not err
        res.json result: 'OK'
      else
        res.json
          result: 'error'
          err: err

  # DEV - TEMPORARY
  app.get '/data/playlists.json', (req, res) ->
    console.log('GET playlist ' + req.params.id + ' JSON object')
    Playlist.find {}, (err, data) ->
      if !err
        res.json {result: 'OK', content: data}
      else
        res.json {result: 'error', content: null}

  app.get '/data/:user/:playlist.json', (req, res) ->
    console.log('GET playlist ' + req.params.playlist + ' JSON object')
    Playlist.find {'id': req.params.id, 'owner': req.params.user}, (err, data) ->
      unless err
        res.json {result: 'OK', content: data}
      else
        res.json {result: 'error', content: null}

  #TODO check is param user is the same as login user
  app.post '/data/:user/:playlist.json', (req, res) ->

    console.log('POST playlist ' + req.params.playlist + ' JSON object')

    arr = []
    for track in req.body.content.length by 1
      arr.push new Track(track)

    newPlaylist = new Playlist(
      title: req.body.title
      id: req.body.id
      owner: req.body.owner
      editors: req.body.editors
      visibility: req.body.visibility
      content: arr
      creationDate: req.body.creationDate
      modificationDate: req.body.modificationDate
    )
    newPlaylist.save (err) ->
      unless err
        res.json result: 'OK'
      else
        res.json
          result: 'error'
          err: err

  app.put '/data/:user/:playlist.json', (req, res) ->
    console.log('PUT playlist ' + req.params.playlist + ' JSON object')
    Playlist.findOneAndUpdate {'id': req.params.id, 'owner': req.params.user},
      req.body,
      new: true,
        (err, data) ->
          unless err
            res.json result: 'OK'
          else
            res.json
              result: 'error'
              err: err

  app.del '/data/:user/:playlist.json', (req, res) ->
    console.log('DEL playlist ' + req.params.playlist + ' JSON object')
    entry.remove {'id': req.params.id, 'owner': req.params.user}, (err, data) ->
      if data > 0 and not err
        res.json result: 'OK'
      else
        res.json
          result: 'error'
          err: err

  app.get '/data/getter/:playlist', (req, res) ->
    console.log (req.query.url + ' in ' + req.params.playlist).white
    #adding playlist id for saving track in it
    Getters.dispatch req.query.url, req.params.playlist, (data) ->
      res.send data
################################################################################
#                                                                              #
#                            Routes for views                                  #
#                                                                              #
################################################################################

  app.get '/signup', (req, res) ->
    res.render 'signup',
      title: 'Disko'

  app.post '/signup', (req, res) ->
    Account.register new Account(username: req.body.username),
    req.body.password,
    (err, account) ->
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

  #
  #     `error redirection page`
  #    ----------------------------
  #     :error param is error nb  (404,500...)
  app.get '/error/:error', (req, res) ->
    res.render 'error'

  app.get '/:user', (req, res) ->
    console.log('GET user ' + req.params.playlist + ' view')
    res.render 'user'

  # if user is logged, use user login otherwise use a hash stored in cookie
  app.get '/:user/:playlist', (req, res) ->
    console.log('GET playlist ' + req.params.playlist + ' view')
    res.render 'player'
