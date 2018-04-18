var MongoClient = require('mongodb').MongoClient;

var url = 'mongodb://localhost:27001/Traffic_Violations';

MongoClient.connect(url, function (err, client) {

    var db = client.db('Traffic_Violations');
		
		console.log("Zatrzymani pijani kierowcy:");
		
	var cursor = db.collection('tickets').find().forEach( function(res){

      if (typeof(res.Date_of_stop)=="string"){
        var arr = res.Date_of_stop.split("/");
        res.Date_of_stop = new Date(arr[2], arr[0] - 1, arr[1]);
        db.tickets.save(res)
      }
    }
);

		cursor.each(function(err, doc) {

        console.log(doc);
	
    });
		
		client.close();
});

