# split train and validation set
#
# 
set.seed(12345)

load(file="train_features_polar.Rdata")
train <- read.csv("./data/training_solutions_rev1.csv", header=TRUE)

validset=sample(1:nrow(train_features),11578)

valid<-train[validset,]
valid_features<-train_features[validset,]
valid_cmf=cmf[validset,]
valid_fft_Im_f=fft_Im_f[validset,]
valid_fft_Re_f=fft_Re_f[validset,]
valid_rmf=rmf[validset,]
valid_central_BG=central_BG[validset]
valid_central_BR=central_BR[validset]

train<-train[-validset,]
train_features<-train_features[-validset,]
train_cmf=cmf[-validset,]
train_fft_Im_f=fft_Im_f[-validset,]
train_fft_Re_f=fft_Re_f[-validset,]
train_rmf=rmf[-validset,]
train_central_BG=central_BG[-validset]
train_central_BR=central_BR[-validset]

save(train_features,train_cmf,train_fft_Im_f,train_fft_Re_f,train_rmf,
     train_central_BG,train_central_BR,file="trainTrain_features_polar.Rdata")
save(train,file="trainTrain.Rdata")
save(valid_features,valid_cmf,valid_fft_Im_f,valid_fft_Re_f,valid_rmf,
     valid_central_BG,valid_central_BR,file="trainValid_features_polar.Rdata")
save(valid,file="trainValid.Rdata")
