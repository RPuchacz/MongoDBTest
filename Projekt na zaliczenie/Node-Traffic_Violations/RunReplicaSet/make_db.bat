mkdir carbon
cd carbon
mkdir data-1
mkdir data-2
mkdir data-3
cd ..
start cmd /k ReplSet27001
start cmd /k ReplSet27002
start cmd /k ReplSet27003

sleep 7

mongo --host localhost:27001 < repl_set_init.js

sleep 10

gunzip -c data\Traffic_Violations.csv.gz | mongoimport --host carbon/localhost:27001 --drop --db Traffic_Violations --collection tickets --type csv --headerline






