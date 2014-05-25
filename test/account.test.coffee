should = require 'should'
mongoose = require 'mongoose'
Account = require('../app/models/account').Account

describe 'Account', ->
  before (done) ->
    unless mongoose.connection.readyState
      mongoose.connect 'mongodb://localhost/disko_dev', null, ->
        done()

  after (done) ->
    mongoose.disconnect done

  beforeEach (done) ->
    account = new Account
      username: "12345"
      password: "testy"

    account.save (error) ->
      if error
        console.log "error" + error.message
      else
        console.log "no error"
      done()

  it "find a user by username", (next) ->
    Account.findOne
      username: "12345"
    , (err, account) ->
      account.username.should.eql "12345"
      console.log "username: ", account.username
      next()

  afterEach (done) ->
    Account.remove {}, ->
      done()
