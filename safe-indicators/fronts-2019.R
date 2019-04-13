#map with climatological + 2016 location of TZCF (0.2 mg/m^3 chl a) and STF (18ºC) fronts during Quarter 1.

library(ncdf4)
source("../../../plotmaps-GMT2.R")


#Come from Onaga, SST/sst-pf5.3.R
nc=nc_open('sst-clim-1982-2017-pf5.3-5-45N-180-240E-q1-filtered.nc')
v1=nc$var[[1]]
sst=ncvar_get(nc,v1)
lon1=v1$dim[[1]]$vals
lat1=v1$dim[[2]]$vals

nc=nc_open('sst-clim-2018-pf5.3-5-45N-180-240E-q1-filtered.nc')
v1=nc$var[[1]]
sst2018=ncvar_get(nc,v1)



#sst=read.table('sst-clim-1982-2017-pf5.3-5-45N-180-240E-q1.dat',header=FALSE)
#sst=as.matrix(sst)

#sst2018=read.table('sst-clim-2018-pf5.3-5-45N-180-240E-q1.dat',header=FALSE)
#sst2018=as.matrix(sst2018)


#come from Onaga, CHL/chl-esa.R
nc=nc_open('chl-clim-1999-2017-5-45N-180-240E-esa-q1-filtered.nc')
v1=nc$var[[1]]
chl=ncvar_get(nc,v1)

lon2=v1$dim[[1]]$vals
lat2=v1$dim[[2]]$vals

nc=nc_open('chl-clim-2018-5-45N-180-240E-esa-q1-filtered.nc')
v1=nc$var[[1]]
chl2018=ncvar_get(nc,v1)


#postscript('fronts.ps',width=7.7,height=6.2)
X11(width=7.7,height=6.2)
nice.map(lon1,lat1,4)
#sst
par(new=TRUE)
contour(lon1,lat1,sst,levels=18,xaxs='i',yaxs='i',asp=1,xlim=c(180,240),ylim=c(5,45),axes=FALSE,lwd=2,col=2,lty=2,drawlabels=FALSE)
par(new=TRUE)
contour(lon1,lat1,sst2018,levels=18,labels='',xaxs='i',yaxs='i',asp=1,xlim=c(180,240),ylim=c(5,45),axes=FALSE,lwd=3,col=2,lty=1,drawlabels=FALSE)
#chl
par(new=TRUE)
contour(lon2,lat2,chl,levels=0.2,xaxs='i',yaxs='i',asp=1,xlim=c(180,240),ylim=c(5,45),axes=FALSE,lwd=2,col=4,lty=2,drawlabels=FALSE)
par(new=TRUE)
contour(lon2,lat2,chl2018,levels=0.2,xaxs='i',yaxs='i',asp=1,xlim=c(180,240),ylim=c(5,45),axes=FALSE,lwd=3,col=4,lty=1,drawlabels=FALSE)

axis(1,seq(180,240,10),c('180ºE','170ºW','160ºW','150ºW','140ºW','130ºW','120ºW'))
axis(2,seq(10,40,10),c('10ºN','20ºN','30ºN','40ºN'),las=1)


