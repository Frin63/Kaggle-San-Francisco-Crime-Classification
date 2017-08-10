test=read.csv('data/test.csv')
train=read.csv('data/train.csv')
submit=read.csv('data/sampleSubmission.csv',check.names=FALSE)
/* check.names is FALSE omdat anders spaties worden omgezet naar punten, wat de parser niet snapt */
  

avg=table(train$Category)/nrow(train)

avg2=matrix(avg,nrow=nrow(test),ncol=39,byrow=TRUE)

submit[,2:40]=avg2[,]
rm(avg2)

write.csv(submit,"./submissions/predictAverage.csv",row.names=FALSE)
