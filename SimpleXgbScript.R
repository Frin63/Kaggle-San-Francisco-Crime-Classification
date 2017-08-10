library(xgboost)

data("agaricus.train", package = 'xgboost')
data("agaricus.test", package =  'xgboost')

train <- agaricus.train
test <- agaricus.test

str(train)
dim(train$data)
dim(test$data)

class(train$data)[1]
class(train$label)

bstSpars <- xgboost(data = train$data, label = train$label, max.depth = 2, eta = 1, nthread = 2, nrounds = 2, objective = "binary:logistic")

# alternative
dtrain <- xgb.DMatrix(data = train$data, label=train$label)
bstDmatrix <- xgboost(data = dtrain, max.depth = 2, eta = 1, nthread = 2, nrounds = 2, objective = "binary:logistic", verbose = 2)

#predict
pred <- predict(bstDmatrix, test$data)
head(pred)
prediction <- as.numeric(pred > 0.5)
head(prediction)

#Measuring mode performance

err <- mean(prediction != test$label)
