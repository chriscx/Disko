mongoose = require 'mongoose'
Track = require './track'
TrackSchema = Track.Schema
Schema = mongoose.Schema

PlaylistSchema = new Schema(
  title: String
  id: String
  owner: String
  editors: [id: String]
  visibility: String
  content: [TrackSchema]
  creationDate: Date
  modificationDate: Date
)

Playlist = mongoose.model 'Playlist', PlaylistSchema

module.exports =
  Playlist: Playlist
  Schema: PlaylistSchema
