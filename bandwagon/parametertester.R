# Load data -------------------------------------------------------------------------------------------------
df_marketdata      <- as.data.frame(fread("data/Crypto-Markets.csv", showProgress = FALSE)) 
df_marketdata$date %<>% as.Date("%Y-%m-%d")
df_marketdata$low  %<>% as.numeric()
df_marketdata[df_marketdata$close == 0, "close"] <- 0.00000000000001 

duplicates <- df_marketdata %>% 
  group_by(name, date) %>% 
  summarise(count = n()) %>% 
  filter(count != 1)

df_marketdata %<>% filter(!name %in% duplicates$name)

df_marketdata %<>% 
  arrange(ranknow, date) %>% 
  group_by(ranknow) %>%
  mutate(prevclose = dplyr::lag(close, n = 1, default = NA)) %>%
  mutate(percchg = (close - prevclose) / prevclose * 100) %>%
  arrange(ranknow, desc(date))

df_marketdata %<>%
  group_by(date) %>% 
  mutate(rankthen = dense_rank(desc(market)))

# Model -------------------------------------------------------------------------------------------------

run_model <- function(SDate, EDate, MaxRank, HPeriod, CoinsPeriod, StopLoss, Initial){
  a <- Sys.time()
  
  # Calculate % gain over previous period and actual gain over next period. Not adjusted for stoploss.
  df_modeldata <- df_marketdata %>% 
    filter(date >= SDate - HPeriod & date <= EDate + HPeriod,
           rankthen <= MaxRank) %>%
    arrange(ranknow, date) %>% 
    group_by(ranknow) %>%
    mutate(prevclose = lag(close, n = HPeriod, default = NA))   %>%
    mutate(prevChg   = (close - prevclose) / prevclose * 100) %>%
    mutate(nextclose = lead(close, n = HPeriod, default = NA))  %>%
    mutate(nextChg   = (nextclose - close) / close * 100)      %>%
    arrange(ranknow, desc(date))
  
  # Find lowest point during next period
  df_modeldata %<>%           
    arrange(ranknow, date) %>% 
    group_by(ranknow) %>% 
    mutate(periodlow = Inf)
  
  # Dynamic loop to grab lowest point
  for (i in 1:HPeriod) {
    df_modeldata %<>% 
      mutate(leadlow = dplyr::lead(low, n = i, default = NA),
             periodlow = ifelse(leadlow <= periodlow, leadlow, periodlow))
  b <- Sys.time()
  }
  
  # Arrange dataframe again, remove unnecessary column, calculate lowest point in %, 
  # compare to stoploss and adjust.
  df_modeldata %<>%  
    arrange(ranknow, desc(date)) %>%
    select(-leadlow) %>%
    mutate(nextLow = (periodlow - close)/close * 100) %>%
    mutate(return = ifelse(nextLow <= -StopLoss * 100,  -StopLoss * 100, nextChg))   # applying stoploss
  
  # Slice off begin and end of dataframe
  df_modeldata %<>% 
    filter(date >= SDate & date <= EDate)
  
  ## Selector module}
  # Let a model select x coins per period based on the criteria and put those rows 
  # in a dataframe for result analysis
  
  df_selected = list()
  
  df_modeldata %<>% 
    arrange(desc(prevChg)) %>%
    filter(!is.na(nextclose))
  
  SwitchDates <- seq(SDate, EDate, by = paste0(HPeriod, " days"))
  
  for (i in SwitchDates){
    df_selected[[i]] <- df_modeldata %>% 
      filter(date == i) %>% 
      ungroup() %>% 
      slice(1:CoinsPeriod)
  }
  
  df_selected <- bind_rows(df_selected)
  df_selected$returnfiat <- df_selected$return / 100 * Initial / CoinsPeriod

  return(df_selected)
}

# INPUTS -------------------------------------------------------------------------------------------------
# start and end date of analysis
 SDate <- as.Date("2017-10-01")
 EDate <- as.Date("2017-12-31")

 # max rank of coins to be selected
 MaxRank <- 150

 # period between switches
 HPeriod <- 3 # in days
 SwitchDates <- seq(SDate, EDate, by = paste0(HPeriod, " days"))

 # number of coins to be selected per period
 CoinsPeriod <- 2

 # percentage drop to sell
 StopLoss <- 0.25 * 100  # stoploss percentage

 # initial investment, total so its split per coin
 Initial <- 500 # in dollars

 Result <- 0

 
# Test sensitivity  -------------------------------------------------------------------------------------------------
df_results <- data.frame(SDate, EDate, MaxRank, HPeriod, CoinsPeriod, StopLoss, Initial, Result)
df_results <- df_results[-1, ]

for (HPeriod in 2:14){
  for (MaxRank in 1:150){
    run_data <- run_model(SDate, EDate, MaxRank = 116, HPeriod, CoinsPeriod, StopLoss, Initial, Reinvest = NULL, HoldInBTC = NULL)
    result <- run_data %>% select(returnfiat) %>% sum()
    df_results %<>% add_row(SDate, EDate, MaxRank, HPeriod, CoinsPeriod, StopLoss, Initial, Result = result)
  }
}


# use https://www.rdocumentation.org/packages/sensitivity/versions/1.14.0/topics/shapleyPermRand
 