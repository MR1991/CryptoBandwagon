"https://stackoverflow.com/questions/52689060/count-mean-subgroup-occurrence-within-subgroup/52689285"

"My final goal is to have a line ggplot, where the x-axis shows the hour_of_day, the y-axis stands for the mean number of occurrences. 
Eventually the lines should represent the 4 weather conditions. So one line ought to represent weather_of_the_day=1, and the y axis shows how often, 
on average weather_day=1 has an occurrence with hour_of_day=6 (as an example) and so on for 7, 8, etc.."


library(dplyr)
library(ggplot2)

df <- read.csv("count_mean_subgroup_occurance.csv")

df_plot <- df %>% 
  mutate(weather_of_the_day = factor(weather_of_the_day)) %>% 
  group_by(hour_of_day, weather_of_the_day) %>% 
  summarize(occurances = n())

ggplot(data = df_plot, 
       aes(x = hour_of_day, 
           y = occurances, 
           group = weather_of_the_day, 
           color = weather_of_the_day)) +
  geom_line()+
  geom_point()

