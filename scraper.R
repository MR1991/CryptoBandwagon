library(crypto)     # for getCoins 
library(data.table) # fread
library(magrittr)
library(dplyr)      # data wrangling
library(lubridate)  # dates
library(tidyr)      # data wrangling
library(bit64)      # integer64 type
library(magrittr)   # pipelines

df_marketdata <- getCoins() %>% as.data.frame()
date <- Sys.Date()
write.csv(df_marketdata, paste0("srv/shiny-server/Data/Crypto-Markets", date, ".csv"), row.names = FALSE)
rm(df_marketdata)
gc()