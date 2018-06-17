library(crypto)     # for getCoins 
library(data.table) # fread
library(dplyr)      # data wrangling
library(lubridate)  # dates
library(tidyr)      # data wrangling
library(bit64)      # integer64 type
library(magrittr)   # pipelines

df_marketdata <- getCoins() %>% as.data.frame()

if (exists("df_marketdata")){ # check if scrape was succesfull
  date <- Sys.Date()
  write.csv(df_marketdata, paste0("/srv/shiny-server/data/Crypto-Markets", date, ".csv"), row.names = FALSE) # backup file
  file.copy(paste0("/srv/shiny-server/data/Crypto-Markets", date, ".csv"), "/srv/shiny-server/data/Crypto-Markets.csv", overwrite = TRUE)
}

rm(df_marketdata)
gc()


# additional functionality: mailR for sending mails whether scrape was successful

