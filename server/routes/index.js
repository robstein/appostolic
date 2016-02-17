'use strict';

var express = require('express');
var router = express.Router();
var dateData = require('../dal').getDateData;

var request = require('request');
var cheerio = require('cheerio');
var fs = require('fs')
var async = require('async');
var sleep = require('sleep');


function DayModel(dayID) {
	var self = this;
	self.dayID = dayID;
	self.title = '';
	self.lectionary = '';
    self.readings = [];
    self.liturgyOfTheHours = [];
    self.saints = [];
}

function Reading() {
	var self = this;
	self.name = '';
	self.passage = '';
	self.body = '';
}

/* Helper method to turn a given date into a representative string id
 */
function getDateStr(theDate) {
	var month, day, year, dateStr;
	month = (theDate.getMonth() + 1).toString();
	month = (month.length == 2) ? month : "0"+month; // MM
	day = theDate.getDate().toString();
	day = (day.length == 2) ? day : "0"+day; // DD
	year = theDate.getFullYear().toString().substr(2) // YY
	dateStr = month + day + year;
	return dateStr;
}


function stephenSpiral(array) {
	var string = '';
	var height = array.length;
	var width = array[0].length;
	var totalCount = width * height;
	var x = 0, y = 0, direction = 0, count = 0;
	var rightBorder = 0, bottomBorder = 0, leftBorder = 0, topBorder = 1;

	function canGo(direction, width, height) {
		return function(x,y,dir) {
			if (dir !== direction)
				return false;
			else if (direction == 0)
				return x+1 < width;
			else if (direction == 1)
				return y+1 < height;
			else if (direction == 2)
				return x > 0;
			else if (direction == 3)
				return y > 0;
		}
	};

  var canGoRight = canGo(0,width,height)
	  , canGoDown = canGo(1,width,height)
	  , canGoLeft = canGo(2,width,height)
	  , canGoUp = canGo(3,width,height);

  while (true) {
		string += array[y][x];

		if (canGoRight(x,y,direction)) {
			if (++x == width-1-rightBorder) {
				direction = (direction + 1) % 4;
				rightBorder += 1;
			}
		} else if (canGoDown(x,y,direction)) {
			if (++y == height-1-bottomBorder) {
				direction = (direction + 1) % 4;
				bottomBorder += 1;
			}
		} else if (canGoLeft(x,y,direction)) {
			if (--x == 0+leftBorder) {
				direction = (direction + 1) % 4;
				leftBorder += 1;
			}
		} else if (canGoUp(x,y,direction)) {
			if (--y == 0+topBorder) {
				direction = (direction + 1) % 4;
				topBorder += 1;
			}
		}
		if (++count == totalCount) break;
	}

	return string;
}

router.get('/stephenSpiral', function(req, res, next) {
	var array = [['0','1','2','3'],
							 ['h','i','j','4'],
						   ['g','r','k','5'],
						   ['f','q','l','6'],
						   ['e','p','m','7'],
					     ['d','o','n','8'],
				       ['c','b','a','9']];
	var string = stephenSpiral(array);
	console.log(string);
	res.send({result:string});
});


/* GET root */
/* This function takes the number of milliseconds since 00:00:00 (local time) on 1 January 1970.
   It converts that to the key with which we use to store day value data: MMDDYY
*/
router.get(/^\/\d+$/, function(req, res, next) {
	var millisecondsSince1970, theDate, dateStr;
	millisecondsSince1970 = parseInt(req.path.substr(1));
	theDate = new Date(millisecondsSince1970); // What time zone should assume the user is in?
	console.log(theDate)
	dateStr = getDateStr(theDate);
	var jsonFilename = './readings/' + dateStr + '.json';
	fs.readFile(jsonFilename, 'utf8', function (err, data) {
		if (err) res.send({message:"There was an error."});
		console.log("Reading from " + jsonFilename);
		var obj = JSON.parse(data);
		res.send(obj);
	});
});

/* Helper method to extra data from cheerio obj into a DayModel object
 */
