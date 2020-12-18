library(ncdf4)

#time-series
nc=nc_open('rain-AS-1979-2019.nc')
v1=nc$var[[1]]
rain=ncvar_get(nc,v1)
dates=as.POSIXlt(v1$dim[[3]]$vals,origin='1970-01-01',tz='GMT')

ts=rep(NA,dim(rain)[3])
for (i in 1:dim(rain)[3]) ts[i]=mean(rain[,,i],na.rm=TRUE)

n=length(ts)

plot(1:(n-12),ts[1:(n-12)],type='l',axes=FALSE,xlab='',main='Precipitation',ylab='(mm/day)',pch=20,lwd=4, col=1,xlim=c(1,n))
lines((n-12):n,ts[(n-12):n],col="#5dade2",lwd=4)
axis(2)
#dates[1]=1998-07-01 GMT
axis(1,seq(1,n,12),1979:2019)
box()

# anomaly
m=rep(NA,12)
for (i in 1:12) {
    ind=seq(i,n,12)
    m[i]=mean(ts[ind],na.rm=TRUE)
}

y=n/12  #  # of years

mtot=rep(m,y)

anom=ts-mtot
T=data.frame(dates, ts,anom)
write.csv(T,'rain-AS.csv',row.names=TRUE)



plot(1:(n-12),anom[1:(n-12)],type='l',axes=FALSE,xlab='',main='Precipitation',ylab='(mm/day)',pch=20,lwd=4,xlim=c(1,n))
lines((n-12):n,anom[(n-12):n],col="#5dade2",lwd=4)
axis(2)
axis(1,seq(1,n,12),1979:2019)
box()
lines(c(-10,n+10),c(0,0))







