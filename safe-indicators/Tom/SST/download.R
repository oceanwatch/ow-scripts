#script to download SST data for each archipelagic region for the SAFE report.
# from PF5.3 and geopolar blended SST

library(httr)

AS=c(-17.55,-10.05,187.45,195.05)
HB=c(0,1,183,184)
Johnston=c(16,17,190,192)
LI=c(-1,7,197,201)
MH=c(18.5,22.5,199,206)
Mariana=c(13,21,143.95,146)
PRIA=c(-1,7,183,201)
Wake=c(17.7,20.7,165,168)


names=c("AS","HB","Johnston","LI","MH","Mariana","PRIA","Wake")
coords=rbind(AS,HB,Johnston,LI,MH,Mariana,PRIA,Wake)


for (i in 1:length(names)) {
    print(names[i])
    lat=coords[i,1:2]
    lon=coords[i,3:4]
    junk=GET(paste('https://oceanwatch.pifsc.noaa.gov/erddap/griddap/pf5-3-1982-2017-mean.nc?sea_surface_temperature[(1982-01-17T00:00:00Z):1:(1982-01-17T00:00:00Z)][(',lat[2],'):1:(',lat[1],')][(',lon[1],'):1:(',lon[2],')]',sep=''), write_disk(paste("sst-",names[i],"-1982-2017-mean.nc",sep='')))
    junk=GET(paste('https://oceanwatch.pifsc.noaa.gov/erddap/griddap/pf5-3-2018-mean.nc?sea_surface_temperature[(2018-05-17T00:00:00Z):1:(2018-05-17T00:00:00Z)][(',lat[2],'):1:(',lat[1],')][(',lon[1],'):1:(',lon[2],')]',sep=''), write_disk(paste("sst-",names[i],"-2018-mean.nc",sep='')))
    junk=GET(paste('https://oceanwatch.pifsc.noaa.gov/erddap/griddap/pf5-3-monthly.nc?sea_surface_temperature[(1982-01-15T00:00:00Z):1:(2018-12-15T00:00:00Z)][(',lat[2],'):1:(',lat[1],')][(',lon[1],'):1:(',lon[2],')]',sep=''), write_disk(paste("sst-",names[i],"-1982-2018.nc",sep='')))
}
    

