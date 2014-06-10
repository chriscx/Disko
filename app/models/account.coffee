mongoose = require 'mongoose'
Playlist = require './playlist'
PlaylistSchema = Playlist.Schema
Schema = mongoose.Schema
passportLocalMongoose = require 'passport-local-mongoose'

AccountSchema = new Schema(
  nickname:
  	type: String
  	index: true
  	unique: true
  birthdate: Date
  )

AccountSchema.plugin passportLocalMongoose

Account = mongoose.model 'Account', AccountSchema

module.exports =
  Account: Account
  Schema: AccountSchema
