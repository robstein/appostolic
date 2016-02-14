'use strict';

var express = require('express');
var redis = require("redis"),
    client = redis.createClient();

function demoMaterial() {
    client.set('013116', '{ 	"title": "Monday of the Second Week in Ordinary Time", 	"lectionary": "Lectionary 311", 	"readings": [{ 		"name": "Reading 1", 		"passage": "1 Sm 15:16-23", 		"body": "Samuel said to Saul:<br>“Stop! Let me tell you what the LORD said to me last night.”<br>Saul replied, “Speak!” <br>Samuel then said: “Though little in your own esteem,<br>are you not leader of the tribes of Israel?<br>The LORD anointed you king of Israel and sent you on a mission, saying,<br>‘Go and put the sinful Amalekites under a ban of destruction.<br>Fight against them until you have exterminated them.’<br>Why then have you disobeyed the LORD?<br>You have pounced on the spoil, thus displeasing the LORD.”<br>Saul answered Samuel: “I did indeed obey the LORD<br>and fulfill the mission on which the LORD sent me.<br>I have brought back Agag, and I have destroyed Amalek under the ban.<br>But from the spoil the men took sheep and oxen,<br>the best of what had been banned,<br>to sacrifice to the LORD their God in Gilgal.”<br>But Samuel said:<br>“Does the LORD so delight in burnt offerings and sacrifices<br>as in obedience to the command of the LORD?<br>Obedience is better than sacrifice,<br>and submission than the fat of rams.<br>For a sin like divination is rebellion,<br>and presumption is the crime of idolatry.<br>Because you have rejected the command of the LORD,<br>he, too, has rejected you as ruler.”<br>" 	}, { 		"name": "Responsorial Psalm", 		"passage": "PS 50:8-9, 16bc-17, 21 and 23", 		"body": "R. (23b) <strong>To the upright I will show the saving power of God.</strong><br>“Not for your sacrifices do I rebuke you,<br>for your burnt offerings are before me always.<br>I take from your house no bullock,<br>no goats out of your fold.”<br>R. <strong>To the upright I will show the saving power of God.</strong><br>“Why do you recite my statutes,<br>and profess my covenant with your mouth,<br>Though you hate discipline<br>and cast my words behind you?”<br>R. <strong>To the upright I will show the saving power of God.</strong><br>“When you do these things, shall I be deaf to it?<br>Or do you think that I am like yourself?<br>I will correct you by drawing them up before your eyes.<br>He that offers praise as a sacrifice glorifies me;<br>and to him that goes the right way I will show the salvation of God.”<br>R. <strong>To the upright I will show the saving power of God.</strong>" 	}, { 		"name": "Responsorial Psalm", 		"passage": "Heb 4:12", 		"body": "R. <strong>Alleluia, alleluia.</strong><br>The word of God is living and effective,<br>able to discern reflections and thoughts of the heart.<br>R. <strong>Alleluia, alleluia.</strong>" 	}, { 		"name": "Gospel", 		"passage": "Mk 2:18-22", 		"body": "The disciples of John and of the Pharisees were accustomed to fast.<br>People came to Jesus and objected,<br>“Why do the disciples of John and the disciples of the Pharisees fast,<br>but your disciples do not fast?”<br>Jesus answered them,<br>“Can the wedding guests fast while the bridegroom is with them?<br>As long as they have the bridegroom with them they cannot fast.<br>But the days will come when the bridegroom is taken away from them,<br>and then they will fast on that day.<br>No one sews a piece of unshrunken cloth on an old cloak.<br>If he does, its fullness pulls away,<br>the new from the old, and the tear gets worse.<br>Likewise, no one pours new wine into old wineskins.<br>Otherwise, the wine will burst the skins,<br>and both the wine and the skins are ruined.<br>Rather, new wine is poured into fresh wineskins.”<br>" 	}], 	"liturgyOfTheHours": [{ 		"name": "Invitatory", 		"body": "<p>Lord, open my lips.<br/></p>" 	}, { 		"name": "Office of Readings", 		"body": "" 	}, { 		"name": "Morning Prayer", 		"body": "" 	}, { 		"name": "Daytime Prayer", 		"body": "" 	}, { 		"name": "Evening Prayer", 		"body": "" 	}, { 		"name": "Night Prayer", 		"body": "" 	}], 	"saints": [{ 		"name": "Blessd Maria Teresa Fasce", 		"body": "Here is some information about this saint." 	}] }', redis.print);
}

client.on('error', function (err) {
  console.log('Error ' + err);
});


var fnGetDateData = function getDateData(dateStr, callback) {
  callback = (typeof callback === 'function') ? callback : function() {};
  client.get(dateStr, function(error, reply) {
    var obj = JSON.parse(reply);
    client.quit();
    callback(obj);
  });
}

//demoMaterial();

module.exports = client;
module.exports.getDateData = fnGetDateData;

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
	self.name = dayID;
	self.passage = '';
	self.body = '';
}
function Liturgy() {
    var self = this;
}
function Saint() {
    var self = this;
}
