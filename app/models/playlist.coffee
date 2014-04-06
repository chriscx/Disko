mongoose = require 'mongoose'
Schema = mongoose.Schema

PlaylistSchema = new Schema(
  title: String
  owner: String
  editors: [id: String]
  visibility: String
  content: [assetSchema]
)

Playlist = mongoose.model 'Playlist', PlaylistSchema

module.exports =
  Playlist:  Playlist
