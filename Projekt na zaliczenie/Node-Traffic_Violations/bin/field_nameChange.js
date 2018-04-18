var MongoClient = require('mongodb').MongoClient;

var url = 'mongodb://localhost:27001/Traffic_Violations';

MongoClient.connect(url, function (err, client) {

    var db = client.db('Traffic_Violations');
		
		console.log("Zatrzymani pijani kierowcy:");
		
	var cursor = db.collection('tickets').updateMany( {}, { $rename: { "Date Of Stop": "Date_of_stop" } } );

		cursor.each(function(err, doc) {

        console.log(doc);
	
    });
		
		client.close();
});

