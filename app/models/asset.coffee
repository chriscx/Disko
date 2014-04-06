mongoose = require 'mongoose'
Schema = mongoose.Schema

AssetSchema = new Schema(
  title: String
  author: String
  addedBy: String
  addedDate: String
  url: String
  src: String
)

Asset = mongoose.model 'Asset', AssetSchema

module.exports =
  Asset: Asset
