##################################################################
library("glmnet")
library("readr")
library(chron)

set.seed(12345)

# load the preprocessed data
load("./data/enhanced/train_enhanced.Rdata")
load("./data/enhanced/test_enhanced.Rdata")

plot(train$Dates)
plot(test$Dates)

plot(train$Dates[1:5000],colour="red")
points(test$Dates[1:5000],colour="blue")

train$Category<-as.factor(train$Category)
o<-order(train$Loc,train$Category,train$Dates)
train<-train[o,]

burglary<-train[train$Category=="BURGLARY",]
burglary$TimeElapsed<- NA
for (i in 2:nrow(burglary)) {
  if (burglary$Loc[i-1]==burglary$Loc[i]) {
    burglary$TimeElapsed[i]<-round(burglary$Dates[i]-burglary$Dates[i-1])
  }
}

hist(burglary$TimeElapsed,xlim=c(0,90),breaks=c(seq(0,90,1),max(burglary$TimeElapsed)))
hist(as.numeric(days(burglary$Dates)))


###########################

burglary<-train[train$Category=="BURGLARY",]
burglary$TimeElapsed<- NA
for (i in 2:nrow(burglary)) {
  if (burglary$Loc[i-1]==burglary$Loc[i]) {
    burglary$TimeElapsed[i]<-round(burglary$Dates[i]-burglary$Dates[i-1])
  }
}

summary(burglary$TimeElapsed)

hist(burglary$TimeElapsed,xlim=c(0,90),breaks=4000)
hist(as.numeric(days(burglary$Dates)))

