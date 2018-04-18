rsconf = {
  _id: "carbon",
  members: [
    { _id: 0, host: "localhost:27001" },
    { _id: 1, host: "localhost:27002" },
    { _id: 2, host: "localhost:27003" }
   ]
}; 
var statusInit = rs.initiate(rsconf)


