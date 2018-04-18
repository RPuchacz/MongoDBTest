var MongoClient = require('mongodb').MongoClient;

var url = 'mongodb://localhost:27001/Traffic_Violations';


MongoClient.connect(url, function (err, client) {

    var db = client.db('Traffic_Violations');
		
		console.log("Liczba mandatów wd. daty");
		
	var cursor = db.collection('tickets').aggregate([
{$group: {_id:{rok:{ $year: "$Date_of_stop"}}, liczba:{$sum:1}}},
{ $sort: { liczba: 1 }}
]);

		cursor.each(function(err, doc) {

        console.log(doc);
	
    });
		
		client.close();
});

