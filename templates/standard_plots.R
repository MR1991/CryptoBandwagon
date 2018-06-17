

## BAR PLOTS --------------------------------------------------------------

# Very basic bar graph
ggplot(data=dat, aes(x=time, y=total_bill)) +
  geom_bar(stat="identity")

## This would have the same result as above
 ggplot(data=dat, aes(x=time, y=total_bill)) +
    geom_bar(aes(fill=time), stat="identity")

# Add a black outline
ggplot(data=dat, aes(x=time, y=total_bill, fill=time)) +
  geom_bar(colour="black", stat="identity")

# Add title, narrower bars, fill color, and change axis labels
ggplot(data=dat, aes(x=time, y=total_bill, fill=time)) + 
  geom_bar(colour="black", fill="#DD8888", width=.8, stat="identity") + 
  guides(fill=FALSE) +
  xlab("Time of day") + ylab("Total bill") +
  ggtitle("Average bill for 2 people")


# Symbol	Meaning	Example
# %d	day as a number (0-31)	01-31
# %a
# %A	abbreviated weekday 
# unabbreviated weekday	Mon
# Monday
# %m	month (00-12)	00-12
# %b
# %B	abbreviated month
# unabbreviated month	Jan
# January
# %y
# %Y	2-digit year 
# 4-digit year