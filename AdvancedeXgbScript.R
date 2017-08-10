library(xgboost)

data("agaricus.train", package = 'xgboost')
data("agaricus.test", package =  'xgboost')

train <- agaricus.train
test <- agaricus.test

dtrain <- xgb.DMatrix(data=train$data,label=train$label)
dtest <- xgb.DMatrix(data=test$data,label=test$label)

watchlist <- list(train=dtrain, test=dtest)

# train with test metrics as well
bst <- xgb.train(data=dtrain, max.depth=2, eta=1, nthread=2, nround=2, watchlist = watchlist, objective="binary:logistic")

# train with two specified evaluation metrics
bstTree <- xgb.train(data=dtrain, max.depth=2, eta=1, nthread=2, nround=2, watchlist = watchlist, 
                 eval.metric="error", eval.metric="logloss",
                 objective="binary:logistic")

# Instead of trees, use linear boosting:
bstLin <- xgb.train(data=dtrain, booster="gblinear", max.depth=2, nthread=2, nround=2, watchlist = watchlist, 
                 eval.metric="error", eval.metric="logloss",
                 objective="binary:logistic")

# hint: try both and see what works better (depens on how linear the problem is)

# view feature importance

importance_matrix <- xgb.importance(model = bstTree)
print(importance_matrix)
print(colnames(train$data)[as.numeric(importance_matrix$Feature)])
library(Ckmeans.1d.dp)
xgb.plot.importance(importance_matrix = importance_matrix)

library(DiagrammeR)
xgb.plot.tree(model=bstTree)
