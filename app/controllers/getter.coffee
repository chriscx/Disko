#dependencies
request = require 'request'
colors = require 'colors'
mongoose = require 'mongoose'
Asset = require('../models/asset').Asset

sources =
  youtube:
    resolver: "https://www.googleapis.com/youtube/v3/videos?key="
    content: "&part=snippet&id="
    #key: "AIzaSyAPNIZeQOkk7e519amM5raEUM__SOCml78"
    key: "AIzaSyCxL2W7WQKGQ_IKN9ug37rxeJm-Hr0t7Fw"

    documentation: "https://developers.google.com/youtube/v3/docs/videos?hl=fr"

  soundcloud:
    resolver: "https://api.soundcloud.com/resolve.json?consumer_key="
    content: "&url="
    key: "b45b1aa10f1ac2941910a7f0d10f8e28"

    documentation: "https://developers.soundcloud.com/docs/api/reference"

  grooveshark:
    resolver: ""
    content: ""
    key: ""

    documentation: "http://developers.grooveshark.com/docs/public_api/v3/"

  spotify:
    resolver: ""
    content: ""
    key: ""

    documentation: ""

  deezer:
    resolver: ""
    content: ""
    key: ""

    documentation: ""

track_sc = "https://soundcloud.com/chrome-sparks/goddess-1"
track_gs = "http://grooveshark.com/#!/s/So+Hard+feat+Monica+Blaire/uA4MV?src=5"
full_track_yt = "http://www.youtube.com/watch?v=dR9GRK9vrlU"
play_track_yt = "https://www.youtube.com/watch?v=1JeLoOhnlTk&list=PLgx9GuZnpLj9PLAs-WFdPI_PHtxBRzppK"

### find from which site is the video ###
get_source = (track, callback) ->
  for index of sources
    if(track.indexOf(index) > -1)
      res = index
  callback(res)

String.prototype.build_url = (source) ->
  src = sources[source]
  src.resolver + src.key + src.content + this


request_url = (url, callback) ->
  request url, (error, response, html) ->
    if error and (response.statusCode!=200)
      console.log "Error:" + err
    else
      callback response.body

Asset.prototype.other_infos = () ->
  this.addedBy = "User1"
  this.addedDate = new Date()
  this.order = 1

### get the information from the responses and create objects to be stored in our DB ###
infos_sc = (content, callback) ->
  track = new Asset
    title: content.title
    author: content.user.username
    url: content.uri
    src: "soundcloud"
    id: content.id
  #adds the other infos for the saving in DB for the moment
  track.other_infos()
  callback track

infos_yt = (content, callback) ->
  track =  new Asset
  	title: content.snippet.title
  	author: content.snippet.channelTitle
  	url: "http://www.youtube.com/watch?v=" + content.id
  	src: "youtube"
  	id: content.id
  #adds the other infos for the saving in DB for the moment
  track.other_infos()
  callback track

### manages the actions of dispatching between the different sources ###
dispatch = (track, callback) ->
  get_source track, (src) ->
  	url = null
  	switch src
  	  when "youtube"
  	    # to isolate the video id
        s = track.split("v=")
        s = s[1].split("&")
        track = s[0]
  	  when "soundcloud"
  	  else console.log "SOURCE NOT SUPPORTED YET".red
    url = track.build_url(src)
    request_url url, (res) ->
      switch src
        when "youtube"
          infos_yt JSON.parse(res).items[0], callback
        when "soundcloud"
          infos_sc JSON.parse(res), callback

exports.dispatch = dispatch