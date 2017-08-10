#
#  Interesting: the number of vehicle thefts drops off after 2006
#  

library(dplyr)
library(ggplot2)
library(readr)

# Read in the data, but we need Dates
train <- read_csv("data/original/train.csv.zip",col_types = list(Dates = col_datetime()))

train$Category=as.factor(train$Category)
train$DayOfWeek=as.factor(train$DayOfWeek)

# Only care about 3 values: year, month, day
wdn3<-function(x) as.POSIXct(strftime(x, format="%Y-%m-%d 00:00:00"))
train$d3=wdn3(train$Dates)

crimes=levels(train$Category)
daysofweek=levels(train$DayOfWeek)

for (i in 1:length(crimes)) {
  
  # Number of crimes per day
  cd=summarise(group_by(train[train$Category==crimes[i],], d3), Counts=length(d3))



  # Plot this
  p=ggplot(cd,aes(y=Counts,x=d3))+geom_point(size = 1,color="blue")+
    ggtitle("San Francisco")+
    labs(y = "Count per/day", x=crimes[i])

  # Save it
    #remove slashes form filename
  filename=gsub("/","",crimes[i]);
 

  ggsave(paste("plots/crime-",filename,".png",sep=""), p, width=14, height=10, units="in")
}


for (i in 1:length(daysofweek)) {
  
  # Number of crimes per day
  cd=summarise(group_by(train[train$DayOfWeek==daysofweek[i],], d3), Counts=length(d3))
  
  
  
  # Plot this
  p=ggplot(cd,aes(y=Counts,x=d3))+geom_point(size = 1,color="blue")+
    ggtitle("San Francisco")+
    labs(y = "Count per/day", x=daysofweek[i])
  
  # Save it
  #remove slashes form filename
  filename=gsub("/","",daysofweek[i]);
  
  
  ggsave(paste("plots/day-",filename,".png",sep=""), p, width=14, height=10, units="in")
}


# One more for the total count
cd=summarise(group_by(train[,], d3), Counts=length(d3))



# Plot this
p=ggplot(cd,aes(y=Counts,x=d3))+geom_point(size = 1,color="blue")+
  ggtitle("San Francisco")+
  labs(y = "Count per/day", x="TOTAL")

# Save it
#remove slashes form filename
filename="TOTAL";


ggsave(paste("plots/",filename,".png",sep=""), p, width=14, height=10, units="in")

