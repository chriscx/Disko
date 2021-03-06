// Generated by CoffeeScript 1.7.1
var Asset, AssetSchema, Schema, mongoose;

mongoose = require('mongoose');

Schema = mongoose.Schema;

AssetSchema = new Schema({
  title: String,
  author: String,
  addedBy: String,
  addedDate: String,
  url: String,
  src: String,
  order: Number
});

Asset = mongoose.model('Asset', AssetSchema);

module.exports = {
  Asset: Asset,
  Schema: AssetSchema
};
