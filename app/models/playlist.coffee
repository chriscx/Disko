mongoose = require 'mongoose'
Asset = require './asset'
AssetSchema = Asset.Schema
Schema = mongoose.Schema

PlaylistSchema = new Schema(
  title: String
  owner: String
  editors: [id: String]
  visibility: String
  content: [AssetSchema]
  creationDate: Date
  modificationDate: Date
)

Playlist = mongoose.model 'Playlist', PlaylistSchema

module.exports =
  Playlist: Playlist
  Schema: PlaylistSchema
