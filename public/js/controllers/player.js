var DiskoApp = angular.module('DiskoApp', ['ui.bootstrap']);

DiskoApp.service('playlistService', function() {

});

DiskoApp.service('playerService', function() {

});

DiskoApp.service('userService', function() {

});

DiskoApp.controller('playerController', function($scope) {

  $scope.isCollapsed = false;

  $.get('/data/playlists.json', function(data) {
    $scope.$apply(function(){
      $scope.playlist = {};
      $scope.playlist.name = data.content[0].id;
      $scope.playlist.content = data.content[0].content;
    });
  });

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
      track.addedDate = moment().format();
      console.log(moment().format());
      track.addeBy = 'user';
      track.order = ($scope.playlist.content).length;
      toastr.success('Track added to the playlist');
      $("span.glyphicon.form-control-feedback").addClass("glyphicon-ok");
      $("div.form-group.has-feedback").addClass("has-success");
      $scope.$apply(function() {
        $scope.playlist.content.push(track);
        console.log($scope.playlist.content);
      });
    } else {
      $("div.form-group.has-feedback").addClass("has-warning");
      $("span.glyphicon.form-control-feedback").addClass("glyphicon-remove");
      toastr.warning("Track already in playlist");
    }
  };

  $scope.savePlaylist = function() {
    console.log("Saving playlist: " + $scope.playlist.name);
  };
});