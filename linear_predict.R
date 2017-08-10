##################################################################
library("glmnet")
library("readr")

set.seed(12345)

# load the preprocessed data
load("./data/enhanced/test_sparse.Rdata")
load("./data/enhanced/train_sparse.Rdata")
load("./data/enhanced/train_results_sparse.Rdata")

#get the Id's for the rpediction file
prediction <- read_csv("data/original/test.csv.zip",col_types = list(Dates = col_datetime()))
prediction=prediction[,1]

# Get rid of the 'Intercept' column and convert to regular matrix
Cats=as.matrix(Cats[,-1])

for (i in 1:ncol(Cats))
{
   cat(i,"\n")
   trainResponse=as.factor(Cats[,i])

  # train the model for this crime
  
  glmModel=glm(trainResponse ~ ., family= binomial, data=train)
  
  summary(glmModel)
  
  testResponse<-predict(glmModel,newdata=test, type="response")
  
  #and paste it to the prediction
  prediction=cbind(prediction,testResponse)

}

cat("Ready...\n")