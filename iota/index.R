source("functions/get_tips.R")

path <- "/home/mauricha/iota-example/"  # path to folder incl /
provider <- "https://balancer.iotatoken.nl:4433"
get_tips(provider, path)

write_lines(get_tips, path = "/home/mauricha/iota-example/get_tips.js")
system("node /home/mauricha/iota-example/get_tips.js")

test <- read.table("/home/mauricha/iota-example/tips.txt")

# Run node JS script to get Tips
library(readr)
library(magrittr)
data <- system("node /home/mauricha/iota-example/index.js", intern = TRUE, wait = FALSE) %>%
  gsub("\\[ ", "", .) %>%
  gsub("'", "", .) %>%
  gsub("\"" ,"", .) %>%
  data.frame()

system("node /home/mauricha/iota-example/index.js")
read.table("/home/mauricha/iota-example/tips.txt")

system("curl https://balancer.iotatoken.nl:4433 -X POST -H 'Content-Type: application/json' -H 'X-IOTA-API-Version: 1' -d '{'command': 'getNodeInfo'}'")

tips <- system("curl https://balancer.iotatoken.nl:4433 -X GET -H 'Content-Type: application/json' -H 'X-IOTA-API-Version: 1' -d '{'command': 'getTips'}'", intern = TRUE) 

  gsub("hashes[:punct:]*", "", .) %>%
  gsub("\\{", "", .) %>%
  gsub("\\}", "", .) %>%
  gsub("\\[", "", .) %>%
  gsub("\ ", "", .) %>%
  gsub("'", "", .) %>%
  gsub("\"" ,"", .) %>%
  gsub("],duration:*", "", .)
 # data.frame()

  

library(httr)
result <- POST("https://balancer.iotatoken.nl:4433/",
               verbose(),
               encode="json", 
               add_headers(`X-IOTA-API-Version`="1"),
               body=list(command="getNodeInfo"))
test <- content(result)
test2 <- data.frame(unlist(test$hashes), stringsAsFactors = FALSE)


library(httr)
result <- POST("https://durian.iotasalad.org:14265",
               verbose(),
               encode="json", 
               add_headers(`X-IOTA-API-Version`="1"),
               body=list(command="getNodeInfo"))
test <- content(result)
test2 <- data.frame(unlist(test$hashes), stringsAsFactors = FALSE)

library(httr)
result <- POST("https://turnip.iotasalad.org:14265",
               verbose(),
               encode="json", 
               add_headers(`X-IOTA-API-Version`="1"),
               body=list(command="getTips"))
test <- content(result)
test2 <- data.frame(unlist(test$hashes), stringsAsFactors = FALSE)



mainnet.deviota.com/16600
mainnet2.deviota.com/16600
iotairi.tt-tec.net/16600
voss-hosting.de/16600
136.243.73.66/16600
iotanode.party/16600
nelson.vanityfive.de/16600
tangle.vanityfive.de/16600
tanglenode.de/16600
nelson.iota.fm/16000
node.io7a.com/16600
us1.tangleno.de/16600
eu1.tangleno.de/16600
iota.bluemx.de/16600
nelson.iotacore.de/16600


get_status <- paste0("
  var request = require('request');
  
  var command = {
  'command': 'getBalances',
  'addresses': ['HBBYKAKTILIPVUKFOTSLHGENPTXYBNKXZFQFR9VQFWNBMTQNRVOUKPVPRNBSZVVILMAFBKOTBLGLWLOHQ'],
  'threshold': 100
  }
  
  var options = {
  url: 'http://localhost:14265',
  method: 'POST',
  headers: {
  'Content-Type': 'application/json',
  'X-IOTA-API-Version': '1',
  'Content-Length': Buffer.byteLength(JSON.stringify(command))
  },
  json: command
  };
  
  request(options, function (error, response, data) {
  if (!error && response.statusCode == 200) {
  console.log(data);
  }
  });"
)