function getReadings($, dateStr, callback) {
  callback = (typeof callback === 'function') ? callback : function() {};
  var day = new DayModel(dateStr);

  var titleAndLectionary = $('div.CS_Element_Textblock').find('h3').html();
	if (titleAndLectionary !== null) {
		var array = titleAndLectionary.split("<br>");
	  day.title = array[0];
	  day.lectionary = array[1];
	} else {
		console.log("NOT SURE 2: " + titleAndLectionary);
	}

  var array = new Array();
  var offset = 0;
  $('div.CS_Element_Textblock').find('div.bibleReadingsWrapper').each(function(i, elem) {
		// It makes way more sense to only have 1 <h4>name/passage</h4> per div, but sometimes there are some <h4>s embedded inside divs.
		var thisDiv = $(this).find('div');
		var nameAndPassages = $(this).find('h4');

		// For each <h4> tag (nameAndPassage), we extract the name (eg. Reading 1 or 2, etc) and the passage (eg. Mk 1:2)
		var myArrayNameAndPassages = [];
		nameAndPassages.each(function(ii, elem) {
			myArrayNameAndPassages.push($(this));

		  var reading  = new Reading();

	  	var passage = $(this).find('a');
			var passageHtml = passage.html();
			if (passageHtml !== null) {
					reading.passage = passage.html().trim();
			}

		  passage.remove(); // We need to remove this tag so we can grab the rest of the h4 tab which constitutes the reading name
		  reading.name = $(this).html().trim();

		  array.push(reading);
	  });

		// Let's get the count of <h4>s, and we'll split up thisReading
		var length = nameAndPassages.length;
		var myBody = thisDiv.html();
		if (length > 1) {
			var aChar = 'a';
			for (var ii = length - 1; ii >= 0; ii--) {
				var theSplit = myBody.split(myArrayNameAndPassages[ii])
				var theSecondSplitComponent = (typeof theSplit[1] == 'undefined') ? myBody : theSplit[1];
				var thisName = myArrayNameAndPassages[ii].html().trim();
				if (thisName === 'or') {
					aChar = String.fromCharCode(aChar.charCodeAt(0) + 1)
					thisName = myArrayNameAndPassages[ii-1].html().trim() + aChar;
				}
				myArrayNameAndPassages[ii] = thisName;
				myBody = theSplit[0];
				array[i+ii].name = thisName.trim();
				array[i+ii].body = theSecondSplitComponent.trim();
			}
			offset += length-1;
		} else {
		  nameAndPassages.remove(); // Remove the nameAndPassages tags to get the reading body by itself
			if (thisDiv.html() !== null) {
				array[i+offset].body = thisDiv.html().trim();
			} else {
				console.log("NOT SURE 1: " + thisDiv);
			}
		}
	});
  day.readings = array;
  //console.log(day);
  callback(day);
}

/*
*/
router.get("/download2016Readings", function(req, res, next) {
	var d = new Date(2016, 0, 1);
	res.send({message:'Starting task. Will likely take longer than 2 minutes.'})
	var download = function () {
		async.series([
			function (callback) {
				sleep.sleep(1);
				callback(null);
			},
			function (callback) {
				var dateStr = getDateStr(d);
				var url = 'http://www.usccb.org/bible/readings/' + dateStr + '.cfm';
				console.log('url: ' + url);
				request(url, function(error, response, html) {
					if(!error) {
						console.log("request success for url: " + url);
						var filename = './readings/' + dateStr + '.reading';
						fs.writeFile(filename, html, function (err) {
						  if (err) callback(err);
						  console.log('Wrote to ' + filename);
						});
			    } else {
						console.log("request failure for url: " + url);
						callback(error);
					}
					callback(null);
				});
			},
			function (callback) {
				if (d.getFullYear() >= 2017) {
				//if (d.getMonth() === 1) {
				//if (d.getDate() == 14) {
					callback(null);
				} else {
					d.setDate(d.getDate() + 1);
					download();
					callback(null);
				}
			}
		]);
	}
	download();
});

/*
*/
router.get("/scrape2016Readings", function(req, res, next) {
	var d = new Date(2016, 0, 1);
	var scrape = function () {
		async.series([
			function (callback) {
				var dateStr = getDateStr(d);
				var filename = './readings/' + dateStr + '.reading';
				fs.readFile(filename, 'utf8', function (err, data) {
				  if (err) callback(err);
				  var html = data;
				  var $ = cheerio.load(html);
				  getReadings($, dateStr, function(data){
						var jsonFilename = './readings/' + dateStr + '.json';
						fs.writeFile(jsonFilename, JSON.stringify(data), function (err) {
							if (err) callback(err);
							console.log('Wrote to ' + jsonFilename);
							callback(null)
						});
				  });
				});
			},
			function (callback) {
				if (d.getFullYear() >= 2017) {
				//if (d.getMonth() === 1) {
					res.send({message:'Scrape complete.'})
					callback(null);
				} else {
					d.setDate(d.getDate() + 1);
					scrape();
					callback(null);
				}
			}
		]);
	}
	scrape();
});

router.post('/', function(req, res, next) {
  res.send( {
	  errors: [ {
		  code: 405,
		  title: "Method Not Allowed"
	  }]
  });
});

module.exports = router;
