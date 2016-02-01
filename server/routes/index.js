'use strict';

var express = require('express');
var router = express.Router();
var dateData = require('../dal').getDateData;

/* GET root */
/* This function takes the number of milliseconds since 00:00:00 UTC on 1 January 1970.
   We take into account the request's locale. << TODO
   It converts that to the key with which we use to store day value data: MMDDYY
*/
router.get(/\d+/, function(req, res, next) {
	var millisecondsSince1970 = parseInt(req.path.substr(1));
	var theDate = new Date(millisecondsSince1970); // What time zone should assume the user is in?
	console.log("theDate: " + theDate);
	var month = (theDate.getMonth() + 1).toString();
	month = (month.length == 2) ? month : "0"+month; // MM
	var day = theDate.getDate().toString(); // DD
	var year = theDate.getFullYear().toString().substr(2) // YY
	var dateStr = month + day + year;
	console.log("Look up this date: " + dateStr);
	dateData(dateStr, function(dateData) {
		res.send(dateData);
	});
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
