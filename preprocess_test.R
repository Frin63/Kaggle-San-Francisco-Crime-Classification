# preprocess the pictures

size=424
centerSize=200
margin=((size-centerSize)/2)+1
targetSize1=200
targetSize2=40
stepSize=targetSize1/targetSize2

test <- read.csv("./data/all_zeros_benchmark.csv", header=TRUE)
#test=test[1:100,]
id<-test[,1]

square_RGB=array(0,dim=c(targetSize1,targetSize1,3))
square_int=array(0,dim=c(targetSize1,targetSize1))
square_BG=array(0,dim=c(targetSize1,targetSize1))
square_BR=array(0,dim=c(targetSize1,targetSize1))
polar_int=array(0,dim=c(targetSize1,targetSize1))
small_pic=array(0,dim=c(targetSize2,targetSize2))


rmf=array(0,dim=c(length(id),targetSize1))
cmf=array(0,dim=c(length(id),targetSize1))
test_features=array(0,dim=c(length(id),targetSize2*targetSize2))
fft_Re_f=array(0,dim=c(length(id),100))
fft_Im_f=array(0,dim=c(length(id),100))
central_BG=array(0,dim=c(length(id)))
central_BR=array(0,dim=c(length(id)))

library(jpeg)
library(fftw)





library(jpeg)

for (i in 1:length(id)) {
  filename=paste('data/images_test_rev1/',id[i],'.jpg',sep="")  
  img=readJPEG(filename)
  
  # convert it to B&W and smaller resolution
  for (x in 1:targetSize1) {
    for (y in 1:targetSize1) {
      xpos=margin+(x-1)
      ypos=margin+(y-1)
      #     pixels=img[xpos:(xpos+stepSize-1),ypos:(ypos+stepSize-1),]
      #     square_features[x,y]=sum(pixels)
      square_RGB[x,y,]=img[xpos,ypos,]
      square_int[x,y]=sum(square_RGB[x,y,])
    }
  }
  #calculate average central brightness
  mean_int=mean(square_int[(targetSize1/2-2):(targetSize1/2+2),(targetSize1/2-2):(targetSize1/2+2)])
  
  
  #adapt picture to man central brightness 1.0:
  #  square_RGB=3*square_RGB/mean_int
  #  square_R=square_RGB[,,1]
  #  square_G=square_RGB[,,2]
  #  square_B=square_RGB[,,3]
  square_int=square_int/mean_int
  
  
  
  central_BG[i]= mean(square_RGB[98:103,98:103,3]+0.1)/
    mean(square_RGB[98:103,98:103,2]+0.1)
  central_BR[i]= mean(square_RGB[98:103,98:103,3]+0.1)/
    mean(square_RGB[98:103,98:103,1]+0.1)
  
  
  #debug
  #image(1:200, 1:200, square_int, col=gray((0:255)/255))
  #image(1:200, 1:200, square_RGB[,,1], col=gray((0:255)/255))
  #image(1:200, 1:200, square_BG, col=gray((0:255)/255))
  #image(1:200, 1:200, square_BR, col=gray((0:255)/255))
  
  # convert to polar representation
  for (x in 1:targetSize1) {
    alpha = 2 * pi * ( (x-1) / targetSize1)
    sinAlpha=sin(alpha)
    cosAlpha=cos(alpha)
    for (y in 1:targetSize1) {
      xpos=trunc((targetSize1+(y-1)*sinAlpha)/2)+1
      ypos=trunc((targetSize1+(y-1)*cosAlpha)/2)+1
      polar_int[x,y]=square_int[xpos,ypos]
      
    }
  }
  
  #debug
  
  cm=colMeans(polar_int)
  #plot(cm)
  rm=rowMeans(polar_int)
  #plot(rm)
  mrm=which.max(rm)
  
  #cBG=colMeans(polar_BG)
  #rBG=rowMeans(polar_BG)
  #plot(cBG)
  #plot(rBG)
  
  #cBR=colMeans(polar_BR)
  #rBR=rowMeans(polar_BR)
  #plot(cBR)
  #plot(rBR)
  
  tp=polar_int
  for (x in 0:199) {
    polar_int[x+1,]=tp[((mrm+x)%%200)+1,]
  }
  #image(1:200, 1:200, polar_int, col=gray((0:255)/255))
  
  fft_polar=fft(polar_int)[1:10,1:10]
  
  for (x in 1:targetSize2) {
    for (y in 1:targetSize2) {
      xpos=stepSize*(x-1)
      ypos=stepSize*(y-1)
      small_pic[x,y]=mean(polar_int[xpos:(xpos+stepSize-1),ypos:(ypos+stepSize-1)])
    }
  }
  #image(1:40, 1:40, small_pic, col=gray((0:255)/255))
  test_features[i,]=small_pic[,]
  
  rm=rowMeans(polar_int)
  
  rmf[i,]=rm
  cmf[i,]=cm
  fft_Re_f[i,]=Re(fft_polar[])
  fft_Im_f[i,]=Im(fft_polar[])
  
  
  
}
save(test_features,fft_Re_f,fft_Im_f,rmf,cmf,central_BG,central_BR,file="test_features_polar.Rdata")

