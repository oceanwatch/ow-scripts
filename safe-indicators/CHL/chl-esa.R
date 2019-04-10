#climatology and anomaly of SST in longline fishing ground

library(ncdf4)

nc=nc_open('box/esa-cci-chla-monthly_5-45N-180-240E-07-1998-06-2008.nc')
v1=nc$var[[1]]
T1=ncvar_get(nc,v1)
dates1=as.POSIXlt(v1$dim[[3]]$vals,origin='1970-01-01',tz='GMT')

lon=v1$dim[[1]]$vals
lat=v1$dim[[2]]$vals

nc=nc_open('box/esa-cci-chla-monthly_5-45N-180-240E-07-2008-06-2018.nc')
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
