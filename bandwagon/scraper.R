library(crypto)     # for getCoins 
library(data.table) # fread
library(dplyr)      # data wrangling
library(lubridate)  # dates
library(tidyr)      # data wrangling
library(bit64)      # integer64 type
library(magrittr)   # pipelines

setwd("/srv/shiny-server/bandwagon/")

df_marketdata <- getCoins() %>% as.data.frame()

if (exists("df_marketdata")){ # check if scrape was succesfull
  date <- Sys.Date()
  write.csv(df_marketdata, paste0("~/data/Crypto-Markets", date, ".csv"), row.names = FALSE) # backup file
  
  if (nrow(df_marketdata) > nrow(read.csv("~/data/Crypto-Markets.csv"))) { # check if file is bigger
    file.copy(paste0("~/data/Crypto-Markets", date, ".csv"), "~/data/Crypto-Markets.csv", overwrite = TRUE)
  }
}

rm(df_marketdata)
gc()


# additional functionality: mailR for sending mails whether scrape was successful

