##################################################################
library("glmnet")
library("doParallel")
#library("readr")

registerDoParallel(cores = 2)

set.seed(12348)

# load the preprocessed data
#load("./data/enhanced/test_sparse3.Rdata")
load("./data/enhanced/train_sparse3.Rdata")
load("./data/enhanced/train_results_sparse3.Rdata")

#Create a subset to prevent memory problems
nsel=trunc(nrow(train)/4)
selection=sample(1:nrow(train),nsel)
train=train[selection,]
Cats=Cats[,selection]

#Remove the 'TREA'category (value 34) because it has too few hits to be significant
#and it makes the glmnet training crash
Cats=Cats[-34,]

#Create a lambda sequence form 10 to 0.0001 
i=seq(-1,-4,length.out=50)
lambdaSeries=10**i

#get the Id's for the prediction file
#prediction <- read_csv("data/original/test.csv.zip",col_types = list(Dates = col_datetime()))
#prediction=data.frame(Ids=prediction[,1])

cvtot=rep(0.0,50)

for (i in 1:nrow(Cats))
{
   cat(i," ",Cats@Dimnames[[1]][i],"\n")
   trainResponse=as.factor(Cats[i,])

  # train the model with 10-fold cross validation; determine optimal lambda
  # for this crime category
  model = cv.glmnet(
    x = train, 
    y = trainResponse, 
    lambda=lambdaSeries,
    family = "binomial",
    standardize = T,
    alpha = 0.00,
    type.measure = "auc",
    intercept = T,
    nfolds = 10,
    parallel=TRUE)
  
  cat("Min cv.glmnet VAL Classification error : ", max(model$cvm, na.rm = T), "\n")
  cat("Optimal Lambda value : ",model$lambda.min," +/- ",model$lambda.1se,"\n") 
  #plot(model)
  
  cvtot=cvtot+model$cvm
  
  #predict the outcome for this crime
  #testResponse <- predict(model, test, type="response", exact=TRUE)[,4]

  #and paste it to the prediction
  #prediction=cbind(prediction,testResponse)

}
stopCluster()


cat("Ready...\n\n\n")
i=which.max(cvtot)
cat("Min lambda   : ",lambdaSeries[i],"\n")
cat("Min CV error : ",cvtot[i],"\n")
plot(log10(lambdaSeries),cvtot)
