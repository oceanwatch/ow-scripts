T=read.table('2021/wake_atoll.txt',header=FALSE,skip=22)

T2=T[10593:dim(T)[1],]
library(date)
dates=mdy.date(T2[,2],T2[,3],T2[,1])
postscript('2021/Wake-dhw.ps')
plot(dates,T2[,9],type='l',ylab='Degree Heating Weeks',xlab='',axes=FALSE)
axis(2)
axis(1,seq(as.numeric(dates[1]),as.numeric(dates[length(dates)]),366),2014:2021)
box()
dev.off()


