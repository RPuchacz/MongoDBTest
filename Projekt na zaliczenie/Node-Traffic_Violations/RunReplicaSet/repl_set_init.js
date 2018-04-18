rsconf = {
  _id: "carbon",
  members: [
    { _id: 0, host: "localhost:27001", "priority" : 10 },
    { _id: 1, host: "localhost:27002", "priority" : 0 },
    { _id: 2, host: "localhost:27003", "priority" : 0 }
   ]
}; 
var statusInit = rs.initiate(rsconf)


