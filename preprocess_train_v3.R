# This one uses the location description instead of the GPS location (=>lots more columns)
library(readr)
library(glmnet)


# Read in the training data
train <- read_csv("data/original/train.csv.zip",col_types = list(Dates = col_datetime()))

#str(train)

# Bepaal of zaken op hetzelfde moment + plaats geregistreerd staan er markeer die als extra feature
train$SameSpotTime=0

for (i in 2:nrow(train)) {
  if (train$Dates[i]==train$Dates[i-1] &
      train$X[i]==train$X[i-1] &
      train$Y[i]==train$Y[i-1]) {
    train$SameSpotTime[i]=1
    train$SameSpotTime[i-1]=1
  }
}

test <- read_csv("data/original/test.csv.zip",col_types = list(Dates = col_datetime()))

#str(test)

# Bepaal of zaken op hetzelfde moment + plaats geregistreerd staan er markeer die als extra feature
test$SameSpotTime=0

for (i in 2:nrow(test)) {
  if (test$Dates[i]==test$Dates[i-1] &
      test$X[i]==test$X[i-1] &
      test$Y[i]==test$Y[i-1]) {
    test$SameSpotTime[i]=1
    test$SameSpotTime[i-1]=1
  }
}

# Stel variabelen veilig voor later
ntrain=nrow(train)
ntest=nrow(test)
testIds=test$Id
trainCats=train$Category

# Maak beide tabellen gelijk qua structuur
train$Category=NULL
train$Descript=NULL
train$Resolution=NULL
train$X=NULL
train$Y=NULL
#train$Address=NULL
test$Id=NULL
#test$Address=NULL
test$X=NULL
test$Y=NULL

# En plak ze aan elkaar
traintest=rbind(train,test)
rm(train)
rm(test)

# Factorise naar Jaar, Maand, DagvdWeek, UurvdDag en geografisch vierkant
traintest$Year=as.factor(as.POSIXlt(traintest$Dates)$year+1900)
traintest$Month=as.factor(months(traintest$Dates))
traintest$Hour=as.factor(as.POSIXlt(traintest$Dates)$hour)

#Remove outliers (for now: don't)
#traintest$X[which((traintest$Y>=40))]

#Project latlon to local coords
#x_median=median(traintest$X)
#y_median=median(traintest$Y)
#xloc=trunc((traintest$X-min(traintest$X))*cos(pi*y_median/180)/0.0025)
#yloc=trunc((traintest$Y-min(traintest$Y))/0.0025)

#tooLarge=which(xloc>99)
#xloc[tooLarge]=99

#tooLarge=which(yloc>99)
#yloc[tooLarge]=99

#hist(xloc)
#hist(yloc)
#plot(xloc,yloc)


# And factorise the local coords
#loc=as.character(100*xloc+yloc)
#traintest$Loc=as.factor(loc)
traintest$Address=as.factor(traintest$Address)

# Zet om naar sparse array
x_all = sparse.model.matrix(~ . , data = traintest)

#clean up
rm(traintest,loc)

# en splits weer uit naar train en test
train=x_all[1:ntrain,]
test=x_all[(ntrain+1):nrow(x_all),]
rm(x_all)

# Zet de resultaten uit Train over in een apart Sparse maatrix
Cats=fac2sparse(as.factor(trainCats))


# sla de resultaten op
save(train,file="./data/enhanced/train_sparse3.Rdata")
save(Cats,file="./data/enhanced/train_results_sparse3.Rdata")
save(test,file="./data/enhanced/test_sparse3.Rdata")

#klaar
