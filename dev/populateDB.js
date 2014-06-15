var blog, mongoose, Playlist;

mongoose  = require('mongoose');
eventEmitter = require('events').EventEmitter;

Playlist = require ('../lib/models/playlist').Playlist;
PlaylistSchema = require ('../lib/models/playlist').Schema;

Asset = require ('../lib/models/asset').Asset;
AssetSchema = require ('../lib/models/asset').Schema;

mongoose.connect('mongodb://localhost/disko_dev');

convertToSlug = function(Text)
{
    return Text
        .toLowerCase()
        .replace(/ /g,'-')
        .replace(/[^\w-]+/g,'')
        ;
};

var PlaylistObj = {
  title: 'Playlist n° 1',
  id: convertToSlug('Playlist n° 1'),
  owner: 'admin',
  visibility: 'public',
  content: new Array(),
  creationDate: new Date(),
  modificationDate: new Date()
}

for(var i = 0; i < 20; i++) {
  var AssetObj = {
    title: 'Title n° ' + (i + 1),
    author: 'somebody',
    addedBy: 'somebody',
    addedDate: new Date(),
    url: 'www.dzfzeg.fef',
    src: 'dzzdfaev',
    order: i,
    service: 'Soundcloud'
  }

  PlaylistObj.content = PlaylistObj.content.concat(new Array(AssetObj));
}

var newPlaylist = new Playlist(PlaylistObj);
newPlaylist.save(function(err) {
  if(err)
    console.log(err)
  });

console.log(PlaylistObj);
