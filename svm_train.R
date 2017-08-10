# creates a predictor svm model
nsel=3000
set.seed(12345+nsel)
library(kernlab)

train <- read.csv("./data/train.csv", header=TRUE)

# pak nsel willekeurige rijen
idx_train=sample(1:nrow(train),nsel)
train=train[idx_train,]
train_features=train_features[idx_train,]

#find the maximum rated multiple choice option to determine the labels
temp=train[,c(2,3,4)]
labelTemp=train[,1]
for (i in 1:nrow(train)) {
  labelTemp[i]=which.max(temp[i,])
}
labels <- as.factor(labelTemp)
rm(temp)
rm(train)
rm(labelTemp)

svm<-ksvm(train_features, labels, type="spoc-svc", C=5, kernel="rbfdot")

save(svm,file="svmClass1.Rdata")
