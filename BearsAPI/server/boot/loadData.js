'use strict';

module.exports = function(app) {
  var Bear = app.models.Bear;
  Bear.create({"photoURL": "http://static.boredpanda.com/blog/wp-content/uploads/2016/09/mother-bear-cubs-animal-parenting-21-57e3a2161d7f7__880.jpg", "looksFriendly": true, "plural": true, "animalType": "Bear"});
  Bear.create({"photoURL": "http://www.firstpeople.us/pictures/bear/1600x1200/Feeling_Grizzly-1600x1200.jpg", "looksFriendly": false, "plural": false, "animalType": "Bear"});
  Bear.create({"photoURL": "http://www.firstpeople.us/pictures/bear/1600x1200/Grin_and_Bear_It-1600x1200.jpg", "looksFriendly": true, "plural": false, "animalType": "Bear"});
  Bear.create({"photoURL": "http://www.firstpeople.us/pictures/bear/1600x1200/Youve_Got_A_Friend_In_Me-1600x1200.jpg", "looksFriendly": true, "plural": true, "animalType": "Bear"});
  Bear.create({"photoURL": "https://s-media-cache-ak0.pinimg.com/736x/4f/af/3f/4faf3fdd4e94c625455320c91a7e4893.jpg", "looksFriendly": true, "plural": false, "animalType": "Bear"});
  Bear.create({"photoURL": "https://i.imgur.com/AOJJDhu.jpg", "looksFriendly": true, "plural": false, "animalType": "Bear"});
  Bear.create({"photoURL": "https://i.ytimg.com/vi/EI1IWOLl5YU/maxresdefault.jpg", "looksFriendly": true, "plural": true, "animalType": "Bear"});
  console.log("Sample bears added")
};
