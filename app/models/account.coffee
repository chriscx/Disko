mongoose = require 'mongoose'
PlaylistSchema = require ('./playlist').Schema
Schema = mongoose.Schema
passportLocalMongoose = require 'passport-local-mongoose';

AccountSchema = new Schema(
  nickname: 
  	type: String
  	index: true
  	unique: true
  birthdate: Date
  playlists: [PlaylistSchema]
  )

Account.plugin passportLocalMongoose

Account = mongoose.model 'Account', AccountSchema

module.exports =
  Account: Account
