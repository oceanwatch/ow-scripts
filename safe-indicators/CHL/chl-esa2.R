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

dates=c(dates1,dates2)

#Let's keep only lats 15-45N instead of 5-45N:
# corresponding to lat[1:721]


box=array(NA,dim=c(1441,721,240))
#box=array(NA,dim=c(1441,961,240))
for (i in 1:120) {
	box[,,i]=T1[,1:721,i]
}

for (i in 121:240) {
	box[,,i]=T2[,1:721,i-120]
}



#time-series : compute only on smaller box !
ts=rep(NA,240)
for (i in 1:240) ts[i]=mean(box[,,i],na.rm=TRUE)
T=data.frame(dates,ts)

write.csv(T,'mean-chl-07-1997-06-2018-esa-15-45N-180-240E.dat',row.names=FALSE)



totq1=array(NA,dim=c(1441,721,19))
for (i in 1:14) {
        totq1[,,i]=apply(box[,,((i-1)*12+1):((i-1)*12+3)],c(1,2),mean,na.rm=TRUE)
        print(paste('i=',i))
}

climq1=apply(totq1,c(1,2),mean,na.rm=TRUE)







londim <- ncdim_def("lon","degrees_east",as.double(lon))
latdim <- ncdim_def("lat","degrees_north",as.double(lat[1:721]))
chl_def <- ncvar_def("chl","mg/m^3",list(londim,latdim),prec="single")
ncout <- nc_create('"chl-clim-1998-2017-tot-q1.nc',list(chl_def),force_v4=TRUE)
ncvar_put(ncout,chl_def,climq1)
nc_close(ncout)

system("gmt grdfilter \"chl-clim-1998-2017-tot-q1.nc?chl\" -D0 -Fm1 -I0.1/0.1 -Gchl-clim-1998-2017-tot-q1-filtered.nc")

#system("gmt grdcontour \"sst-celsius.nc?sst\" -Jm0.05i -C17.5 -Dcontour_0.2_%d.txt -Q150")
#system("gmt grdcontour \"sst-celsius.nc?sst\" -Jm0.05i -C18.6 -Dcontour_18.6_%d.txt")





