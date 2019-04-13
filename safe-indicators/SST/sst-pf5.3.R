#Time-series of mean SST in longline fishing ground

library(ncdf4)

nc=nc_open('OceanWatch/indicators/SST/box/pf5-3-monthly_5-45N-180-240E-1982-1996.nc')
v1=nc$var[[1]]
T1=ncvar_get(nc,v1)
dates1=as.POSIXlt(v1$dim[[3]]$vals,origin='1970-01-01',tz='GMT')

nc=nc_open('OceanWatch/indicators/SST/box/pf5-3-monthly_5-45N-180-240E-1997-2011.nc')
v1=nc$var[[1]]
T2=ncvar_get(nc,v1)
dates2=as.POSIXlt(v1$dim[[3]]$vals,origin='1970-01-01',tz='GMT')

nc=nc_open('OceanWatch/indicators/SST/box/pf5-3-monthly_5-45N-180-240E-2012-2018.nc')
v1=nc$var[[1]]
T3=ncvar_get(nc,v1)
dates3=as.POSIXlt(v1$dim[[3]]$vals,origin='1970-01-01',tz='GMT')

lon=v1$dim[[1]]$vals
lat=v1$dim[[2]]$vals


dates=c(dates1,dates2,dates3)

box=array(NA,dim=c(1441,961,444))
for (i in 1:180) {
        box[,,i]=T1[,,i]
}

for (i in 181:360) {
        box[,,i]=T2[,,i-180]
}

for (i in 361:444) {
        box[,,i]=T3[,,i-360]
}


#time-series : 
ts=rep(NA,444)
for (i in 1:444) ts[i]=mean(box[,,i],na.rm=TRUE)

write.csv(ts,'mean-sst-1982-2018-pf3.dat',row.names=FALSE)




#QUATERLY DATA - FOR STF front ! Computed for Quarter 1
#jan 1982 - dec 2017
box2=box[,,1:432]
box2q1=array(NA,dim=c(1441,961,36))
for (i in 1:36) {
	print(i)
        box2q1[,,i]=apply(box2[,,((i-1)*12+1):((i-1)*12+3)],c(1,2),mean,na.rm=TRUE)
}

climq1=apply(box2q1,c(1,2),mean,na.rm=TRUE)
write.table(climq1,'sst-clim-1982-2017-pf5.3-5-45N-180-240E-q1.dat',row.names=FALSE,col.names=FALSE)

x <- ncdim_def( "Lon", "degreesE", lon)
y <- ncdim_def( "Lat", "degreesN", lat)
vsst <- ncvar_def("SST", "ºC", list(x,y), missval=999 )
nc <- nc_create( "sst-clim-1982-2017-pf5.3-5-45N-180-240E-q1.nc", list(vsst))
ncvar_put( nc, vsst, climq1 )
nc_close(nc)

system("gmt grdfilter \"sst-clim-1982-2017-pf5.3-5-45N-180-240E-q1.nc?SST\" -D0 -Fm1 -I0.1/0.1 -Gtemp.grd")
#system("gmt grdcontour temp.grd -Jm -Cchl-contour.txt -Dclim-contour-esa-1999-2017.txt -Q150")
system("gmt grdconvert temp.grd -Gsst-clim-1982-2017-pf5.3-5-45N-180-240E-q1-filtered.nc")



#2018
box3=box[,,433:444]
box3q1=apply(box3[,,1:3],c(1,2),mean,na.rm=TRUE)
write.table(box3q1,'sst-clim-2018-pf5.3-5-45N-180-240E-q1.dat',row.names=FALSE,col.names=FALSE)

x <- ncdim_def( "Lon", "degreesE", lon)
y <- ncdim_def( "Lat", "degreesN", lat)
vsst <- ncvar_def("SST", "ºC", list(x,y), missval=999 )
nc <- nc_create( "sst-clim-2018-pf5.3-5-45N-180-240E-q1.nc", list(vsst))
ncvar_put( nc, vsst, box3q1 )
nc_close(nc)

system("gmt grdfilter \"sst-clim-2018-pf5.3-5-45N-180-240E-q1.nc?SST\" -D0 -Fm1 -I0.1/0.1 -Gtemp2.grd")
#system("gmt grdcontour temp.grd -Jm -Cchl-contour.txt -Dclim-contour-esa-1999-2017.txt -Q150")
system("gmt grdconvert temp2.grd -Gsst-clim-2018-pf5.3-5-45N-180-240E-q1-filtered.nc")


