cd carbon 
timeout 1
mongod --port 27001 --replSet carbon --dbpath data-1 --bind_ip localhost --oplogSize 128

