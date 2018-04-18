#!/bin/bash

echo "real user sys" >> time_results.txt

for I in {1,2,3,4,5}
do

/usr/bin/time -a -f "%e %U %S" -o time_results.txt gunzip -c ~/Desktop/raporty/StandaloneMazowieckie/mazowieckie.json.gz | mongoimport --drop --db Traffic_Violations --collection tickets

done

echo "<!doctype html>" >> times.html

echo "<html>" >> times.html

echo "<Body>" >> times.html

awk 'BEGIN{print "<table border="1">"} 
{print "<tr>";for(i=1;i<=NF;i++)print "<td>" $i"</td>";print "</tr>"} 
END{print "</table>"}' time_results.txt >> times.html

echo "</Body>" >> times.html

echo "</html>" >> times.html




