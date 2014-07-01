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

var toAdd = [
    {
      "title" : "Witty - Leave ft. Trippz Michaud (Prod. By Redhooknoodles)",
      "artist" : "WittyOfficial",
      "url" : "http://soundcloud.com/wittyofficial/witty-leave-ft-trippz-michaud-prod-by-redhooknoodles",
      "src" : "155728193",
      "service" : "Soundcloud",
      "duration" : "3:40",
      "addedDate" : "Tue Jun 24 2014 07:59:09 GMT+0200 (CEST)",
      "order" : 0
    },
    {
      "title" : "Coldplay - Viva La Vida",
      "artist" : "parlophone",
      "url" : "http://www.youtube.com/watch?v=dvgZkm1xWPE",
      "src" : "dvgZkm1xWPE",
      "service" : "Youtube",
      "duration" : "4:03",
      "addedDate" : "Tue Jun 24 2014 08:01:58 GMT+0200 (CEST)",
      "order" : 1
    },
    {
      "title" : "Takers feat. Chipper - Alive (Matinée - Amnesia Ibiza 2012)  - Official Video HD",
      "artist" : "VuzMI",
      "url" : "http://www.youtube.com/watch?v=Wy__crtdd9I",
      "src" : "Wy__crtdd9I",
      "service" : "Youtube",
      "duration" : "3:19",
      "addedDate" : "Mon Jun 23 2014 22:34:10 GMT+0200 (CEST)",
      "order" : 2
    },
    {
      "title" : "Ginyu Force (Iglooghost Rmx) - [The ¡itisi! EP Is Out Now! Link In Description.]",
      "artist" : "siryote",
      "url" : "http://soundcloud.com/villagemeister/ginyu-force-iglooghost-rmx",
      "src" : "153302324",
      "service" : "Soundcloud",
      "duration" : "1:32",
      "addedDate" : "Wed Jun 25 2014 21:14:09 GMT+0200 (CEST)",
      "order" : 3
    },
    {
      "title" : "Tinie Tempah - Written In The Stars ft. Eric Turner",
      "artist" : "parlophone",
      "url" : "http://www.youtube.com/watch?v=YgFyi74DVjc",
      "src" : "YgFyi74DVjc",
      "service" : "Youtube",
      "duration" : "3:37",
      "addedDate" : "Tue Jun 24 2014 08:00:17 GMT+0200 (CEST)",
      "order" : 4
    },
    {
      "title" : "Deorro - Live @ EDC Las Vegas 2014",
      "artist" : "EDC Las Vegas 2014*",
      "url" : "http://soundcloud.com/edmchicagorecords/deorro-live-edc-las-vegas-2014",
      "src" : "155596469",
      "service" : "Soundcloud",
      "duration" : "54:35",
      "addedDate" : "Tue Jun 24 2014 07:59:44 GMT+0200 (CEST)",
      "order" : 5
    }
];
for(var track in toAdd) {
  var AssetObj = toAdd[track];
  PlaylistObj.content = PlaylistObj.content.concat(new Array(AssetObj));
}

var newPlaylist = new Playlist(PlaylistObj);
newPlaylist.save(function(err) {
  if(err)
    console.log(err)
  });

console.log(PlaylistObj);





