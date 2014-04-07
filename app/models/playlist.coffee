mongoose = require 'mongoose'
AssetSchema = require ('./asset').Schema
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
  Schema: PlaylistSchema
