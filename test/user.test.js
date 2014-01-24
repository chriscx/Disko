var should, user, mongoose, connexion;

mongoose  = require('mongoose');
mongoose.connect('mongodb://localhost/fluiddb');
should = require('should');
user = require('../lib/user');

describe("user", function() {

  before(function() {
    if(!mongoose.connection.readyState){
      mongoose.connect('mongodb://localhost/fluiddb_test');
    }
  })

  after(function() {
    mongoose.disconnect();
  });

  it("should have the blog properties", function(next) {
    user.should.have.properties('get');
    user.should.have.properties('create');
    user.should.have.properties('remove');
    user.should.have.properties('checkPassword');
    next();
  })

  it("create & delete a user", function(next) {
    var newUser = { 
      firstname: "firstname",
      lastname: "lastname",
      email: "firstname.lastname@fluid.org",
      password: "password",
      signupDate: new Date(),
    };

    return user.create(newUser, function(err, createdUser) {
      should.not.exist(err);
      if(err) {
        return next(err);
      }
      user.get(createdUser._id, function(err, retrievedUser) {
        should.not.exist(err);
        if(err) {
          return next(err);
        }
        retrievedUser[0].email.should.eql("firstname.lastname@fluid.org");
        var id = retrievedUser[0]._id;
        user.remove(id, function(err, deletedUser) {
          should.not.exist(err);
          if(err) {
            return next(err);
          }
          user.get(id, function(err, data) {
            should.not.exist(err);
            if(err){
              return next(err);
            }
            data.should.be.empty;
            next();
          })
        })
      });
    });
  });

  it("checks the password", function(next) {
    var newUser = { 
      firstname: "firstname",
      lastname: "lastname",
      email: "firstname.lastname@fluid.org",
      password: "password",
      signupDate: new Date(),
    };

    return user.create(newUser, function(err, createdUser) {
      should.not.exist(err);
      if(err) {
        return next(err);
      }
      user.checkPassword("firstname.lastname@fluid.org", "fakepassword", function(err, res) {
        should.not.exist(err);
        res.check.should.not.be.ok;

        user.checkPassword("fakeemail", "fakepassword", function(err, res) {
          should.exist(err);
          
          user.checkPassword("firstname.lastname@fluid.org", "password", function(err, res) {
            should.not.exist(err);
            if(err) {
              return next(err);
            }
            res.should.have.property('check');
            res.check.should.be.ok;
            user.get(createdUser._id, function(err, retrievedUser) {
              should.not.exist(err);
              if(err) {
                return next(err);
              }
              retrievedUser[0].email.should.eql("firstname.lastname@fluid.org");
              var id = retrievedUser[0]._id;
              user.remove(id, function(err, deletedUser) {
                should.not.exist(err);
                if(err) {
                  return next(err);
                }
                user.get(id, function(err, data) {
                  should.not.exist(err);
                  if(err){
                    return next(err);
                  }
                  data.should.be.empty;
                  next();
                })
              })
            });
          });
        });
      });
    });
  });
});