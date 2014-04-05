mongoose = require 'mongoose'
Schema = mongoose.Schema
assetSchema = new Schema(
  title: String
  author: String
  addedBy: String
  addedDate: String
  url: String
  src: String
)
playlistSchema = new Schema(
  title: String
  owner: String
  editors: [id: String]
  visibility: String
  content: [assetSchema]
)

Playlist = mongoose.model 'Playlist', playlistSchema
Asset = mongoose.model 'Asset', assetSchema

module.exports =
  getList: (callback) ->

  get: (id, callback) ->
    PlayList.find
      _id: id
    , (err, data) ->
      callback err, data
      return

    return

  remove: (id, callback) ->

  update: (id, data, callback) ->

  getSongList: (callback) ->

  addSong: (idPlayList, song, callback) ->

  removeSong: (idPlayList, idSong, callback) ->
