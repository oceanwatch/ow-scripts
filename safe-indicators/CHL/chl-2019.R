#climatology and anomaly maps of SST in longline fishing ground

source('../../../plotmaps-GMT2.R')
source('../../../scale.R')

library(ncdf4)


nc=nc_open('esa-cci-chla-1998-2017-0-55N-120-260E-clim.nc')
v1=nc$var[[1]]
clim=ncvar_get(nc,v1)
lon=v1$dim[[1]]$vals
lat=v1$dim[[2]]$vals



#climatology
breaks=seq(-3.5,2.5,0.025)
n=length(breaks)-1

#define a color palette
jet.colors <-colorRampPalette(c("blue", "#007FFF", "cyan","#7FFF7F", "yellow", "#FF7F00", "red", "#7F0000"))
#set color scale using the jet.colors palette
c=jet.colors(n)

X11(width=12.8,height=5.45)
layout(matrix(c(1,2,3,0,4,0), nrow=1, ncol=2), widths=c(9,1), heights=4)

par(mar=c(3,3,3,1))
image(lon,rev(lat),log(clim[,dim(clim)[2]:1]),col=c,breaks=breaks,xlab='',ylab='',axes=FALSE,xaxs='i',yaxs='i',asp=1,xlim=c(120,260),ylim=c(0,55),main='Climatology : July 1998 - June 2017')
par(new=TRUE)
nice.map(lon,rev(lat),4)
lines(c(180,240),c(15,15),lwd=7)
lines(c(180,240),c(45,45),lwd=7)
lines(c(180,180),c(15,45),lwd=7)
lines(c(240,240),c(15,45),lwd=7)
lines(c(180,240),c(15,15),lwd=5.5,col="white")
lines(c(180,240),c(45,45),lwd=5.5,col="white")
lines(c(180,180),c(15,45),lwd=5.5,col="white")
lines(c(240,240),c(15,45),lwd=5.5,col="white")
axis(2)
axis(1,seq(120,260,10),c(seq(120,180,10),seq(190,260,10)-360))
box()


par(mar=c(3,1,3,3))
image.scale(clim, col=c, breaks=breaks, horiz=FALSE,xlab='',ylab='',main='',yaxt='n',las=1)
axis(4,at=log(c(0.03,0.05,0.1,0.2,0.5,1,2,3,5,10)),c(0.03,0.05,0.1,0.2,0.5,1,2,3,5,10),las=1)
box()

##################################################################################################################################3
#anomaly

nc=nc_open('esa-cci-chla-2017-2018-0-55N-120-260E-clim.nc')
v1=nc$var[[1]]
chl=ncvar_get(nc,v1)
lon=v1$dim[[1]]$vals
lat=v1$dim[[2]]$vals


anom=chl-clim



breaks=c(-10,seq(-0.25,0.25,0.005),10)
n=length(breaks)-1

#define a color palette
br.colors <-colorRampPalette(c("blue", "cyan","white", "#FF6666", "red"))

#set color scale using the jet.colors palette
c=br.colors(n)

layout(matrix(c(1,2,3,0,4,0), nrow=1, ncol=2), widths=c(9,1), heights=4)

par(mar=c(3,3,3,1))
image(lon,rev(lat),anom[,dim(anom)[2]:1],col=c,breaks=breaks,xlab='',ylab='',axes=FALSE,xaxs='i',yaxs='i',asp=1,xlim=c(120,260),ylim=c(0,55),main='July 2017 - June 2018 Anomaly')
par(new=TRUE)
nice.map(lon,rev(lat),4)
lines(c(180,240),c(15,15),lwd=7)
lines(c(180,240),c(45,45),lwd=7)
lines(c(180,180),c(15,45),lwd=7)
lines(c(240,240),c(15,45),lwd=7)
lines(c(180,240),c(15,15),lwd=5.5,col="white")
lines(c(180,240),c(45,45),lwd=5.5,col="white")
lines(c(180,180),c(15,45),lwd=5.5,col="white")
lines(c(240,240),c(15,45),lwd=5.5,col="white")
axis(2)
axis(1,seq(120,260,10),c(seq(120,180,10),seq(190,260,10)-360))

par(mar=c(3,0,3,4))
image.scale(anom, col=c, breaks=c(-0.3,seq(-0.25,0.25,0.005),0.3), horiz=FALSE,xlab='',ylab='',main='',yaxt='n',las=1)
axis(4,at=c(-0.3,seq(-0.25,0.25,0.05),0.3),labels=c(-10,seq(-0.25,0.25,0.05),10),las=1)
box()

###################################################################################################################################################

T=read.table('mean-chl-07-1997-06-2018-esa-15-45N-180-240E.dat',header=TRUE)
n=dim(T)[1]

plot(1:(n-12),T[1:(n-12),1],type='l',axes=FALSE,xlab='',main='Chl a conc.',ylab='(mg/m^3)',lwd=3,xlim=c(1,n))
lines((n-12):n,T[(n-12):n,1],col="#3498db",lwd=3)
#points((n-12):n,T[(n-12):n,5],col=4,pch=20)
axis(2)
axis(1,seq(7,n,12),1999:2018)
box()

# anomaly
m=rep(NA,12)
for (i in 1:12) {
    ind=seq(i,n,12)
    m[i]=mean(T[ind,1])
}

y=n/12  #  # of years

mtot=rep(m,y)
lines(1:n,mtot,col=2,lwd=2)

anom=T[,1]-mtot
plot(1:(n-12),anom[1:(n-12)],type='l',axes=FALSE,xlab='',main='Chl a conc. anomalies',ylab='(mg/m^3)',lwd=3,xlim=c(1,n))
lines((n-12):n,anom[(n-12):n],col="#3498db",lwd=3)
#points((n-12):n,anom[(n-12):n],col=4,pch=20)
axis(2)
axis(1,seq(7,n,12),1999:2018)
box()
lines(c(-10,n+10),c(0,0))


