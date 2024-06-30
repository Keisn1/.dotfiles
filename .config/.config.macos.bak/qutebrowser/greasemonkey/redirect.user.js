// ==UserScript==
// @name youtube to piped.video
// @namespace youtube script
// @match http://youtube.com/*
// @match https://youtube.com/*
// @match http://www.youtube.com/*
// @match https://www.youtube.com/*
// @match https://music.youtube.com/*
// @run-at document-start
// ==/UserScript==
url = location.href
url = url.replace(/\bwww.\b/, “”)
url = url.replace(“youtube.com”,“piped.video”)
location.href = url
