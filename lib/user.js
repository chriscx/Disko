var mongoose;

mongoose  = require('mongoose');

var Schema = mongoose.Schema;

var userSchema = new Schema({
  firstname: String,
  lastname: String,
  email: String,
  password: String,
  signupDate: { type: Date, default: Date.now },
}, {collection: 'users'});

var User = mongoose.model('User', userSchema);

module.exports = {

  /*
  get(id, callback)`
  ----------------------------
  
  Parameters
  `id`       User id
  `callback` Contains an err as first argument 
             if any and data of user (firstname,
             lastname, email, signup date)
  */

  get: function(id, callback) {
    User.find({_id: id}, 'firstname lastname email signupDate', function(err, data, numberAffected) {
      if(!err) {
        err = null;
      }
      callback(err, data);
    })
  },

  /*
  `create(info, callback)`
  ----------------------------
  
  Parameters
  `info`       JSON object with properties of user (see userSchema)
  `callback` Contains an err as first argument 
             if any
  */

  create: function(info, callback) {
    var newUser = new User(info);
    newUser.save(function(err, newUser, numberAffected) {
      if(!err) {
        err = null;
      }
      callback(err, newUser);
    });
  },

  /*
  `remove(id, callback)`
  ----------------------------
  
  Parameters
  `id`       user id as email format
  `callback` Contains an err as first argument 
             if any
  */

  remove: function(id, callback) {
    User.remove({'_id' : id}, function (err, data) {
      if(!err) {
        err = null;
      }
      callback(err, data);
    }).remove();
  },

    /*
  `checkPassword(email, password, callback)`
  ----------------------------
  
  Parameters
  `email`       user email
  `password`    user password
  `callback` Contains an err as first argument 
             if any and JSON object with boolean 
             if check is passed and user id.

  */

  checkPassword: function(email, password, callback) {
    User.find({'email' : email}, function (err, data) {
      if(!err) {
        err = null;
      }
      if (data.length > 0) {
        if (data[0].password === password) {
          callback(err, {check: true, userId: data[0]._id});
        } else {
          callback(err, {check: false, userId: null});
        }
      }
      else {
        callback("User not found.")
      }
    })
  }
};
