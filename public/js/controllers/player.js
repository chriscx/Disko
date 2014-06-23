var DiskoApp = angular.module('DiskoApp', ['ui.bootstrap']);

DiskoApp.service('playlistService', function() {

});

DiskoApp.service('playerService', function() {

});

DiskoApp.service('userService', function() {

});

DiskoApp.controller('playerController', function($scope, $sce) {

  $scope.isCollapsed = false;

  $.get('/data/playlists.json', function(data) {
    $scope.$apply(function(){
      $scope.playlist = {};
      $scope.playlist.owner = data.content[0].owner;
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
  $scope.playing.soundcloud = 'https://w.soundcloud.com/player/?auto_play=false&amp;hide_related=false&amp;visual=true&amp;url=https%3A//api.soundcloud.com/tracks/';
  $scope.playing.youtube = 'http://www.youtube.com/embed/'; 
  $scope.playing.current = $sce.trustAsResourceUrl($scope.playing.youtube + '5RdjiJP4yg4');
  $scope.playing.changeTrack = function(track) {
    console.log(track);
    $scope.playing.current = $sce.trustAsResourceUrl($scope.playing[track.service.toLowerCase()] + track.src);
  };
});
//http://jqueryui.com/sortable/
//http://stackoverflow.com/questions/5957916/how-to-handle-youtube-video-events-started-finished-etc-in-uiwebview-ios
//from shufflecloud 
//DONT FORGET script(src="http://connect.soundcloud.com/sdk.js")
// var tracks = null;
// var id = 0;
// var precedent_action = 'next';
// var playing = null;

// function getXMLHttpRequest() {
//   var xhr = null;
//   if (window.XMLHttpRequest || window.ActiveXObject) {
//     if (window.ActiveXObject) {
//       try {
//         xhr = new ActiveXObject("Msxml2.XMLHTTP");
//       } catch(e) {
//         xhr = new ActiveXObject("Microsoft.XMLHTTP");
//       }
//     } else {
//       xhr = new XMLHttpRequest(); 
//     }
//   } else {
//     alert("Pas d'Ajax, dommage!");
//     return null;
//   }
//   return xhr;
// }

// //asynchronous call to the update process
// function shuffle(exist_url) {
//   stop_all();

//   var req = getXMLHttpRequest();
//   //var url ='https://soundcloud.com/florian-quattrocchi/sets/chiiiilllll';
//   if(exist_url == null)
//     var url = document.getElementById("url").value;
//   else 
//     var url = exist_url;

//   req.onreadystatechange = function() {
//     if (req.readyState == 4 && (req.status == 200 )) {
      
//       if(req.responseText == "This is not a playlist" || req.responseText == "Add an URL") {

//         document.getElementById("div_url").className = "form-group has-feedback has-error";  
//         document.getElementById("span_glyph_url").className = "glyphicon glyphicon-remove form-control-feedback";

//         document.getElementById("button_error").className = "btn btn-danger pull-right";
//         document.getElementById("button_error").innerHTML = req.responseText;
//       } else {
//         if(( navigator.userAgent.match(/(iPad|iPhone|iPod)/g) ? true : false )) {
//           document.getElementById("iphone_play").className = "row";    
//         }
//         document.getElementById("div_url").className = "form-group has-feedback";  
//         document.getElementById("span_glyph_url").className = "hidden";

//         document.getElementById("button_error").className = "btn btn-success pull-right";
//         document.getElementById("button_error").innerHTML = "Playlist shuffled"
        
//         tracks = JSON.parse(req.responseText);
//         list_played();
//         next();
//       }
//     }
//   };
//   req.open("GET", "add.php?url=" + url , true);
//   req.send(null);
// }

// function playTrack() { 
//   display_control();

//   SC.stream("/tracks/" + tracks[id]['sc_id'], {

//     onfinish: function(){ 
//       next();
//     }
//   }, function(sound){
    
//     playing = sound.id;
//     sound.start();
//   });   
// }

// function next(){
//   play();
//   soundManager.stopAll();

//   if(precedent_action == 'previous')
//     id++;
//   playTrack();
//   precedent_action = 'next';
//   if(id != tracks.length)
//     id++;
//   else 
//     stop_all();
// }
// function previous(){
//   play();
//   soundManager.stopAll();

//   if(id>0)
//     id--;
//   playTrack();
//   precedent_action = 'previous';
// }

// function play(){
//   soundManager.resume(playing);

//   document.getElementById("img_play").className = "hidden";
//   document.getElementById("img_pause").className = "";
// }
// function pause(){
//   soundManager.pause(playing);

//   document.getElementById("img_play").className = "";
//   document.getElementById("img_pause").className = "hidden";
// }
// function stop_all() {
//   soundManager.stopAll();
//   id = 0;
//   hide_control();
// }

// function display_control(){
//   document.getElementById("div_control_panel").className = "row";
//   document.getElementById("img_artwork").src = tracks[id]['picture'];
//   document.getElementById("track_name").innerHTML = tracks[id]['title'] + ' - <i>by</i> ' + tracks[id]['artist'];
// }

// function hide_control(){
//   document.getElementById("div_control_panel").className = "hidden";
// }

// function hide_play_iphone() {
//   id--;
//   next();
//   document.getElementById("iphone_play").className = "hidden";  
// }



// function list_played() {

//   var req = getXMLHttpRequest();

//   req.onreadystatechange = function() {
//     if (req.readyState == 4 && (req.status == 200 )) {
//       var result = JSON.parse(req.responseText);

//       if(document.getElementById("list_top"))
//         document.getElementById("list_top").remove();
//       if(document.getElementById("list_low"))
//         document.getElementById("list_low").remove();

//       var listTop = document.createElement("ol");
//       listTop.id = "list_top";
//       var listLow = document.createElement("ol");
//       listLow.id = "list_low";
      
//       for( var i =  0 ; i < Math.min(result.length, 5) ; i++){
//         var listItem = document.createElement("li");
//         listItem.innerHTML = '<a href="javascript:shuffle(\'' + result[i][0] + '\')">' + result[i][1] + '</a>';
//         listTop.appendChild(listItem);
//       }
//       for(var i =  result.length-1 ; i >= Math.max(result.length-5, 0) ; i--){
//         var listItem = document.createElement("li");
//         listItem.innerHTML = '<a href="javascript:shuffle(\'' + result[i][0] + '\')">' + result[i][1] + '</a>';
//         listLow.appendChild(listItem);
//       }

//       document.getElementById("col_top").appendChild(listTop);
//       document.getElementById("col_low").appendChild(listLow);

//     }
//   };
//   req.open("GET", "get_lists.php", true);
//   req.send(null);


// }