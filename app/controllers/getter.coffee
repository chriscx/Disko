#dependencies
request = require 'request'
colors = require 'colors'
Track = require('../models/track').Track
Playlist = require('../models/playlist').Playlist

sources =
  youtube:
    resolver: "https://www.googleapis.com/youtube/v3/videos?key="
    content: "&part=snippet,contentDetails&id="
    key: "AIzaSyCxL2W7WQKGQ_IKN9ug37rxeJm-Hr0t7Fw"

    documentation: "https://developers.google.com/youtube/v3/docs/videos?hl=fr"

  soundcloud:
    resolver: "https://api.soundcloud.com/resolve.json?consumer_key="
    content: "&url="
    key: "b45b1aa10f1ac2941910a7f0d10f8e28"

    documentation: "https://developers.soundcloud.com/docs/api/reference"
    
### find from which site is the video ###
get_source = (track, callback) ->
  for index of sources
    if(track.indexOf(index) > -1)
      res = index
  callback(res)

String.prototype.build_url = (source) ->
  src = sources[source]
  src.resolver + src.key + src.content + this

ytParseDuration = (time) ->
  console.log time
  res = ''
  time = time.slice(2)
  iOh = time.indexOf('H')
  if(iOh > -1)
    hours = time.slice(0, iOh)
    time = time.slice(iOh+1)
  iOm = time.indexOf('M')
  if(iOm > -1)
    minutes = time.slice(0, iOm)
    time = time.slice(iOm+1)
  iOs = time.indexOf('S')
  if(iOs > -1)
    seconds = time.slice(0, iOs)

  if seconds < 10
    seconds = '0' + seconds
  if hours > 0 && minutes < 10
    minutes = '0' + minutes
  if hours > 0 && minutes == undefined
    minutes = '00'

  unless minutes == 0 || minutes == undefined
    unless hours >0
      minutes + ':' + seconds
    else
      hours + ':' + minutes + ':' + seconds
  else 
    seconds

convertDuration = (time) ->
  inSeconds = Math.floor(time/1000) #from ms to s
  hours = Math.floor(inSeconds/3600)
  inSeconds = inSeconds - hours * 3600
  minutes = Math.floor(inSeconds / 60)
  seconds = inSeconds - minutes * 60

  if seconds < 10
    seconds = '0' + seconds
  if hours > 0 && minutes < 10
    minutes = '0' + minutes
  unless minutes == 0 || minutes == undefined
    unless hours >0
      minutes + ':' + seconds
    else
      hours + ':' + minutes + ':' + seconds
  else
    seconds

request_url = (url, callback) ->
  request url, (error, response, html) ->
    if error and (response.statusCode!=200)
      console.log "Error:" + err
    else
      callback response.body

infos_yt = (content, callback) ->
  console.log content
  track =  new Track
    title: content.snippet.title
    artist: content.snippet.channelTitle
    url: 'http://www.youtube.com/watch?v=' + content.id
    src: content.id
    service: 'Youtube'
    duration: ytParseDuration content.contentDetails.duration
  console.log track.duration
  callback track

### get the information from the responses and create objects to be stored in our DB ###
infos_sc = (content, callback) ->
  track = new Track
    title: content.title
    artist: content.user.username
    url: content.permalink_url
    src: content.id
    service: 'Soundcloud'
    duration: convertDuration content.duration
  callback track

### manages the actions of dispatching between the different sources ###
dispatch = (track, callback) ->
  get_source track, (src) ->
  	url = null
  	switch src
  	  when "youtube"
  	    # to isolate the video id
        s = track.split("v=")
        if(s[1])
          s = s[1].split("&")
          track = s[0]
        else 
          stop = true
  	  when "soundcloud"
  	  else
        console.log "SOURCE NOT SUPPORTED YET".red
        stop = true
    unless stop
      url = track.build_url(src)
      request_url url, (res) ->
        switch src
          when "youtube"
            parsed = JSON.parse(res)
            if(parsed.pageInfo.totalResults == 0)
              callback {code: 0}
            else
              infos_yt JSON.parse(res).items[0], callback
          when "soundcloud"
            parsed = JSON.parse(res)
            if(parsed.kind == 'track')
              infos_sc JSON.parse(res), callback
            else 
              callback {code: 0}
    else
      callback {code: 0}

exports.dispatch = dispatch
