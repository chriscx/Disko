var DiskoApp = angular.module('DiskoApp', ['ui.sortable', 'ui.bootstrap']);

DiskoApp.service('playlistService', function() {

});

DiskoApp.service('playerService', function() {

});

DiskoApp.service('userService', function() {

});

DiskoApp.controller('playerController', function($scope, $sce) {

  var socket = io.connect('http://localhost');
  socket.emit('join_playlist_room', {room: 'playlist1'});
  socket.on('action_playlist', function(data) {
    console.log(data.room);
    console.log(data.content);
  });

  $scope.isCollapsed = false;

  $.get('/data/playlists.json', function(data) {
    $scope.$apply(function(){
      console.log(data);
      $scope.playlist = {};
      $scope.playlist.owner = data.content[0].owner;
      $scope.playlist.name = data.content[0].id;
      $scope.playlist.content = data.content[20].content;
      //initialize the player
      //$scope.playing.changeTrack(data.content[0].content[0]);
      $scope.playing.init(data.content[0].content[0]);

    });
  });

  $scope.sortableOptions = {
    activate: function() {
        console.log("activate");
    },
    beforeStop: function() {
        console.log("beforeStop");
    },
    change: function() {
        console.log("change");
    },
    create: function() {
        console.log("create");
    },
    deactivate: function() {
        console.log("deactivate");
    },
    out: function() {
        console.log("out");
    },
    over: function() {
        console.log("over");
    },
    receive: function() {
        console.log("receive");
    },
    remove: function() {
        console.log("remove");
    },
    sort: function() {
        console.log("sort");
    },
    start: function() {
        console.log("start");
    },
    update: function(e, ui) {
      // console.log("update");
      //
      // var logEntry = tmpList.map(function(i){
      //   return i.value;
      // }).join(', ');
      // $scope.sortingLog.push('Update: ' + logEntry);
    },
    stop: function(e, ui) {
      console.log("stop");
      //
      // // this callback has the changed model
      // var logEntry = tmpList.map(function(i){
      //   return i.value;
      // }).join(', ');
      // $scope.sortingLog.push('Stop: ' + logEntry);

      console.log($scope.playlist.content)
      socket.emit('action_playlist', {room: 'playlist1', content: $scope.playlist})
    }
  };

  $scope.addNewTrack = function() {
    //toastr options -> put in another file ?
    toastr.options = {
      "closeButton": false,
      "debug": false,
      "positionClass": "toast-top-right",
      "onclick": null,
      "showDuration": "300",
      "hideDuration": "700",
      "timeOut": "3000",
      "extendedTimeOut": "1000",
      "showEasing": "swing",
      "hideEasing": "linear",
      "showMethod": "fadeIn",
      "hideMethod": "fadeOut"
    }
    toastr.options.onHidden = function() {
      $("span.glyphicon.form-control-feedback").addClass("hide");
      $("div.form-group.has-feedback").removeClass("has-success has-warning");
      $scope.$apply(function() {
        $scope.newTrackUrl = null;
      });
    };
    $("div.form-group.has-feedback").removeClass('has-error has-success has-warning');
    $("span.glyphicon.form-control-feedback").removeClass("glyphicon-ok glyphicon-remove hide");

    if($scope.newTrackUrl == undefined) {
        $("span.glyphicon.form-control-feedback").addClass("glyphicon-remove");
        $("div.form-group.has-feedback").addClass("has-error");
    } else {

      $.get('/data/getter/' + $scope.playlist.name, {url: $scope.newTrackUrl}, function(answer) {
        if(answer.code != 0) {
          $scope.appendTrack(answer);
          $scope.savePlaylist();
        }
        else {
          $("span.glyphicon.form-control-feedback").addClass("glyphicon-remove");
          $("div.form-group.has-feedback").addClass("has-error");
        }
      });
    }
  };
  $scope.appendTrack = function (track) {
    var stop = false;
    $scope.playlist.content.forEach(function(element, index) {
      if(track.src == element.src)
        stop = true;
    });
    if(!stop) {
      track.addedDate = new Date();
      track.addeBy = 'user';  //TEMP
      track.order = ($scope.playlist.content).length;
      //Notifications
      toastr.success('Track added to the playlist');
      $("span.glyphicon.form-control-feedback").addClass("glyphicon-ok");
      $("div.form-group.has-feedback").addClass("has-success");
      $scope.$apply(function() {
        $scope.playlist.content.push(track);
      });
    } else {
      $("div.form-group.has-feedback").addClass("has-warning");
      $("span.glyphicon.form-control-feedback").addClass("glyphicon-remove");
      toastr.warning("Track already in playlist");
    }
  };

  $scope.savePlaylist = function() {
    $.ajax({
      type: "PUT",
      url: '/data/' + $scope.playlist.owner + '/' + $scope.playlist.name + '.json',
      data: {content: $scope.playlist.content}
    });
    console.log("Saving playlist: " + $scope.playlist.name);
    toastr.success('YESSS');
  };
  //manages the player
  $scope.playing = {};
  $scope.playing.soundcloud = 'http://api.soundcloud.com/tracks/';
  $scope.playing.youtube = 'http://www.youtube.com/embed/';
  $scope.playing.currentURL = null;
  $scope.playing.currentTrack = null;
  $scope.playing.scWidget = null;
  $scope.playing.isSC = false;

  $scope.playing.init = function (track) {
    $scope.playing.currentTrack = track;

    if(track.service == 'Soundcloud'){
      $scope.playing.isSC = true;
      $('#scPlayer').attr('src', 'https://w.soundcloud.com/player/?visual=true&url=http://api.soundcloud.com/tracks/' + track.src);
    }

    $('#scPlayer').load(function(){ //binds events when the iframe is loaded
      console.log("LOADED");

      var iframeElement   = document.querySelector('#scPlayer');
      $scope.playing.scWidget = SC.Widget(iframeElement);

      $scope.playing.scWidget.bind(SC.Widget.Events.FINISH, function(){ //ADDS ACTION for terminating song
        if($scope.playlist.content.length > parseInt($scope.playing.currentTrack.order)+1 && $scope.playing.isSC){ //stops if no more track
          $scope.$apply(function () {
            $scope.playing.changeTrack($scope.playlist.content[parseInt($scope.playing.currentTrack.order) + 1]);
          });
          console.log('TERMINATED');
        }
        else
          console.log('STOP');
      });
    });
  };

  $scope.playing.changeTrack = function(track) {
    console.log('NEXT TRACK');
    console.log(track);
    $scope.playing.currentTrack = track;

    if(track.service == 'Soundcloud') {
      $scope.playing.isSC = true;

      console.log('CASE sc');
      $scope.playing.scWidget.load($scope.playing.soundcloud + track.src, {
        visual: true
      });
    }
    if(track.service == 'Youtube') {
      $scope.playing.isSC = false;
      console.log('CASE yt');

      player = new YT.Player('ytPlayer', {
        width: '100%',
        height: 400,
        playerVars: {
          autohide: 1
        },
        videoId: track.src,
        events: {
          'onReady': function (event) {
            event.target.playVideo();
          },
          'onStateChange': function (event) {
            if(event.data == 0)
              console.log('TERMINATED');
          }
        }
      });

    }
    //$scope.playing.currentURL = $sce.trustAsResourceUrl($scope.playing[track.service.toLowerCase()] + track.src);
  };

  //buttons to control the tracks
  //docs soundcloud => http://developers.soundcloud.com/docs/api/html5-widget#events
  $scope.buttons = {};
  $scope.buttons.play = function () {
    if($scope.playing.currentTrack.service == 'Soundcloud')
      $scope.playing.scWidget.play();
  };

});
    // function onYouTubeIframeAPIReady() {
    //     console.log('here');
    //     var player;
    //     player = new YT.Player('player', {
    //       width: 1280,
    //       height: 720,
    //       videoId: 'M7lc1UVf-VE',
    //       events: {
    //         'onReady': onPlayerReady
    //       }
    //     });
    //   }

      function onPlayerReady(event) {
        event.target.setVolume(100);
        event.target.playVideo();
      }
