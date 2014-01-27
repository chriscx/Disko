var mongoose;

mongoose  = require('mongoose');

var Schema = mongoose.Schema;

var assetSchema = new Schema({
  title: String,
  author: String,
  addedBy: String,
  addedDate: String,
  url: String,
  src: String
});

var playlistSchema = new Schema({
  title: String,
  owner: String,
  editors: [{id: String}],
  visibility: String,
  content: [assetSchema]
})

var Playlist = mongoose.model('Playlist', playlistSchema);

module.exports = {
	getList: function(callback) {

	},

	get: function(id, callback) {

	},

	remove: function(id, callback) {

	},

	update: function(id, data, callback) {

	},

	getSongList: function(callback) {

	},

	addSong: function(idPlayList, song, callback) {

	},

	removeSong: function(idPlayList, idSong, callback) {

	}
}