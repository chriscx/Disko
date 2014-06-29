mongoose = require 'mongoose'
should = require 'should'
request = require 'request'
events = require 'events'
eventEmitter = new events.EventEmitter()

getSlug = require 'speakingurl'

Account = require('../app/models/account').Account
Playlist = require('../app/models/playlist').Playlist
Track = require('../app/models/track').Schema

describe 'app', ->

  before (done) ->
    unless mongoose.connection.readyState
      mongoose.connect 'mongodb://localhost/disko_dev', null, ->
        eventEmitter.emit 'MongoConnected'
        done()
    else
      eventEmitter.emit 'MongoConnected'

    eventEmitter.on 'MongoConnected', () ->
      for i in [1..10] by 1
        do (i) ->
          newPlaylist = new Playlist(
            #TODO add elements
          )
          newPlaylist.save (err) ->
            throw err if err

  after (done) ->
    Playlist.find
      owner: 'test'
    .remove()
    .exec()
    mongoose.disconnect done

  it 'should get index page', (next) ->
    request 'http://localhost:3000/', (err, res, body) ->
      res.statusCode.should.be.eql 200
      next()

  it 'should get login page', (next) ->
    request 'http://localhost:3000/login', (err, res, body) ->
      res.statusCode.should.be.eql 200
      next()

  it 'should post login page', (next) ->
    next()

  it 'should get signup page', (next) ->
    request 'http://localhost:3000/signup', (err, res, body) ->
      res.statusCode.should.be.eql 200
      next()

  it 'should post signup page', (next) ->
    next()

  it 'should get logout page', (next) ->
    request 'http://localhost:3000/logout', (err, res, body) ->
      res.statusCode.should.be.eql 200
      next()

  it 'should get single playlist in json', (next) ->
    request 'http://localhost:3000/data/playlists.json', (err, res, body) ->
      res.statusCode.should.be.eql 200
      data = JSON.parse body
      data.result.should.be.eql 'OK'
      data.entries[0].id.should.be.eql 'title-1'
      next()

  it 'should post new playlist', (next) ->
    request.post(
      uri: 'http://localhost:3000/data/playlists.json'
      headers:
        'content-type': 'application/json'
      body: JSON.stringify
        #TODO populate
    , (err, res, body) ->
      res.statusCode.should.be.eql 200
      Playlist.find {"id": "post-test"}, (err, data) ->
        data.should.not.be.empty
        data[0].title.should.be.eql 'post test'
        next()
    )

  it 'should del blog playlist', (next) ->
    request.post(
      uri: 'http://localhost:3000/data/playlists.json'
      headers:
        'content-type': 'application/json'
      body: JSON.stringify
        #TODO populate
    , (err, res, body) ->
      res.statusCode.should.be.eql 200
      Playlist.find {"id": "del-test"}, (err, data) ->
        data.should.not.be.empty
        data[0].title.should.be.eql 'del test'
        request.del 'http://localhost:3000/playlists.json'
        , (err, res, body) ->
          Playlist.find {"id": "del-test"}, (err, data) ->
            data.should.be.empty
            next()
    )

  it 'should put blog playlist', (next) ->
    request.post(
      uri: 'http://localhost:3000/data/playlists.json'
      headers:
        'content-type': 'application/json'
      body: JSON.stringify
        #TODO populate
      # res.statusCode.should.be.eql 200
      Playlist.find {"id": "put-test"}, (err, data) ->
        data.should.not.be.empty
        data[0].title.should.be.eql 'put test 1'

        request.put(
          uri: 'http://localhost:3000/playlists.json'
          headers:
            'content-type': 'application/json'
          body: JSON.stringify
            title: 'put test 2'

        , (err, res, body) ->
          Playlist.find {"id": "put-test"}, (err, data) ->
            data.should.not.be.empty
            data[0].title.should.be.eql 'put test 2'
            next()
        )
    )

  it 'should get error page', (next) ->
    request 'http://localhost:3000/error/404', (err, res, body) ->
      res.statusCode.should.be.eql 200
      next()
