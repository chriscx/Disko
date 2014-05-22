mongoose = require 'mongoose'
Schema = mongoose.Schema

TrackSchema = new Schema(
  title: String
  artist: String
  addedBy: String
  addedDate: String
  url: String  #url added by user
  src: String  #iframe url of track
  order: Number
)

Track = mongoose.model 'Track', TrackSchema

module.exports =
  Track: Track
  Schema: TrackSchema
