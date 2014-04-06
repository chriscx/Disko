mongoose = require 'mongoose'

Schema = mongoose.Schema
passportLocalMongoose = require 'passport-local-mongoose';

AccountSchema = new Schema(
  nickname: String,
  birthdate: Date
  )

Account.plugin passportLocalMongoose

Account = mongoose.model 'Account', AccountSchema

module.exports =
  Account: Account
