require( './main.css' )
var logoPath = require( './assets/logo.svg' )
var loadingWhite = require( "./assets/loading_white.svg" )
var loadingBlue = require( "./assets/loading_blue.svg" );
var Elm = require( './App.elm' )

var root = document.getElementById( 'root' )

Elm.App.embed( root, {
	  logoPath
	, loadingWhite
	, loadingBlue
} )
