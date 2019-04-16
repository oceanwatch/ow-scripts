
source('../../../../plotmaps-GMT2.R')
source('../../../../scale.R')
library(ncdf4)

nc=nc_open('2019/sst-AS-1982-2017-mean.nc')
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

x11(width=8.18,height=7.21)
layout(matrix(c(1,2,3,0,4,0), nrow=1, ncol=2), widths=c(5,1), heights=4)
layout.show(2)

par(mar=c(3,3,3,1))
image(lon,rev(lat),clim[,dim(clim)[2]:1],col=c,breaks=breaks,xlab='',ylab='',axes=FALSE,xaxs='i',yaxs='i',asp=1,xlim=c(min(lon),max(lon)),ylim=c(min(lat),max(lat)),main='Climatology : 1982 - 2017')
par(new=TRUE)
nice.map(lon,rev(lat),1)
axis(2)
#axis(1)
axis(1,seq(188,195,1),seq(188,195,1)-360)
box()


par(mar=c(3,1,3,4))
image.scale(clim, col=c, breaks=breaks, horiz=FALSE,xlab='',ylab='',main='ºC',yaxt='n',las=1)
#axis(4,at=seq(5,25,5),seq(5,25,5),las=1)
axis(4,las=1)
box()


#anomaly

nc=nc_open('2019/sst-AS-2018-mean.nc')
v1=nc$var[[1]]
sst_2018=ncvar_get(nc,v1)
lon=v1$dim[[1]]$vals
lat=v1$dim[[2]]$vals

anom=sst_2018-clim

h=hist(anom, 100, plot=FALSE)

breaks=seq(-0.55,0.55,0.001)
#breaks=c(seq(-0.67,-0.38,0.001),0,seq(0.38,0.67,0.001))
n=length(breaks)-1

#define a color palette
br.colors <-colorRampPalette(c("blue", "cyan","white", "#FF6666", "red"))

#set color scale using the jet.colors palette
c=br.colors(n)

#X11(width=10.3,height=4.6)
layout(matrix(c(1,2,3,0,4,0), nrow=1, ncol=2), widths=c(5,1), heights=4)
layout.show(2)

par(mar=c(3,3,3,1))
image(lon,rev(lat),anom[,dim(anom)[2]:1],col=c,breaks=breaks,xlab='',ylab='',axes=FALSE,xaxs='i',yaxs='i',asp=1,xlim=c(min(lon),max(lon)),ylim=c(min(lat),max(lat)),main='2018 Anomaly')
par(new=TRUE)
nice.map(lon,rev(lat),1)
axis(2)
#axis(1)
axis(1,seq(188,195,1),seq(188,195,1)-360)
box()


par(mar=c(3,1,3,4))
image.scale(anom, col=c, breaks=breaks, horiz=FALSE,xlab='',ylab='',main='ºC',yaxt='n',las=1)
axis(4,las=1)
#axis(4,at=seq(-3,3,1),seq(-3,3,1),las=1)
box()




#time-series
nc=nc_open('2019/sst-AS-1982-2018.nc')
v1=nc$var[[1]]
sst=ncvar_get(nc,v1)

ts=rep(NA,444)
for (i in 1:444) ts[i]=mean(sst[,,i],na.rm=TRUE)

n=length(ts)

plot(1:(n-12),ts[1:(n-12)],type='l',axes=FALSE,xlab='',main='SST',ylab='(ºC)',pch=20,lwd=6, col='#95a5a6')
#plot(1:(n-12),ts[1:(n-12)],type='l',axes=FALSE,xlab='',main='SST',ylab='(ºC)',pch=20,lwd=3, col=1)
lines((n-12):n,ts[(n-12):n],col="#5dade2",lwd=6)
#lines((n-12):n,ts[(n-12):n],col="#5dade2",lwd=3)
axis(2)
axis(1,seq(5,n,12),1982:2018)
box()

#comparison with goes-poes
nc=nc_open('2019/sst-AS-2003-2018-gp.nc')
v1=nc$var[[1]]
gp=ncvar_get(nc,v1)

gp_mean=rep(NA,192)
for (i in 1:192) gp_mean[i]=mean(gp[,,i],na.rm=TRUE)

lines(253:432,gp_mean[1:180]-273.15,col=1,lwd=2)
lines(432:444,gp_mean[180:192]-273.15,col=4,lwd=2)
legend('bottomright',legend=c('PF5.3','geopolar'),lwd=c(6,2),col=c("#95a5a6",1))


# anomaly
m=rep(NA,12)
for (i in 1:12) {
    ind=seq(i,n,12)
    m[i]=mean(ts[ind],na.rm=TRUE)
}

y=n/12  #  # of years

mtot=rep(m,y)

anom=ts-mtot
plot(1:(n-12),anom[1:(n-12)],type='l',axes=FALSE,xlab='',main='SST anomalies',ylab='(ºC)',pch=20,lwd=3,xlim=c(1,n))
lines((n-12):n,anom[(n-12):n],col="#3498db",lwd=3)
#points((n-12):n,anom[(n-12):n],col=4,pch=20)
axis(2)
axis(1,seq(1,n,12),1982:2018)
box()
lines(c(-10,n+10),c(0,0))








