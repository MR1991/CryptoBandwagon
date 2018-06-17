
library(tseries)
library(ggplot2)
library(magrittr)
library(dplyr)
library(forecast)

# Format
# 4 univariate time series flow.vat, flow.jok, prec, and temp, each with 1095 observations and the
# joint series ice.river.

# Details
# The series are daily observations from Jan. 1, 1972 to Dec. 31, 1974 on 4 variables: 
# flow.vat: mean daily flow of Vatnsdalsa river (cms), 
# flow.jok: mean daily flow of Jokulsa Eystri river (cms),
# prec:     daily precipitation in Hveravellir (mm)
# temp:     mean daily temperature in Hveravellir (deg C).

data(ice.river)
x <- seq(as.Date("1972-01-01"), as.Date("1974-12-31"), by="days")
y <- temp
df <- data.frame(x,y)

drawdown  <- maxdrawdown(df$y)

line <- df[561:717, ]

ggplot(df, aes(x, y)) + 
  geom_bar(colour="black", fill="#DD8888", width=.8, stat = "identity") + 
  guides(fill=FALSE) +
  xlab("Date") + ylab("Deg C") +
  ggtitle("Mean daily temperature in Hveravellir (deg C)")


df <- read.csv(file = "data/Crypto-Markets.csv", stringsAsFactors = FALSE)
df2 <- df %>% 
  filter(symbol == "BTC") %>%
  mutate(logclose = log10(close))
  
drawdown <- maxdrawdown(df2$close)
drawdownlog <- maxdrawdown(df2$logclose)


get_stats <- function(x){
  max_mc    <- max(x$market)
  max       <- max(x$close)
  date_max  <- x %>% filter(close == max) %$% date
  last      <- tail(x$close, 1)
  date_last <- x %>% filter(close == last) %$% date
  diff      <- (last-max)/max *100
  data.frame(max_mc, date_max, max, date_last, last, diff, stringsAsFactors = FALSE)
}


test <- df %>% group_by(symbol) %>% do(get_stats(.)) %>% arrange(desc(max_mc))

View(test[1:100,])



df4 <- df2[221:627, ]
head(df3$date)
tail(df3$date)
head(df4$date)
tail(df4$date)


df3 <- df2[-1, ]
df3$diff <- diff(df2$logclose)

df3$date %<>% as.Date()

df3$logclosema <- ma(df3$logclose, 10, centre = TRUE)

df3$extra <- diff(diff(df3$diff))
# Change the y-range to go from 0 to the maximum value in the total_bill column,
# and change axis labels
ggplot(data = df3, ) +
  geom_line(aes(x = date, y = diff, group = 1)) +
  expand_limits(y=0) +
  xlab("Time of day") + ylab("Total bill") +
  scale_x_date(date_breaks = "1 year", date_labels = "%Y")+
  ggtitle("Average bill for 2 people")+
  geom_line(aes(x = date, y = logclosema))

findfrequency(df3$close)

ggtsdisplay(df3$logclose)

plot(diff(diff(df3$diff)))

ndiffs(df3$close)
is.constant(diff(diff(diff(diff(df3$diff[500:600])))))
