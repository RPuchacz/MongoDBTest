#!/bin/bash

mkdir -p carbon
cd carbon
mkdir -p data-{1,2,3}

gnome-terminal -e "mongod --port 27001 --replSet carbon --dbpath data-1 --bind_ip localhost --oplogSize 128" 
gnome-terminal -e "mongod --port 27002 --replSet carbon --dbpath data-2 --bind_ip localhost --oplogSize 128"
gnome-terminal -e "mongod --port 27003 --replSet carbon --dbpath data-3 --bind_ip localhost --oplogSize 128"

cd ..

sleep 7

gnome-terminal -e "mongo --host localhost:27001 < repl_set_init.js"

sleep 12

	echo "replicaset defult" >> time_results_replica.txt
	echo "real user sys" >> time_results_replica.txt

for I in {1,2,3,4,5} 
do

/usr/bin/time -a -f "%e %U %S" -o time_results_replica.txt gunzip -c ~/Desktop/raporty/RSMazowieckie/mazowieckie.json.gz | mongoimport --host carbon/localhost:27001 --drop --db Traffic_Violations --collection tickets 

done

	echo "replicaset w:1,j:false" >> time_results_replica.txt
	echo "real user sys" >> time_results_replica.txt
	
	gnome-terminal -e "mongo --host localhost:27001 < sets1.js"

	sleep 3	

for I in {1,2,3,4,5}
do

/usr/bin/time -a -f "%e %U %S" -o time_results_replica.txt gunzip -c ~/Desktop/raporty/RSMazowieckie/mazowieckie.json.gz | mongoimport --host carbon/localhost:27001 --drop --db Traffic_Violations --collection tickets 

done

	echo "replicaset w:1,j:true" >> time_results_replica.txt
	echo "real user sys" >> time_results_replica.txt

	gnome-terminal -e "mongo --host localhost:27001 < sets2.js"

	sleep 3

for I in {1,2,3,4,5}
do

/usr/bin/time -a -f "%e %U %S" -o time_results_replica.txt gunzip -c ~/Desktop/raporty/RSMazowieckie/mazowieckie.json.gz | mongoimport --host carbon/localhost:27001 --drop --db Traffic_Violations --collection tickets 

done

	echo "replicaset w:2,j:false" >> time_results_replica.txt
	echo "real user sys" >> time_results_replica.txt
	gnome-terminal -e "mongo --host localhost:27001 < sets3.js"

	sleep 3

for I in {1,2,3,4,5}
do

/usr/bin/time -a -f "%e %U %S" -o time_results_replica.txt gunzip -c ~/Desktop/raporty/RSMazowieckie/mazowieckie.json.gz | mongoimport --host carbon/localhost:27001 --drop --db Traffic_Violations --collection tickets 

done

	echo "replicaset w:2,j:true" >> time_results_replica.txt
	echo "real user sys" >> time_results_replica.txt
	gnome-terminal -e "mongo --host localhost:27001 < sets4.js"

	sleep 3


for I in {1,2,3,4,5}
do

/usr/bin/time -a -f "%e %U %S" -o time_results_replica.txt gunzip -c ~/Desktop/raporty/RSMazowieckie/mazowieckie.json.gz | mongoimport --host carbon/localhost:27001 --drop --db Traffic_Violations --collection tickets 

done

echo "<!doctype html>" >> times.html

echo "<html>" >> times.html

echo "<Body>" >> times.html

awk 'BEGIN{print "<table border="1">"} 
{print "<tr>";for(i=1;i<=NF;i++)print "<td>" $i"</td>";print "</tr>"} 
END{print "</table>"}' time_results_replica.txt >> times.html

echo "</Body>" >> times.html

echo "</html>" >> times.html




