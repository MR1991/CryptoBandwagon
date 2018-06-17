
library(tseries)
library(ggplot2)
library(magrittr)
library(dplyr)
library(forecast)

df <- read.csv(file = "/srv/shiny-server/data/Crypto-Markets.csv", stringsAsFactors = FALSE)

get_stats <- function(x){
  max_mc    <- max(x$market)
  max       <- max(x$close)
  date_max  <- x %>% filter(close == max) %$% date
  last      <- tail(x$close, 1)
  date_last <- x %>% filter(close == last) %$% date
  diff      <- (last-max)/max *100
  data.frame(max_mc, date_max, max, date_last, last, diff, stringsAsFactors = FALSE)
}

results_table <- df %>% group_by(symbol) %>% do(get_stats(.)) %>% arrange(desc(max_mc))


