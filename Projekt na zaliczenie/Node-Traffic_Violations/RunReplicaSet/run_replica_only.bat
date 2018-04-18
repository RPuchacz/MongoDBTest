start cmd /k ReplSet27001
start cmd /k ReplSet27002
start cmd /k ReplSet27003

sleep 7

mongo --host localhost:27001 < repl_set_init.js








