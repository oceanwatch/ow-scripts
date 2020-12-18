T=read.table('howland_baker.txt',header=FALSE,skip=1)

T2=T[10593:dim(T)[1],]
library(date)
dates=mdy.date(T2[,2],T2[,3],T2[,1])
postscript('HB-dhw.ps')
plot(dates,T2[,9],type='l',ylab='Degree Heating Weeks',xlab='')
dev.off()


