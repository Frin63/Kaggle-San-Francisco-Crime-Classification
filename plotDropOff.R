#
#  Interesting: the number of vehicle thefts drops off after 2006
#  

library(dplyr)
library(ggplot2)
library(readr)

# Read in the data, but we need Dates
train <- read_csv("data/original/train.csv.zip",col_types = list(Dates = col_datetime()))

# Only care about 3 values: year, month, day
wdn3<-function(x) as.POSIXct(strftime(x, format="%Y-%m-%d 00:00:00"))
train$d3=wdn3(train$Dates)

# Number of thefts per day
cd=summarise(group_by(train[train$Category=="ARSON",], d3), Counts=length(d3))



# Plot this
p=ggplot(cd,aes(y=Counts,x=d3))+geom_point(size = 1,color="blue")+
  ggtitle("San Francisco")+
  labs(y = "Count per/day", x="Vehicle Theft")

# Save it        
ggsave("plots/arson.png", p, width=14, height=10, units="in")
