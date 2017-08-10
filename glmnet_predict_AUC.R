##################################################################
library("glmnet")
library("readr")

set.seed(12345)

# load the preprocessed data
load("./data/enhanced/test_sparse.Rdata")
load("./data/enhanced/train_sparse.Rdata")
load("./data/enhanced/train_results_sparse.Rdata")

#get the Id's for the prediction file
prediction <- read_csv("data/original/test.csv.zip",col_types = list(Dates = col_datetime()))
prediction=data.frame(Ids=prediction[,1])


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
    alpha = 0.0,
    lambda=c(0.1,0.05,0.02,0.01,0.005,0.002,0.001),
    nlambda=7,
    intercept = T)
  
  #predict the outcome for this crinme
  testResponse <- predict(model, test, type="response", exact=TRUE)[,4]

  #and paste it to the prediction
  prediction=cbind(prediction,testResponse)

}

sampleSubmission <- read_csv("data/original/sampleSubmission.csv.zip")
dimnames(prediction)=dimnames(sampleSubmission)
write.csv(prediction,"./submissions/predictLinear.csv",row.names=FALSE)

cat("Ready...\n")
