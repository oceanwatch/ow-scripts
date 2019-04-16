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

dates=c(dates1,dates2,dates3)
lon=v1$dim[[1]]$vals
lat=v1$dim[[2]]$vals

#let's cut box to include only 15-45N instead of 5-45N
#we'll keep only lat[1:720]

box=array(NA,dim=c(1441,720,444))
for (i in 1:180) {
        box[,,i]=T1[,1:720,i]
}

for (i in 181:360) {
        box[,,i]=T2[,1:720,i-180]
}

for (i in 361:444) {
        box[,,i]=T3[,1:720,i-360]
}


#time-series : 
ts=rep(NA,444)
for (i in 1:444) ts[i]=mean(box[,,i],na.rm=TRUE)

write.csv(ts,'mean-sst-1982-2018-pf5.3-v2.dat',row.names=FALSE)




#QUATERLY DATA - FOR STF front ! Computed for Quarter 1
#jan 1982 - dec 2017
tot2=tot[,,5:424]
totq1=array(NA,dim=c(2801,1101,35))
for (i in 1:35) {
        totq1[,,i]=apply(tot2[,,((i-1)*12+1):((i-1)*12+3)],c(1,2),mean,na.rm=TRUE)
}

climq1=apply(totq1,c(1,2),mean,na.rm=TRUE)
write.table(climq1,'sst-clim-1982-2016-tot-q1.dat',row.names=FALSE,col.names=FALSE)


nc=open.ncdf('tot/sst-2017-goes-poes-tot.nc')
v1=nc$var[[1]]
T13=get.var.ncdf(nc,v1)
dates13=as.POSIXlt(v1$dim[[3]]$vals,origin='1970-01-01',tz='GMT')

#T2017=apply(T13,c(1,2),mean,na.rm=TRUE)


T2017q1=apply(T13[,,1:3],c(1,2),mean,na.rm=TRUE)
write.table(T2017q1,'sst-clim-2017-tot-q1.dat',row.names=FALSE,col.names=FALSE)


