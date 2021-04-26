#climatology and anomaly maps of SST in longline fishing ground

source('../../../../plotmaps-GMT2.R')
source('../../../../scale.R')

library(ncdf4)

nc=nc_open('2021/chl-PRIA-1998-2019-mean.nc')
v1=nc$var[[1]]
clim=ncvar_get(nc,v1)
lon=v1$dim[[1]]$vals
lat=v1$dim[[2]]$vals



#climatology
h=hist(log(clim), 100, plot=FALSE)

#breaks=h$breaks
breaks=log(c(seq(0.08,0.25,0.0001),2.7))
n=length(breaks)-1

#define a color palette
jet.colors <-colorRampPalette(c("blue", "#007FFF", "cyan","#7FFF7F", "yellow", "#FF7F00", "red", "#7F0000"))
#set color scale using the jet.colors palette
c=jet.colors(n)

x11(width=10.36,height=4.88)
layout(matrix(c(1,2,3,0,4,0), nrow=1, ncol=2), widths=c(7,1), heights=4)

par(mar=c(3,3,3,1))
image(lon,rev(lat),log(clim[,dim(clim)[2]:1]),col=c,breaks=breaks,xlab='',ylab='',axes=FALSE,xaxs='i',yaxs='i',asp=1,xlim=c(min(lon),max(lon)),ylim=c(min(lat),max(lat)),main='Climatology : 1998 - 2019')
par(new=TRUE)
nice.map(lon,rev(lat),1)
axis(2)
axis(1,seq(183,201,1),seq(183,201,1)-360)
box()


par(mar=c(3,1,3,3))
image.scale(clim, col=c, breaks=log(c(seq(0.08,0.25,0.0001),0.26)), horiz=FALSE,xlab='',ylab='',main='',las=1,yaxt='n')
axis(4,at=log(c(seq(0.08,0.25,0.02),0.26)),c(seq(0.08,0.25,0.02),2.7),las=1)
box()

##################################################################################################################################3
#anomaly

nc=nc_open('2021/chl-PRIA-2020-mean.nc')
v1=nc$var[[1]]
chl_2020=ncvar_get(nc,v1)
lon=v1$dim[[1]]$vals
lat=v1$dim[[2]]$vals

anom=chl_2020-clim



#breaks=seq(-0.01,0.01,0.0005)
breaks=c(-1.32,seq(-0.05,0.05,0.0005),0.24)
n=length(breaks)-1

#define a color palette
br.colors <-colorRampPalette(c("blue", "cyan","white", "#FF6666", "red"))

#set color scale using the jet.colors palette
c=br.colors(n)

layout(matrix(c(1,2,3,0,4,0), nrow=1, ncol=2), widths=c(7,1), heights=4)
layout.show(2)
par(mar=c(3,3,3,1))
image(lon,rev(lat),anom[,dim(anom)[2]:1],col=c,breaks=breaks,xlab='',ylab='',axes=FALSE,xaxs='i',yaxs='i',asp=1,xlim=c(min(lon),max(lon)),ylim=c(min(lat),max(lat)),main='2020 Anomaly')
par(new=TRUE)
nice.map(lon,rev(lat),1)
axis(2)
#axis(1)
axis(1,seq(183,201,1),seq(183,201,1)-360)
box()


par(mar=c(3,0,3,4))
image.scale(anom, col=c, breaks=c(-0.06,seq(-0.05,0.05,0.0005),0.06), horiz=FALSE,xlab='',ylab='',main='',yaxt='n',las=1)
axis(4,at=c(-0.06,seq(-0.05,0.05,0.01),0.06),labels=c(-1.32,seq(-0.05,0.05,0.01),0.24),las=1)
box()



#time-series
nc=nc_open('2021/chl-PRIA-1998-2020.nc')
v1=nc$var[[1]]
chl=ncvar_get(nc,v1)
dates=as.POSIXlt(v1$dim[[3]]$vals,origin='1970-01-01',tz='GMT')

ts=rep(NA,dim(chl)[3])
for (i in 1:dim(chl)[3]) ts[i]=mean(chl[,,i],na.rm=TRUE)

n=length(ts)

x11(height=4.7, width=10.0)

plot(1:(n-12),ts[1:(n-12)],type='l',axes=FALSE,xlab='',main='Chl-a',ylab='(mg/m^3)',pch=20,lwd=4, col=1,xlim=c(1,n))
lines((n-12):n,ts[(n-12):n],col="#5dade2",lwd=4)
axis(2)
#dates[1]=1998-07-01 GMT
axis(1,seq(1,n,12),1998:2020)
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
T=data.frame(dates, ts, anom)
write.csv(T,'chl-PRIA.csv',row.names=TRUE)

plot(1:(n-12),anom[1:(n-12)],type='l',axes=FALSE,xlab='',main='Chl-a anomalies',ylab='(mg/m^3)',pch=20,lwd=4,xlim=c(1,n))
lines((n-12):n,anom[(n-12):n],col="#5dade2",lwd=4)
axis(2)
axis(1,seq(1,n,12),1998:2020)
box()
lines(c(-10,n+10),c(0,0))







