// ==UserScript==
// @name        3dsthemes_anti3ak
// @namespace   chaoskagami
// @description God, that is one sick 15yr old
// @include     https://3dsthem.es/*
// @version     1
// @grant       none
// @run-at document-start
// ==/UserScript==

// Basically, what we do here is as follows:
// * Take over setinterval.
// * Make setinterval search through the function for an identifying characteristic.
// * Run the real setInterval if not found.

// To 3dsthem.es - it is my choice as a user to use adblock. YOU HAVE NO RIGHT TO DICTATE THIS.
// Not to mention, you can't do this in the EU legally.

window.oldInterval = window.setInterval;

// See, we're a hack. We replace setinterval.
window.setInterval = function(fun, time) {
  // This could have false positives, but w/e we'll fix it someday
  var test = fun.toString().search("anti adblock killer");

  if (test > 0) {
    console.log("Anti-AAK detected. Die in a fire.");
    window.pageLoaded = true;
    return 0;
  }

  console.log("Calling setInterval normally.");
  return window.oldInterval(fun, time);
};
