mongoose = require 'mongoose'
Schema = mongoose.Schema

playlistSchema = new Schema(
  title: String
  owner: String
  editors: [id: String]
  visibility: String
  content: [assetSchema]
)

Playlist = mongoose.model 'Playlist', playlistSchema

module.exports =
  Playlist:  Playlist
