cd carbon 
timeout 1 
mongod --port 27003 --replSet carbon --dbpath data-3 --bind_ip localhost --oplogSize 128