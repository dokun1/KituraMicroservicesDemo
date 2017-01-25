'use strict';

module.exports = function(app) {
	var Cat = app.models.Cat;
  	Cat.create({"photoURL": "https://img.buzzfeed.com/buzzfeed-static/static/2014-04/enhanced/webdr02/9/12/enhanced-buzz-11844-1397060009-22.jpg?no-auto", "looksFriendly": false, "plural": true, "animalType": "Cat"});
  	Cat.create({"photoURL": "https://img.buzzfeed.com/buzzfeed-static/static/2014-04/enhanced/webdr06/9/18/enhanced-buzz-19557-1397082576-4.jpg?no-auto", "looksFriendly": true, "plural": true, "animalType": "Cat"});
  	Cat.create({"photoURL": "https://img.buzzfeed.com/buzzfeed-static/static/2014-04/enhanced/webdr07/9/14/enhanced-18799-1397069418-11.jpg?no-auto", "looksFriendly": true, "plural": true, "animalType": "Cat"});
  	Cat.create({"photoURL": "https://img.buzzfeed.com/buzzfeed-static/static/2014-04/enhanced/webdr06/9/14/enhanced-719-1397069471-5.jpg?no-auto", "looksFriendly": false, "plural": false, "animalType": "Cat"});
  	Cat.create({"photoURL": "https://img.buzzfeed.com/buzzfeed-static/static/2014-04/enhanced/webdr04/9/14/enhanced-25038-1397069417-14.jpg?no-auto", "looksFriendly": false, "plural": false, "animalType": "Cat"});
 	Cat.create({"photoURL": "https://img.buzzfeed.com/buzzfeed-static/static/2014-04/enhanced/webdr06/9/14/enhanced-11725-1397069414-21.jpg?no-auto", "looksFriendly": false, "plural": true, "animalType": "Cat"});
  	Cat.create({"photoURL": "https://img.buzzfeed.com/buzzfeed-static/static/2014-04/enhanced/webdr08/9/14/enhanced-11796-1397069419-11.jpg?no-auto", "looksFriendly": false, "plural": false, "animalType": "Cat"});
  	console.log("Sample Cats added")
};
