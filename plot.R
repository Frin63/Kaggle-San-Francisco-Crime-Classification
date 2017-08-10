####

load('train_features.data')
train_features=train_features[1:1000,]

#maken a file for the train data set

pdf(file="trainimage.pdf",onefile=TRUE)
par(mfrow=c(4,4))
for (j in 1:nrow(train_features)) {
  im <- matrix(data=rev(train_features[j,]), nrow=20, ncol=20)
  image(1:20, 1:20, im, col=gray((0:255)/255))
#  text(90,90,j)
#  hist(im, breaks=256)  
# histogram equalisation
#  imd<-tabulate(im+1,nbins=256)
#  cdf<-imd
#  for (i in 2:length(imd)) {
#    cdf[i]<-cdf[i-1]+imd[i]
#  }
#  im.eq<-im
#  for (k in (1:96)) {
#    for (l in (1:96)) {
#      im.eq[k,l]<-round((cdf[im[k,l]+1]-cdf[1])*256/((96*96)-cdf[1]))
#    }
#   }
#  image(1:96, 1:96, im.eq, col=gray((0:255)/255))
#  hist(im.eq,breaks=256)
}
dev.off()


## make a file for the test data set
#pdf(file="testimage.pdf",onefile=TRUE)
#par(mfrow=c(2,2))
#for (j in 1:nrow(d.test)) {
#  im <- matrix(data=rev(im.test[j,]), nrow=96, ncol=96)
#  image(1:96, 1:96, im, col=gray((0:255)/255))
#  text(90,90,j)
#}
#dev.off()


