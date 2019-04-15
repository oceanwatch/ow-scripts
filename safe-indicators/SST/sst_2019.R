#climatology and anomaly maps of SST in longline fishing ground

source('../../../plotmaps-GMT2.R')
source('../../../scale.R')


library(ncdf4)
library(httr)

#junk <- GET('https://oceanwatch.pifsc.noaa.gov/erddap/griddap/pf5-3-1982-2018-mean.nc?sea_surface_temperature[(55):1:(0)][(120):1:(260)]', write_disk("pf5.3-1982-2018-0-55N-120-260E-mean.nc"))

nc=nc_open('pf5.3-1982-2017-0-55N-120-260E-mean.nc')
v1=nc$var[[1]]
clim=ncvar_get(nc,v1)
lon=v1$dim[[1]]$vals
lat=v1$dim[[2]]$vals

#climatology
breaks=seq(0,31,0.05)
n=length(breaks)-1

#define a color palette
jet.colors <-colorRampPalette(c("blue", "#007FFF", "cyan","#7FFF7F", "yellow", "#FF7F00", "red", "#7F0000"))
#set color scale using the jet.colors palette
c=jet.colors(n)

#X11(width=12.8,height=5.45)
layout(matrix(c(1,2,3,0,4,0), nrow=1, ncol=2), widths=c(9,1), heights=4)

par(mar=c(3,3,3,1))
image(lon,rev(lat),clim[,dim(clim)[2]:1],col=c,breaks=breaks,xlab='',ylab='',axes=FALSE,xaxs='i',yaxs='i',asp=1,xlim=c(120,260),ylim=c(0,55),main='Climatology : 1982 - 2017')
par(new=TRUE)
nice.map(lon,rev(lat),4)
lines(c(180,240),c(5,5),lwd=7)
lines(c(180,240),c(45,45),lwd=7)
lines(c(180,180),c(5,45),lwd=7)
lines(c(240,240),c(5,45),lwd=7)
lines(c(180,240),c(5,5),lwd=5.5,col="white")
lines(c(180,240),c(45,45),lwd=5.5,col="white")
lines(c(180,180),c(5,45),lwd=5.5,col="white")
lines(c(240,240),c(5,45),lwd=5.5,col="white")
axis(2)
axis(1,seq(120,260,10),c(seq(120,180,10),seq(190,260,10)-360))
box()

par(mar=c(3,1,3,3))
image.scale(clim, col=c, breaks=breaks, horiz=FALSE,xlab='',ylab='',main='ºC',yaxt='n',las=1)
axis(4,seq(0,30,5),las=2,tick=TRUE)
box()


#anomaly


nc=nc_open('pf5.3-2018-0-55N-120-260E-mean.nc')
v1=nc$var[[1]]
sst_2018=ncvar_get(nc,v1)
lon=v1$dim[[1]]$vals
lat=v1$dim[[2]]$vals

anom=sst_2018-clim


breaks=c(-8,seq(-3,3,0.01),8)
n=length(breaks)-1

#define a color palette
br.colors <-colorRampPalette(c("blue", "cyan","white", "#FF6666", "red"))

#set color scale using the jet.colors palette
c=br.colors(n)

#X11(width=10.3,height=4.6)
layout(matrix(c(1,2,3,0,4,0), nrow=1, ncol=2), widths=c(9,1), heights=4)

par(mar=c(3,3,3,1))
image(lon,rev(lat),anom[,dim(anom)[2]:1],col=c,breaks=breaks,xlab='',ylab='',axes=FALSE,xaxs='i',yaxs='i',asp=1,xlim=c(120,260),ylim=c(0,55),main='2018 Anomaly')
par(new=TRUE)
nice.map(lon,rev(lat),4)
lines(c(180,240),c(5,5),lwd=7)
lines(c(180,240),c(45,45),lwd=7)
lines(c(180,180),c(5,45),lwd=7)
lines(c(240,240),c(5,45),lwd=7)
lines(c(180,240),c(5,5),lwd=5.5,col="white")
lines(c(180,240),c(45,45),lwd=5.5,col="white")
lines(c(180,180),c(5,45),lwd=5.5,col="white")
lines(c(240,240),c(5,45),lwd=5.5,col="white")
axis(2)
axis(1,seq(120,260,10),c(seq(120,180,10),seq(190,260,10)-360))
box()


par(mar=c(3,1,3,3))
image.scale(anom, col=c, breaks=breaks, horiz=FALSE,xlab='',ylab='',main='ºC',yaxt='n',las=1)
axis(4,las=1)
#axis(4,at=seq(-4,4,1),c(-8,seq(-3,3,1),8),las=1)
box()


#time-series
T=read.table('mean-sst-1982-2018-pf3.dat',header=TRUE)
n=dim(T)[1]

plot(1:(n-12),T[1:(n-12),1],type='l',axes=FALSE,xlab='',main='SST',ylab='(ºC)',pch=20,lwd=6, col='#95a5a6')
#plot(1:(n-12),T[1:(n-12),1],type='l',axes=FALSE,xlab='',main='SST',ylab='(ºC)',pch=20,lwd=3, col=1)
lines((n-12):n,T[(n-12):n,1],col="#5dade2",lwd=6)
#points((n-12):n,T[(n-12):n,1],col=4,pch=20)
axis(2)
axis(1,seq(5,n,12),1982:2018)
box()

#comparison with goes-poes
nc=nc_open('goes-poes-monthly-ghrsst-RAN_5-45N-180-240E-2003-2018.nc')
v1=nc$var[[1]]
gp=ncvar_get(nc,v1)
gp=gp[,,-1]
gp_mean=rep(NA,192)
for (i in 1:192) gp_mean[i]=mean(gp[,,i],na.rm=TRUE)

lines(253:432,gp_mean[1:180]-273.15,col=1,lwd=2)
lines(432:444,gp_mean[180:192]-273.15,col=4,lwd=2)

legend('topleft',legend=c('PF5.3','geopolar'),lwd=c(6,2),col=c("#95a5a6",1))

n=length(T[,1])

# anomaly
m=rep(NA,12)
for (i in 1:12) {
    ind=seq(i,n,12)
    m[i]=mean(T[ind,1])
}

y=n/12  #  # of years

mtot=rep(m,y)
#lines(1:n,mtot,col=2,lwd=2)

anom=T-mtot
plot(1:(n-12),anom[1:(n-12),1],type='l',axes=FALSE,xlab='',main='SST anomalies',ylab='(ºC)',pch=20,lwd=3,xlim=c(1,n))
lines((n-12):n,anom[(n-12):n,1],col="#3498db",lwd=3)
#points((n-12):n,anom[(n-12):n],col=4,pch=20)
axis(2)
axis(1,seq(1,n,12),1982:2018)
box()
lines(c(-10,n+10),c(0,0))



