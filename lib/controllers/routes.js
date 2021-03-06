// Generated by CoffeeScript 1.7.1
var Account, Getters, Playlist, Track, passport, path;

path = require('path');

passport = require('passport');

Account = require('../models/account').Account;

Playlist = require('../models/playlist').Playlist;

Track = require('../models/track').Track;

Getters = require('./getter');

module.exports = function(app) {
  app.get(/^\/static(\/.+)/, function(req, res) {
    var dir, file;
    file = req.params[0];
    dir = (path.resolve('#{__dirname}/../public/')) + '/';
    console.log('GET static ' + dir + file);
    return res.sendfile(dir + file);
  });
  app.get('/data/:user/info.json', function(req, res) {
    console.log('GET user info ' + req.params.playlist + ' JSON object');
    return Account.find({
      nickname: req.params.user
    }, function(err, data) {
      if (!(err || data.length < 1)) {
        return res.json({
          result: 'OK',
          content: data
        });
      } else {
        return res.json({
          result: 'error',
          content: null
        });
      }
    });
  });
  app.post('/data/:user/info.json', function(req, res) {
    var newAccount;
    console.log('POST user info ' + req.params.playlist + ' JSON object');
    newAccount = new Account({
      nickname: req.body.nickname,
      birthday: req.body.birthday
    });
    return newAccount.save(function(err) {
      if (!err) {
        return res.json({
          result: 'OK'
        });
      } else {
        return res.json({
          result: 'error',
          err: err
        });
      }
    });
  });
  app.put('/data/:user/info.json', function(req, res) {
    console.log('PUT user info ' + req.params.playlist + ' JSON object');
    return Account.findOneAndUpdate({
      'nickname': req.params.user
    }, req.body, {
      "new": true
    }, function(err, data) {
      if (!err) {
        return res.json({
          result: 'OK'
        });
      } else {
        return res.json({
          result: 'error',
          err: err
        });
      }
    });
  });
  app.del('/data/:user/info.json', function(req, res) {
    console.log('DEL user info ' + req.params.playlist + ' JSON object');
    return Account.remove({
      'nickname': req.params.user
    }, function(err, data) {
      if (data > 0 && !err) {
        return res.json({
          result: 'OK'
        });
      } else {
        return res.json({
          result: 'error',
          err: err
        });
      }
    });
  });
  app.get('/data/playlists.json', function(req, res) {
    console.log('GET playlist ' + req.params.id + ' JSON object');
    return Playlist.find({}, function(err, data) {
      if (!err) {
        console.log(data);
        return res.json({
          result: 'OK',
          content: data
        });
      } else {
        return res.json({
          result: 'error',
          content: null
        });
      }
    });
  });
  app.get('/data/:user/:playlist.json', function(req, res) {
    console.log('GET playlist ' + req.params.playlist + ' JSON object');
    return Playlist.find({
      'id': req.params.id,
      'owner': req.params.user
    }, function(err, data) {
      if (!err) {
        return res.json({
          result: 'OK',
          content: data
        });
      } else {
        return res.json({
          result: 'error',
          content: null
        });
      }
    });
  });
  app.post('/data/:user/:playlist.json', function(req, res) {
    var arr, newPlaylist, track, _i, _len, _ref;
    console.log('POST playlist ' + req.params.playlist + ' JSON object');
    arr = [];
    _ref = req.body.content.length;
    for (_i = 0, _len = _ref.length; _i < _len; _i += 1) {
      track = _ref[_i];
      arr.push(new Track(track));
    }
    newPlaylist = new Playlist({
      title: req.body.title,
      id: req.body.id,
      owner: req.body.owner,
      editors: req.body.editors,
      visibility: req.body.visibility,
      content: arr,
      creationDate: req.body.creationDate,
      modificationDate: req.body.modificationDate
    });
    return newPlaylist.save(function(err) {
      if (!err) {
        return res.json({
          result: 'OK'
        });
      } else {
        return res.json({
          result: 'error',
          err: err
        });
      }
    });
  });
  app.put('/data/:user/:playlist.json', function(req, res) {
    console.log('PUT playlist ' + req.params.playlist + ' JSON object');
    return Playlist.findOneAndUpdate({
      'id': req.params.playlist,
      'owner': req.params.user
    }, req.body, {
      "new": true
    }, function(err, data) {
      console.log(data);
      if (!err) {
        return res.json({
          result: 'OK'
        });
      } else {
        return res.json({
          result: 'error',
          err: err
        });
      }
    });
  });
  app.del('/data/:user/:playlist.json', function(req, res) {
    console.log('DEL playlist ' + req.params.playlist + ' JSON object');
    return entry.remove({
      'id': req.params.id,
      'owner': req.params.user
    }, function(err, data) {
      if (data > 0 && !err) {
        return res.json({
          result: 'OK'
        });
      } else {
        return res.json({
          result: 'error',
          err: err
        });
      }
    });
  });
  app.get('/data/getter/:playlist', function(req, res) {
    return Getters.dispatch(req.query.url, function(data) {
      return res.send(data);
    });
  });
  app.get('/signup', function(req, res) {
    return res.render('signup', {
      title: 'Disko'
    });
  });
  app.post('/signup', function(req, res) {
    return Account.register(new Account({
      username: req.body.username
    }), req.body.password, function(err, account) {
      if (err) {
        res.render('signup', {
          info: "Sorry. That username already exists. Try again."
        });
      }
      return passport.authenticate('local', function(req, res) {
        return res.redirect('/');
      });
    });
  });
  app.get('/login', function(req, res) {
    return res.render('login', {
      title: 'Disko'
    });
  });
  app.post('/login', passport.authenticate('local', function(req, res) {
    return res.redirect('/');
  }));
  app.get('/logout', function(req, res) {
    req.logout();
    return res.redirect('/');
  });
  app.get('/ping', function(req, res) {
    return res.send('pong!', 200);
  });
  app.get('/error/:error', function(req, res) {
    return res.render('error');
  });
  app.get('/:user', function(req, res) {
    console.log('GET user ' + req.params.playlist + ' view');
    return res.render('player');
  });
  return app.get('/:user/:playlist', function(req, res) {
    console.log('GET playlist ' + req.params.playlist + ' view');
    return res.render('player');
  });
};
