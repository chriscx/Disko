mongoose = require 'mongoose'
Schema = mongoose.Schema
userSchema = new Schema(
  firstname: String
  lastname: String
  email: String
  password: String
  signupDate:
    type: Date
    default: Date.now
,
  collection: "users"
)
User = mongoose.model("User", userSchema)
module.exports =

  #
  #  get(id, callback)`
  #  ----------------------------
  #
  #  Parameters
  #  `id`       User id
  #  `callback` Contains an err as first argument
  #             if any and data of user (firstname,
  #             lastname, email, signup date)
  #
  get: (id, callback) ->
    User.find
      _id: id
    , "firstname lastname email signupDate", (err, data, numberAffected) ->
      err = null  unless err
      callback err, data
      return

    return


  #
  #  `create(info, callback)`
  #  ----------------------------
  #
  #  Parameters
  #  `info`       JSON object with properties of user (see userSchema)
  #  `callback` Contains an err as first argument
  #             if any
  #
  create: (info, callback) ->
    newUser = new User(info)
    newUser.save (err, newUser, numberAffected) ->
      err = null  unless err
      callback err, newUser
      return

    return


  #
  #  `remove(id, callback)`
  #  ----------------------------
  #
  #  Parameters
  #  `id`       user id as email format
  #  `callback` Contains an err as first argument
  #             if any
  #
  remove: (id, callback) ->
    User.remove(
      _id: id
    , (err, data) ->
      err = null  unless err
      callback err, data
      return
    ).remove()
    return


  #
  #  `checkPassword(email, password, callback)`
  #  ----------------------------
  #
  #  Parameters
  #  `email`       user email
  #  `password`    user password
  #  `callback` Contains an err as first argument
  #             if any and JSON object with boolean
  #             if check is passed and user id.
  #
  #
  checkPassword: (email, password, callback) ->
    User.find
      email: email
    , (err, data) ->
      err = null  unless err
      if data.length > 0
        if data[0].password is password
          callback err,
            check: true
            userId: data[0]._id

        else
          callback err,
            check: false
            userId: null

      else
        callback "User not found."
      return

    return
