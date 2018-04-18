var MongoClient = require('mongodb').MongoClient;

var url = 'mongodb://localhost:27017/speed_tickets';

MongoClient.connect(url, function (err, client) {

  var db = client.db('speed_tickets');
		
		
	var cursor = db.collection('tickets').createIndex({Date_of_stop: 1});
		
		client.close();
});

