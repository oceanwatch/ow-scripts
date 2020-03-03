#Script for TZCF front for Monument report.


library(ncdf4)

nc = nc_open("esa-cci-chla-monthly-v4-2_1998-2008-18-45N-175-240E.nc")
v1 = nc$var[[1]]
T3 = ncvar_get(nc, v1)
lon2 = v1$dim[[1]]$vals
lat2= v1$dim[[2]]$vals

#QUATERLY DATA - FOR TZCF front ! Computed for Quarter 1
#jan-mar 1998-2008
chl.totq1=array(NA,dim=c(dim(T3)[1],dim(T3)[2],dim(T3)[3]/12))
for (i in 1:(dim(T3)[3]/12)) {
        print(paste("i=",i))
        chl.totq1[,,i]=apply(T3[,,((i-1)*12+1):((i-1)*12+3)],c(1,2),mean,na.rm=TRUE)
}

chl.climq1=apply(chl.totq1,c(1,2),mean,na.rm=TRUE)

nc = nc_open("esa-cci-chla-monthly-v4-2_2009-2018-18-45N-175-240E.nc")
v1 = nc$var[[1]]
T4 = ncvar_get(nc, v1)
lon2 = v1$dim[[1]]$vals
lat2= v1$dim[[2]]$vals

#jan-mar 2009-2018
chl.restq1=array(NA,dim=c(dim(T4)[1],dim(T4)[2],dim(T4)[3]/12))
for (i in 1:(dim(T4)[3]/12)) {
        print(paste("i=",i))
        chl.restq1[,,i]=apply(T4[,,((i-1)*12+1):((i-1)*12+3)],c(1,2),mean,na.rm=TRUE)
}

chl.q1=apply(chl.restq1,c(1,2),mean,na.rm=TRUE)




londim <- ncdim_def("lon","degrees_east",as.double(lon2))
latdim <- ncdim_def("lat","degrees_north",as.double(lat2))
chl_def <- ncvar_def("chl","mg/m^3",list(londim,latdim),prec="single")
ncout <- nc_create('chl-clim-1998-2008-q1.nc',list(chl_def),force_v4=TRUE)
ncvar_put(ncout,chl_def,chl.climq1)
nc_close(ncout)

londim <- ncdim_def("lon","degrees_east",as.double(lon2))
latdim <- ncdim_def("lat","degrees_north",as.double(lat2))
chl_def <- ncvar_def("chl","mg/m^3",list(londim,latdim),prec="single")
ncout <- nc_create('chl-clim-2009-2018-q1.nc',list(chl_def),force_v4=TRUE)
ncvar_put(ncout,chl_def,chl.q1)
nc_close(ncout)

system("gmt grdfilter \"chl-clim-1998-2008-q1.nc?chl\" -D0 -Fm1 -I0.1/0.1 -Gchl-clim-1998-2008-q1-filtered.nc")
system("gmt grdfilter \"chl-clim-2009-2018-q1.nc?chl\" -D0 -Fm1 -I0.1/0.1 -Gchl-clim-2009-2018-q1-filtered.nc")



