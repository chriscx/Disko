mongoose = require 'mongoose'
Schema = mongoose.Schema

TrackSchema = new Schema(
  title: String
  author: String
  addedBy: String
  addedDate: String
  url: String
  src: String
  order: Number
)

Track = mongoose.model 'Track', TrackSchema

module.exports =
  Track: Track
  Schema: TrackSchema
