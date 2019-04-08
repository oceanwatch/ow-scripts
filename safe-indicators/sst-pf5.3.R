#Time-series of mean SST in longline fishing ground

library(ncdf4)

nc=nc_open('box/pf5-3-monthly_5-45N-180-240E-1982-1996.nc')
v1=nc$var[[1]]
T1=ncvar_get(nc,v1)
dates1=as.POSIXlt(v1$dim[[3]]$vals,origin='1970-01-01',tz='GMT')

nc=nc_open('box/pf5-3-monthly_5-45N-180-240E-1997-2011.nc')
v1=nc$var[[1]]
T2=ncvar_get(nc,v1)
dates2=as.POSIXlt(v1$dim[[3]]$vals,origin='1970-01-01',tz='GMT')

nc=nc_open('box/pf5-3-monthly_5-45N-180-240E-2012-2018.nc')
v1=nc$var[[1]]
T3=ncvar_get(nc,v1)
dates3=as.POSIXlt(v1$dim[[3]]$vals,origin='1970-01-01',tz='GMT')



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


