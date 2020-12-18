#script to download CHL data for each archipelagic region for the SAFE report.
# from OC-CCI v4.2

library(httr)

AS=c(-17.55,-10.05,187.45,195.05)
HB=c(0,1,183,184)
Johnston=c(16,17,190,192)
LI=c(-1,7,197,201)
MH=c(18.5,22.5,199,206)
Mariana=c(13,21,143.95,146)
PRIA=c(-1,7,183,201)
Wake=c(17.7,20.7,165,168)


names=c("AS","Johnston","MH","Mariana","PRIA","Wake")
coords=rbind(AS,Johnston,MH,Mariana,PRIA,Wake)
#names=c("AS","HB","Johnston","LI","MH","Mariana","PRIA","Wake")
#coords=rbind(AS,HB,Johnston,LI,MH,Mariana,PRIA,Wake)


for (i in 1:length(names)) {
    print(names[i])
    lat=coords[i,1:2]
    lon=coords[i,3:4]
    junk=GET(paste('https://oceanwatch.pifsc.noaa.gov/erddap/griddap/esa-cci-chla-1998-2018-clim-v4-2.nc?chlor_a[(1998-01-01T00:00:00Z):1:(1998-01-01T00:00:00Z)][(',lat[2],'):1:(',lat[1],')][(',lon[1],'):1:(',lon[2],')]',sep=''), write_disk(paste("chl-",names[i],"-1998-2018-mean.nc",sep='')))
    junk=GET(paste('https://oceanwatch.pifsc.noaa.gov/erddap/griddap/esa-cci-chla-2019-clim-v4-2.nc?chlor_a[(2019-01-01T00:00:00Z):1:(2019-01-01T00:00:00Z)][(',lat[2],'):1:(',lat[1],')][(',lon[1],'):1:(',lon[2],')]',sep=''), write_disk(paste("chl-",names[i],"-2019-mean.nc",sep='')))
    junk=GET(paste('https://oceanwatch.pifsc.noaa.gov/erddap/griddap/esa-cci-chla-monthly-v4-2.nc?chlor_a[(1998-01-01T00:00:00Z):1:(2019-12-01T00:00:00Z)][(',lat[2],'):1:(',lat[1],')][(',lon[1],'):1:(',lon[2],')]',sep=''), write_disk(paste("chl-",names[i],"-1998-2019.nc",sep='')))
}
    

