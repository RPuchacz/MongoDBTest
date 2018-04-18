cd carbon 
timeout 1
mongod --port 27002 --replSet carbon --dbpath data-2 --bind_ip localhost --oplogSize 128

