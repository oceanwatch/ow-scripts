#climatology and anomaly of SST in longline fishing ground

library(ncdf4)

nc=nc_open('OceanWatch/indicators/CHL/box/esa-cci-chla-monthly_5-45N-180-240E-07-1998-06-2008.nc')
v1=nc$var[[1]]
T1=ncvar_get(nc,v1)
dates1=as.POSIXlt(v1$dim[[3]]$vals,origin='1970-01-01',tz='GMT')

lon=v1$dim[[1]]$vals
lat=v1$dim[[2]]$vals

nc=nc_open('OceanWatch/indicators/CHL/box/esa-cci-chla-monthly_5-45N-180-240E-07-2008-06-2018.nc')
v1=nc$var[[1]]
T2=ncvar_get(nc,v1)
dates2=as.POSIXlt(v1$dim[[3]]$vals,origin='1970-01-01',tz='GMT')




box=array(NA,dim=c(1441,961,240))
for (i in 1:120) {
	box[,,i]=T1[,,i]
}

for (i in 121:240) {
	box[,,i]=T2[,,i-120]
}



#time-series : compute only on smaller box !
ts=rep(NA,240)
for (i in 1:240) ts[i]=mean(box[,,i],na.rm=TRUE)

write.csv(ts,'mean-chl-07-1997-06-2018-esa-5-45N-180-240E.dat',row.names=FALSE)




#QUATERLY DATA - FOR TZCF front ! Computed for Quarter 1
#jan 1999 - dec 2017
box2=box[,,7:234]

box2q1=array(NA,dim=c(1441,961,19))
for (i in 1:19) {
        box2q1[,,i]=apply(box2[,,((i-1)*12+1):((i-1)*12+3)],c(1,2),mean,na.rm=TRUE)
        print(paste('i=',i))
}

climq1=apply(box2q1,c(1,2),mean,na.rm=TRUE)
#write.table(climq1,'chl-clim-2003-2015-tot-q1.dat',row.names=FALSE,col.names=FALSE)

x <- ncdim_def( "Lon", "degreesE", lon)
y <- ncdim_def( "Lat", "degreesN", lat)
vchl <- ncvar_def("CHLA", "mg/m^3", list(x,y), missval=999 )
nc <- nc_create( "chl-clim-1999-2017-5-45N-180-240E-esa-q1.nc", list(vchl))
ncvar_put( nc, vchl, climq1 )
nc_close(nc)

system("gmt grdfilter \"chl-clim-1999-2017-5-45N-180-240E-esa-q1.nc?CHLA\" -D0 -Fm1 -I0.1/0.1 -Gtemp.grd")
#system("gmt grdcontour temp.grd -Jm -Cchl-contour.txt -Dclim-contour-esa-1999-2017.txt -Q150")
system("gmt grdconvert temp.grd -Gchl-clim-1999-2017-5-45N-180-240E-esa-q1-filtered.nc")


#jan - jun 2018
box3=box[,,235:240]
box3q1=apply(box3[,,1:3],c(1,2),mean,na.rm=TRUE)


x <- ncdim_def( "Lon", "degreesE", lon)
y <- ncdim_def( "Lat", "degreesN", lat)
vchl <- ncvar_def("CHLA", "mg/m^3", list(x,y), missval=999 )
nc <- nc_create( "chl-clim-2018-5-45N-180-240E-esa-q1.nc", list(vchl))
ncvar_put( nc, vchl, box3q1 )
nc_close(nc)

system("gmt grdfilter \"chl-clim-2018-5-45N-180-240E-esa-q1.nc?CHLA\" -D0 -Fm1 -I0.1/0.1 -Gtemp2.grd")
#system("gmt grdcontour temp.grd -Jm -Cchl-contour.txt -D2017-contour.txt -Q150")
system("gmt grdconvert temp2.grd -Gchl-clim-2018-5-45N-180-240E-esa-q1-filtered.nc")



