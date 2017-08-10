# Comment goes here
library(readr)
library(glmnet)


# Read in the training data
SFPD_Incidents <- read_csv("data/SFPD_Incidents_-_from_1_January_2003.csv")

# Remove the columns not needed for this analysis
SFPD_Incidents$Location=NULL
SFPD_Incidents$PdId=NULL

# Retain only the burglary records
SFPD_Incidents <- SFPD_Incidents[SFPD_Incidents$Category=="BURGLARY",]
rm(train)
rm(test)

# Factorise naar Jaar, Maand, DagvdWeek, UurvdDag en geografisch vierkant
traintest$Year=as.factor(as.POSIXlt(traintest$Dates)$year+1900)
traintest$Month=as.factor(months(traintest$Dates))
traintest$Hour=as.factor(as.POSIXlt(traintest$Dates)$hour)


# Check for outliers


#Remove outliers (for now: don't)


#Project latlon to local coords
#x_median=median(SFPD_Incidents$X)
#y_median=median(SFPD_Incidents$Y)
#xloc=trunc((SFPD_Incidents$X-min(SFPD_Incidents$X))*cos(pi*y_median/180)/0.0025)
#yloc=trunc((SFPD_Incidents$Y-min(SFPD_Incidents$Y))/0.0025)

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
