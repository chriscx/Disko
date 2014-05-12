should = require 'should'
Getter = require '../app/controllers/getter'
#assert = require 'assert'
track_sc = "https://soundcloud.com/chrome-sparks/goddess-1"
track_gs = "http://grooveshark.com/#!/s/So+Hard+feat+Monica+Blaire/uA4MV?src=5"
track_yt = "https://www.youtube.com/watch?v=H7HmzwI67ec"


describe 'Getter', ->
  it 'Soundcloud', (done) ->
    Getter.dispatch track_sc, (res) ->
      (res.title).should.be.eql 'goddess'
      done()
it 'Youtube', (done) ->
    Getter.dispatch track_yt, (res) ->
      (res.title).should.be.eql 'Owl City & Carly Rae Jepsen - Good Time'
      done()
it 'Grooveshark', (done) ->
    Getter.dispatch track_gs, (res) ->
      (res.title).should.be.eql 'So Hard (feat. Monica Blaire)'
      done()