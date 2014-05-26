should = require 'should'
Getter = require '../app/controllers/getter'
track_sc = "https://soundcloud.com/chrome-sparks/goddess-1"
track_yt = "https://www.youtube.com/watch?v=H7HmzwI67ec"


describe 'Getter', ->

  it 'gets Soundcloud track info', (done) ->
    Getter.dispatch track_sc, (res) ->
      (res.title).should.be.eql 'goddess'
      done()

  it 'gets Youtube track info', (done) ->
      Getter.dispatch track_yt, (res) ->
        (res.title).should.be.eql 'Owl City & Carly Rae Jepsen - Good Time'
        done()