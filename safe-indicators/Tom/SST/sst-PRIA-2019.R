
source('../../../../plotmaps-GMT2.R')
source('../../../../scale.R')
library(ncdf4)

nc=nc_open('2021/sst-PRIA-1985-2019-mean.nc')
v1=nc$var[[1]]
clim=ncvar_get(nc,v1)
lon=v1$dim[[1]]$vals
lat=v1$dim[[2]]$vals



#climatology
h=hist(clim, 500, plot=FALSE)

breaks=h$breaks
n=length(breaks)-1

#define a color palette
jet.colors <-colorRampPalette(c("blue", "#007FFF", "cyan","#7FFF7F", "yellow", "#FF7F00", "red", "#7F0000"))
#set color scale using the jet.colors palette
c=jet.colors(n)

x11(width=10.36,height=4.88)
layout(matrix(c(1,2,3,0,4,0), nrow=1, ncol=2), widths=c(7,1), heights=4)
layout.show(2)

par(mar=c(3,3,3,1))
#image(lon,lat,clim,col=c,breaks=breaks,xlab='',ylab='',axes=FALSE,xaxs='i',yaxs='i',asp=1,xlim=c(min(lon),max(lon)),ylim=c(min(lat),max(lat)),main='Climatology : 1985 - 2019')
image(lon,rev(lat),clim[,dim(clim)[2]:1],col=c,breaks=breaks,xlab='',ylab='',axes=FALSE,xaxs='i',yaxs='i',asp=1,xlim=c(min(lon),max(lon)),ylim=c(min(lat),max(lat)),main='Climatology : 1985 - 2019')
par(new=TRUE)
#nice.map(lon,lat,1)
nice.map(lon,rev(lat),1)
axis(2)
#axis(1)
axis(1,seq(183,201,1),seq(183,201,1)-360)
box()


par(mar=c(3,1,3,4))
image.scale(clim, col=c, breaks=breaks, horiz=FALSE,xlab='',ylab='',main='ºC',yaxt='n',las=1)
#axis(4,at=seq(5,25,5),seq(5,25,5),las=1)
axis(4,las=1)
box()


#anomaly

nc=nc_open('2021/sst-PRIA-2020-mean.nc')
v1=nc$var[[1]]
sst_2020=ncvar_get(nc,v1)
lon=v1$dim[[1]]$vals
lat=v1$dim[[2]]$vals

anom=sst_2020-clim

h=hist(anom, 100, plot=FALSE)
breaks=seq(-0.7,0.7,0.01)
#breaks=c(seq(-1.08,-0.55,0.01),0,seq(0.55,1.08,0.01))

n=length(breaks)-1

#define a color palette
br.colors <-colorRampPalette(c("blue", "cyan","white", "#FF6666", "red"))

#set color scale using the jet.colors palette
c=br.colors(n)

#X11(width=10.3,height=4.6)
layout(matrix(c(1,2,3,0,4,0), nrow=1, ncol=2), widths=c(7,1), heights=4)
layout.show(2)

par(mar=c(3,3,3,1))
#image(lon,lat,anom,col=c,breaks=breaks,xlab='',ylab='',axes=FALSE,xaxs='i',yaxs='i',asp=1,xlim=c(min(lon),max(lon)),ylim=c(min(lat),max(lat)),main='2020 Anomaly')
image(lon,rev(lat),anom[,dim(anom)[2]:1],col=c,breaks=breaks,xlab='',ylab='',axes=FALSE,xaxs='i',yaxs='i',asp=1,xlim=c(min(lon),max(lon)),ylim=c(min(lat),max(lat)),main='2020 Anomaly')
par(new=TRUE)
#nice.map(lon,lat,1)
nice.map(lon,rev(lat),1)
axis(2)
axis(1,seq(183,201,1),seq(183,201,1)-360)
box()


par(mar=c(3,1,3,4))
image.scale(anom, col=c, breaks=breaks, horiz=FALSE,xlab='',ylab='',main='ºC',yaxt='n',las=1)
axis(4,las=1)
#axis(4,at=seq(-3,3,1),seq(-3,3,1),las=1)
box()



#time-series
nc=nc_open('2021/sst-PRIA-1985-2020.nc')
v1=nc$var[[1]]
sst=ncvar_get(nc,v1)
dates=as.POSIXlt(v1$dim[[3]]$vals,origin='1970-01-01',tz='GMT')

ts=rep(NA,dim(sst)[3])
for (i in 1:dim(sst)[3]) ts[i]=mean(sst[,,i],na.rm=TRUE)

n=length(ts)

x11(height=5.2, width=11.1)
plot(1:(n-12),ts[1:(n-12)],type='l',axes=FALSE,xlab='',main='SST',ylab='(ºC)',pch=20,lwd=4, col=1)
lines((n-12):n,ts[(n-12):n],col="#5dade2",lwd=4)
axis(2)
axis(1,seq(1,n,12),1985:2020)
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
write.csv(T,'sst-CRW-PRIA.csv',row.names=TRUE)


plot(1:(n-12),anom[1:(n-12)],type='l',axes=FALSE,xlab='',main='SST anomalies',ylab='(ºC)',pch=20,lwd=4,xlim=c(1,n))
lines((n-12):n,anom[(n-12):n],col="#3498db",lwd=4)
#points((n-12):n,anom[(n-12):n],col=4,pch=20)
axis(2)
axis(1,seq(1,n,12),1985:2020)
box()
lines(c(-10,n+10),c(0,0))




#comparison with goes-poes
nc=nc_open('2021/sst-PRIA-2003-2020-gp.nc')
v1=nc$var[[1]]
gp=ncvar_get(nc,v1)

gp_mean=rep(NA,192)
for (i in 1:192) gp_mean[i]=mean(gp[,,i],na.rm=TRUE)

plot(1:(n-12),ts[1:(n-12)],type='l',axes=FALSE,xlab='',main='SST',ylab='(ºC)',pch=20,lwd=6, col='#95a5a6')
lines((n-12):n,ts[(n-12):n],col="#5dade2",lwd=6)
lines(253:432,gp_mean[1:180]-273.15,col=1,lwd=2)
lines(432:444,gp_mean[180:192]-273.15,col=4,lwd=2)
axis(2)
axis(1,seq(5,n,12),1985:2020)
box()
legend('bottomright',legend=c('PF5.3','geopolar'),lwd=c(6,2),col=c("#95a5a6",1))









