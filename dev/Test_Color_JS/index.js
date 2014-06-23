var step = 3;
var interval = 300;
var red = 0;
var green = 0;
var blue = 1.57;

//sin method => lots of ressources
// setInterval(function () {
// 	red += step;
// 	blue += step;
// 	var sinRed = Math.floor(Math.sin(red) * 127 + 128);
// 	var sinBlue = Math.floor(Math.sin(blue) * 127 + 128);
// 	$("#bg").css('background-color', 'rgb('+sinRed+',' + sinBlue + ', 0)');
// }, interval);

blue = 0;
red = 100;
var up =true;
setInterval(function () {
	if(up == true)
		green += step;
	else
		green -= step;
	if(green < 0 || green > 100)
		up = !up;
	$("#bg").css('background-color', 'rgb(100%,' + green + '%, 0%)');
	console.log(green);
}, interval);
//stocker dans array pour le 1er cycle puis lire depuis l'array