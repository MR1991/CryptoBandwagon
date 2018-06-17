# This function creates a file in your nodeJS iota directory with the code for getting the tips.
# Input variables
# provider: 
# path: nodejs directory

get_tips <- function(provider, path){
  
  code <- paste0("
  // Require the use of IOTA library and fs
  const IOTA = require('iota.lib.js');
  const fs = require('fs');
  
  // Create a new instance of the IOTA class object. 
  // Use provider variable to specify which Full Node to talk to
  const iota = new IOTA({provider: '", provider,"'})
  
  
  iota.api.getTips((error, success) => {
    if (error) {
      console.log(error)
    } else {
      fs.writeFile('tips.txt', success, (error) => {
      if (error) throw error;
      console.log('The tips have been saved in tips.txt!');
      });
    }
  })"
  )
  write_lines(code, path = paste0(path,"get_tips.js"))
}








