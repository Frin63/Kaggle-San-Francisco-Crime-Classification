##################################################################
library("glmnet")
library("readr")
#library("doParallel")

set.seed(12345)
#registerDoParallel(cores = 4)


# load the preprocessed data
load("./data/enhanced/test_sparse.Rdata")
load("./data/enhanced/train_sparse.Rdata")
load("./data/enhanced/train_results_sparse.Rdata")

#get the Id's for the prediction file
prediction <- read_csv("data/original/test.csv.zip",col_types = list(Dates = col_datetime()))
prediction=data.frame(Ids=prediction[,1])

#Create a lambda sequence from 10 to 0.0001 
i=seq(-1,-4,length.out=50)
lambdaSeries=10**i

for (i in 1:nrow(Cats))
{
   cat(i," ",Cats@Dimnames[[1]][i],"\n")
   trainResponse=as.factor(Cats[i,])

  # train the model for this crime
  model = glmnet(
    x = train, 
    y = trainResponse, 
    family = "binomial",
    standardize = T,
    alpha = 0.5,
    lambda=lambdaSeries,
    intercept = T)
  
  #predict the outcome for this crinme
  testResponse <- predict(model, test, type="response", exact=TRUE)[,4]

  #and paste it to the prediction
  prediction=cbind(prediction,testResponse)

}
#stopCluster()

sampleSubmission <- read_csv("data/original/sampleSubmission.csv.zip")
dimnames(prediction)=dimnames(sampleSubmission)
write.csv(prediction,"./submissions/predictLinearLassoMix.csv",row.names=FALSE)

cat("Ready...\n")
