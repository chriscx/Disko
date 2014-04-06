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

Asset = mongoose.model 'Asset', assetSchema

module.exports =
  Asset: Asset
