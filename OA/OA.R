library(mapdata) 
library(maptools) 
library(date)
library(lubridate)
library(dplyr)
source('../../scale.R')

T=read.csv('HA1801_underway_combined_25JUN2020.csv')

jet.colors <-colorRampPalette(c("#00007F", "blue", "#007FFF", "cyan","#7FFF7F", "yellow", "#FF7F00", "red", "#7F0000"))

x11(width=9.8, height=4.6) 

xlim=c(170,220) 
ylim=c(-20,25)

layout(matrix(c(1,2,3,0,4,0), nrow=1, ncol=2), widths=c(4,1), heights=4) 
par(mar=c(3,4,3,1)) 

land <- maps::map('world2', fill=TRUE, xlim=xlim, ylim=ylim, plot=FALSE)

ids <- sapply(strsplit(land$names, ":"), function(x) x[1]) 
bPols <- map2SpatialPolygons(land, IDs=ids, proj4string=CRS("+proj=longlat +datum=WGS84")) 
plot(bPols, col="grey", axes=FALSE,xlim=xlim,ylim=ylim,cex.axis=3, main='HA 1801') 

x=seq(120,260,10) 
axis(1,x,sapply(paste(-x+360,'ºW',sep=''), function(x) x[1])) 

y=seq(-50,50,10) 
axis(2,las=1,y,sapply(paste(y,'ºN',sep=''), function(x) x[1])) 
box() 

var=T$CO2_sw-T$CO2_atm

h=hist(var,100,plot=FALSE)
n=length(h$breaks)-1 
c=jet.colors(n)

for (i in 1:dim(T)[1]) { 
  if (!is.na(var[i])) {
    I=which(h$breaks>var[i])                          
    points(T$Longitude[i]+360,T$Latitude[i],pch=19,col=c[I[1]-1]) 

    }
}


par(mar=c(3,2,3,4))
image.scale(var, col=c, breaks=h$breaks, horiz=FALSE, yaxt="n",xlab='',ylab='',main='delta CO2') 
axis(4,las=1) 
box()


############### TIME SERIES ######################


dates=strptime(T$DateTimeLocal,format='%Y-%m-%d %H:%M')
dates2=floor_date(dates,unit = "day")
dates3=as.numeric(dates2)

par(mfrow=c(3,1),mar=c(2, 4, 2, 2))

plot(dates, T$TA,type='p',col=T$Leg,pch=20,xlab='',ylab='TA')
plot(dates, T$DIC,type='p',col=T$Leg,pch=20,xlab='',ylab='DIC')
plot(dates, T$CO2_sw,type='p',col=T$Leg,pch=20,xlab='',ylab='pcO2_sw')

par(mfrow=c(3,1),mar=c(2, 4, 2, 2))
plot(dates, T$CO2_atm,type='p',col=T$Leg,pch=20,xlab='',ylab='pcO2_atm')
plot(dates, T$pH,type='p',col=T$Leg,pch=20,xlab='',ylab='pH')
plot(dates, T$OmegaAragonite,type='p',col=T$Leg,pch=20,xlab='',ylab='O_arag')

par(mfrow=c(3,1),mar=c(2, 4, 2, 2))
plot(dates, T$Atm.Pressure,type='p',col=T$Leg,pch=20,xlab='',ylab='SLP')
plot(dates, T$Salinity,type='p',col=T$Leg,pch=20,xlab='',ylab='Sal')
plot(dates, T$Temperature,type='p',col=T$Leg,pch=20,xlab='',ylab='T')

mean_pcO2_sw=df %>%
  group_by(as.factor(dates3)) %>%
  summarise(mean_CO2_sw=mean(CO2_sw,na.rm=TRUE))
mean_pcO2_sw=data.frame(mean_pcO2_sw)

mean_pcO2_atm=df %>%
  group_by(as.factor(dates3)) %>%
  summarise(mean_CO2_atm=mean(CO2_atm,na.rm=TRUE))
mean_pcO2_atm=data.frame(mean_pcO2_atm)

daily_leg=df %>%
  group_by(as.factor(dates3)) %>%
  summarise(daily_leg=mean(Leg,na.rm=TRUE))
daily_leg=data.frame(daily_leg)

delta_pCO2=mean_pcO2_sw[,2]-mean_pcO2_atm[,2]


par(mfrow=c(3,1),mar=c(2, 4, 2, 2))
plot(unique(dates2),mean_pcO2_sw[,2],col=daily_leg[,2],type='p',pch=20,xlab='',ylab='pCO2_sw',cex=2)
plot(unique(dates2),mean_pcO2_atm[,2],col=daily_leg[,2],type='p',pch=20,xlab='',ylab='pCO2_atm',cex=2)
plot(unique(dates2),delta_pCO2,col=daily_leg[,2],type='p',pch=20,xlab='',ylab='delta_pCO2',cex=2)



### DATA MATCH ###############3


#SEA='https://oceanwatch.pifsc.noaa.gov/erddap/griddap/noaa_aoml_seascapes_8day_360.csv?CLASS'
#SEA='https://oceanwatch.pifsc.noaa.gov/erddap/griddap/noaa_aoml_4729_9ee6_ab54_360.csv?CLASS'
SAL='https://www.ncei.noaa.gov/erddap/griddap/Hycom_sfc_3d.csv?salinity'
CT='https://oceanwatch.pifsc.noaa.gov/erddap/griddap/CRW_sst_v1_0.csv?analysed_sst'
VI='https://oceanwatch.pifsc.noaa.gov/erddap/griddap/noaa_snpp_chla_monthly.csv?chlor_a'
lat=T$Latitude
lon=T$Longitude+360

tot = rep(NA, 4) 
for (i in 1:dim(T)[1]) { 
  print(c(i, dim(T)[1]))
  
  #this is where the URL is built:
  #url = paste(SEA, "[(", dates[i], "):1:(", dates[i], ")][(", lat[i], "):1:(", lat[i], ")][(", lon[i], "):1:(", lon[i], ")]", sep = "")
  #url = paste(CT, "[(", dates[i], "):1:(", dates[i], ")][(", lat[i], "):1:(", lat[i], ")][(", lon[i], "):1:(", lon[i], ")]", sep = "")
  #url = paste(SAL, "[(", dates[i], "):1:(", dates[i], ")][(0.0):1:(0.0)][(", lat[i], "):1:(", lat[i], ")][(", lon[i], "):1:(", lon[i], ")]", sep = "")
  url = paste(VI, "[(", dates[i], "):1:(", dates[i], ")][(", lat[i], "):1:(", lat[i], ")][(", lon[i], "):1:(", lon[i], ")]", sep = "")
  
  new = read.csv(url, skip = 2, header = FALSE) 
  #names(new) = c("date", "matched_lat", "matched_lon", "matched_sst") 
  tot = rbind(tot, new) 
} 
tot = tot[-1, ]
names(tot) = c("date", "matched_lat", "matched_lon", "matched_chla") 
result = data.frame(T, tot) 

## plots

breaks=seq(2.5,17.5,1)
h=hist(T2$matched_seas.m,breaks=breaks,xlab='Seascape',main='Monthly Seascape data',axes=FALSE)
#h=hist(T$matched_seas.w,breaks=breaks,xlab='Seascape',main='8-day Seascape data',axes=FALSE)
axis(2)
axis(1,3:17,3:17)
box()



## maps

x11(width=6.67, height=5.38) 

xlim=c(180,205) 
ylim=c(-20,25)

layout(matrix(c(1,2,3,0,4,0), nrow=1, ncol=2), widths=c(4,1), heights=4) 
par(mar=c(3,4,3,1)) 

land <- maps::map('world2', fill=TRUE, xlim=xlim, ylim=ylim, plot=FALSE)

ids <- sapply(strsplit(land$names, ":"), function(x) x[1]) 
bPols <- map2SpatialPolygons(land, IDs=ids, proj4string=CRS("+proj=longlat +datum=WGS84")) 
plot(bPols, col="grey", axes=FALSE,xlim=xlim,ylim=ylim,cex.axis=3, main='HA 1801') 

x=seq(120,260,10) 
axis(1,x,sapply(paste(-x+360,'ºW',sep=''), function(x) x[1])) 

y=seq(-50,50,10) 
axis(2,las=1,y,sapply(paste(y,'ºN',sep=''), function(x) x[1])) 
box() 

var=T2$matched_seas.m

h=hist(var,100,plot=FALSE)
n=length(h$breaks)-1 
c=jet.colors(n)

for (i in 1:dim(T)[1]) { 
  if (!is.na(var[i])) {
    I=which(h$breaks>var[i])                          
    points(T$Longitude[i]+360,T$Latitude[i],pch=19,col=c[I[1]-1]) 
    
  }
}


par(mar=c(3,2,3,4))
image.scale(var, col=c, breaks=h$breaks, horiz=FALSE, yaxt="n",xlab='',ylab='',main='Seascape') 
axis(4,las=1) 
box()


########### Solubility ###################################





##### LMs ########


S=read.csv('match-seas-m.csv')


class_number=4
I=which(S$matched_seas.m==class_number)

temp=S[I,]

dates=strptime(temp$DateTimeLocal,format='%Y-%m-%d %H:%M')
dates2=floor_date(dates,unit = "day")
dates3=as.numeric(dates2)

df=data.frame(temp)


mean_pcO2_sw=df %>%
  group_by(as.factor(dates3)) %>%
  summarise(mean_CO2_sw=mean(CO2_sw,na.rm=TRUE))
mean_pcO2_sw=data.frame(mean_pcO2_sw)

mean_pcO2_atm=df %>%
  group_by(as.factor(dates3)) %>%
  summarise(mean_CO2_atm=mean(CO2_atm,na.rm=TRUE))
mean_pcO2_atm=data.frame(mean_pcO2_atm)

daily_leg=df %>%
  group_by(as.factor(dates3)) %>%
  summarise(daily_leg=mean(Leg,na.rm=TRUE))
daily_leg=data.frame(daily_leg)

delta_pCO2=mean_pcO2_sw[,2]-mean_pcO2_atm[,2]


############ SEASCAPES ####################

library(ncdf4)

nc=nc_open('monthly-seascapes-2003-2019.nc')
v1=nc$var[[1]]
class=ncvar_get(nc,v1)
lon=v1$dim[[1]]$vals 
lat=v1$dim[[2]]$vals

class_mean=apply(class,c(1,2),mean,na.rm=TRUE)


x11(width=9.8, height=4.6) 

xlim=c(180,205) 
ylim=c(-16,23)

layout(matrix(c(1,2,3,0,4,0), nrow=1, ncol=2), widths=c(4,1), heights=4) 
par(mar=c(3,4,3,1)) 

land <- maps::map('world2', fill=TRUE, xlim=xlim, ylim=ylim, plot=FALSE)

ids <- sapply(strsplit(land$names, ":"), function(x) x[1]) 
bPols <- map2SpatialPolygons(land, IDs=ids, proj4string=CRS("+proj=longlat +datum=WGS84")) 
plot(bPols, col="grey", axes=FALSE,xlim=xlim,ylim=ylim,cex.axis=3, main='Mean seascape 2003-2019') 

x=seq(120,260,10) 
axis(1,x,sapply(paste(-x+360,'ºW',sep=''), function(x) x[1])) 

y=seq(-50,50,10) 
axis(2,las=1,y,sapply(paste(y,'ºN',sep=''), function(x) x[1])) 
box() 


image(lon,lat,class_mean,col=c,breaks=2.5:21.5,xlab='',ylab='',
      axes=TRUE,xaxs='i',yaxs='i',asp=1, add=TRUE)

par(mar=c(3,2,3,4))
image.scale(class_mean, col=c, breaks=2.5:21.5, horiz=FALSE, yaxt="n",xlab='',ylab='',main='class') 
axis(4,las=1) 
box()


############## Linear models ################################

###############   TA    #####################################

T2=read.csv('match-seas-m.csv',header=TRUE)

library(caTools)

set.seed(85)   #  set seed to ensure you always have same random numbers generated
sample = sample.split(T2,SplitRatio = 0.5) # splits the data in the ratio mentioned in SplitRatio. After splitting marks these rows as logical TRUE and the the remaining are marked as logical FALSE
train =subset(T2,sample ==TRUE) # creates a training dataset named train1 with rows which are marked as TRUE
test=subset(T2, sample==FALSE)

class=unique(T2$matched_seas.m)
class=class[-1] #remove NA
class=sort(class)
class=class[-7]  # class 11 only has 2 points
n=length(class)

res=array(NA,dim=c(n-1,9))

for (i in 1:(n-1)) {
  I=which(train$matched_seas.m==class[i])
  temp=train[I,]
  m1=lm(temp$TA~temp$Temperature+temp$Salinity)
  res[i,]=c(class[i],summary(m1)$coeff[1,1],summary(m1)$coeff[1,4],summary(m1)$coeff[2,1]
            ,summary(m1)$coeff[2,4],summary(m1)$coeff[3,1],summary(m1)$coeff[3,4]
            ,length(I),summary(m1)$adj.r.squared)
}
colnames(res)=c("class","intercept","p_intercept","T","p_T","S","p_S","n","adj_r_squared")


I=which(test$matched_seas.m==8)
temp=test[I,]

dates=strptime(temp$DateTimeLocal,format='%Y-%m-%d %H:%M')
dates2=floor_date(dates,unit = "day")
dates3=as.numeric(dates2)

plot(dates, temp$TA,type='p',col=1,pch=20,xlab='',ylab='TA',main="class #8")

#mods=1201.1-15.74*temp$Temperature+45.1*temp$Salinity   #4
#mods=219.39+20.71*temp$Temperature+42.38*temp$Salinity   #3
mods=567.18-6.16*temp$Temperature+55.54*temp$Salinity   #8

points(dates,mods,col=2,pch=20)
legend('topright',c("obs","model"),col=c(1,2),pch=20)



###############  pCO2   #################################

T2=read.csv('match-seas-m.csv',header=TRUE)
T3=read.csv('match-chla.w.csv',header=TRUE)
T3=cbind(T3,T2$matched_seas.m)
colnames(T3)[19]='matched_seas.m'

library(caTools)

set.seed(96)   #  set seed to ensure you always have same random numbers generated
sample = sample.split(T3,SplitRatio = 0.5) # splits the data in the ratio mentioned in SplitRatio. After splitting marks these rows as logical TRUE and the the remaining are marked as logical FALSE
train =subset(T3,sample ==TRUE) # creates a training dataset named train1 with rows which are marked as TRUE
test=subset(T3, sample==FALSE)

class=unique(T2$matched_seas.m)
class=class[-1] #remove NA
class=sort(class)
class=class[-7]  # class 11 only has 2 points
n=length(class)


res=array(NA,dim=c(n-2,14))

for (i in 1:(n-2)) {
  I=which(train$matched_seas.m==class[i])
  temp=train[I,]
  dates=strptime(temp$DateTimeLocal,format='%m/%d/%Y %H:%M')
  
  gamma=array(NA,dim=c(365,1))
  for (j in 1:365) {
    dayp=cos(2*pi*(yday(dates)-j)/365)
    #m1=lm(temp$CO2_sw~dayp+temp$Temperature+temp$Salinity-1)
    m1=lm(temp$CO2_sw~dayp+temp$Temperature+temp$Salinity+log(temp$matched_chla_w))
    gamma[j]=sqrt(mean(m1$residuals^2))
  }
    
  dayp=cos(2*pi*(yday(dates)-which.min(gamma))/365)
  #m1=lm(temp$CO2_sw~dayp+temp$Temperature+temp$Salinity-1)
  m1=lm(temp$CO2_sw~dayp+temp$Temperature+temp$Salinity+log(temp$matched_chla_w))
  
  res[i,]=c(class[i],summary(m1)$coeff[1,1],summary(m1)$coeff[1,4]
            ,summary(m1)$coeff[2,1],summary(m1)$coeff[2,4],which.min(gamma)
            ,summary(m1)$coeff[3,1],summary(m1)$coeff[3,4]
            ,summary(m1)$coeff[4,1],summary(m1)$coeff[4,4]
            ,summary(m1)$coeff[5,1],summary(m1)$coeff[5,4]
            ,length(I),summary(m1)$adj.r.squared)
}
colnames(res)=c("class","intercept","p_intercept","dayp","p_dayp","gamma","T","p_T","S","p_S","chl","p_chl","n","adj_r_squared")
res=data.frame(res)


bias=rep(NA,dim(res)[1])
par(mfrow=c(dim(res)[1]/2,2))

for (i in 1:dim(res)[1]) {
  I=which(test$matched_seas.m==res$class[i])
  temp=test[I,]
  
  dates=strptime(temp$DateTimeLocal,format='%m/%d/%Y %H:%M')
  
  plot(dates, temp$CO2_sw,type='p',col=1,pch=20,xlab='',ylab='pCO2',main=paste("class #",res$class[i]))
  #,ylim=c(350,480))
  
  dayp=cos(2*pi*(yday(dates)-res$gamma[i]/365))
  
  #mods=-527.19718-385-200.4888*dayp-8.137549*temp$Temperature+42.94864*temp$Salinity+46.607676*log(temp$matched_chla_w)   #3
  #mods=-409.0083-482+253.097*dayp+15.55027*temp$Temperature+17.4555*temp$Salinity+2.54172*log(temp$matched_chla_w)   #4
  #mods=-49.43808-541-282.5967*dayp+11.121397*temp$Temperature+11.65735*temp$Salinity+3.768643*log(temp$matched_chla_w)   #8
  #mods=251.952*dayp+10.5073*temp$Temperature+9.6431*temp$Salinity-482.3   #8
  mods=res$intercept[i]+res$dayp[i]*dayp+res$T[i]*temp$Temperature+res$S[i]*temp$Salinity+res$chl[i]*log(temp$matched_chla_w)
  bias[i]=mean(mods,na.rm=TRUE)-mean(temp$CO2_sw,na.rm=TRUE)
  mods=res$intercept[i]-bias[i]+res$dayp[i]*dayp+res$T[i]*temp$Temperature+res$S[i]*temp$Salinity+res$chl[i]*log(temp$matched_chla_w)
  
  points(dates,mods,col=2,pch=20)
  legend('bottomright',c("obs","model"),col=c(1,2),pch=20)

}

################## in-situ/satellite match-up ####################################

T4=read.csv('match-sst.csv',header=TRUE)

plot(T3$Temperature,T4$matched_sst,pch=20,xlab='in-situ T',ylab='satellite SST'
     ,xlim=c(25,31),ylim=c(25,31))
lines(24:32,24:32)

T5=read.csv('match-salinity.csv',header=TRUE)

plot(T3$Salinity,T5$matched_sal,pch=20,xlab='in-situ S',ylab='HYCOM S'
     ,xlim=c(33,36),ylim=c(33,36))
lines(32:37,32:37)


################ model maps #######################################################

library(ncdf4)
library(httr)
library(abind)
library(raster)


xlim=c(180,205) 
ylim=c(-16,23)



junk <- GET('https://oceanwatch.pifsc.noaa.gov/erddap/griddap/CRW_sst_v1_0_monthly.nc?analysed_sst[(2018-01-01T12:00:00Z):1:(2018-12-01T12:00:00Z)][(-16):1:(23)][(180):1:(205)]'
            , write_disk("sst.nc", overwrite=TRUE))

nc=nc_open('sst.nc')
v1=nc$var[[1]]
sst=ncvar_get(nc,v1)
lon=v1$dim[[1]]$vals 
lat=v1$dim[[2]]$vals

dates=as.POSIXlt(v1$dim[[3]]$vals,origin='1970-01-01',tz='GMT') 

junk <- GET('https://oceanwatch.pifsc.noaa.gov/erddap/griddap/noaa_aoml_4729_9ee6_ab54_360.nc?CLASS[(2018-01-01T12:00:00Z):1:(2018-12-01T12:00:00Z)][(-16):1:(23)][(180):1:(205)]'
            , write_disk("seas_m.nc", overwrite=TRUE))

nc=nc_open('seas_m.nc')
v1=nc$var[[1]]
class=ncvar_get(nc,v1)
class_r=brick('seas_m.nc')


# Salinity : manual download because data every few hours, hits proxy limits.
#junk <- GET('https://www.ncei.noaa.gov/erddap/griddap/Hycom_sfc_3d.nc?salinity[(2018-01-01T12:00:00Z):1:(2018-12-01T12:00:00Z)][(0.0):1:(0.0)][(-16):1:(23)][(180):1:(205)]'
#            , write_disk("sss.nc", overwrite=TRUE))

nc=nc_open('sss1.nc')
v1=nc$var[[1]]
sss1=ncvar_get(nc,v1)

dates1=as.POSIXlt(v1$dim[[4]]$vals,origin='1970-01-01',tz='GMT') 
dates_sss1=dates1[-(1197:1201)]
dates_sss1=strptime(dates_sss1,format='%Y-%m-%d %H:%M')


nc=nc_open('sss2.nc')
v1=nc$var[[1]]
sss2=ncvar_get(nc,v1)

dates2=as.POSIXlt(v1$dim[[4]]$vals,origin='1970-01-01',tz='GMT') 
dates_sss2=dates2[-(1197:1201)]
dates_sss2=strptime(dates_sss2,format='%Y-%m-%d %H:%M')

sss=abind(sss1,sss2,along=3)
dates_sss=c(dates_sss1,dates_sss2)

sss_m=array(NA,dim=c(313,489,9))  ## MISSING OCT-DEC, NCEI ERDDAP having issues
for (i in 1:9) {
  I=which(month(dates_sss)==i)
  sss_m[,,i]=apply(sss[,,I],c(1,2),mean,na.rm=TRUE)  
}

lon2=v1$dim[[1]]$vals 
lat2=v1$dim[[2]]$vals

m=rep(NA,9)
for (i in 1:9) {
  m[i]=paste(20180,i,"01",sep='')
}
dates_m=as.numeric(ymd(m))*3600*24

tdim <- ncdim_def("time","seconds since 1970-01-01T00:00:00Z", dates_m, unlim=TRUE)
londim <- ncdim_def("lon","degrees_east",as.double(lon2))
latdim <- ncdim_def("lat","degrees_north",as.double(lat2))
tmp_def <- ncvar_def("sss","psu",list(londim,latdim,tdim),prec="single")
ncout <- nc_create('sss-monthly.nc',list(tmp_def),force_v4=TRUE)
ncvar_put(ncout,tmp_def,sss_m)
nc_close(ncout)


sss_m_r=brick('sss-monthly.nc')
sst_r=brick('sst.nc')

#plot(sss_m_r[[1]],col=jet.colors(30))
#plot(sst_r[[1]],col=jet.colors(30))


# Resample SSS onto SST grid
# You can choose which type of resampling you want done as well, but I just went with the default bilinear here but you can choose a nearest neightbor as well
sss_m_resampled <- resample(sss_m_r, sst_r)
plot(sss_m_resampled[[1]],col=jet.colors(30))


# CHLA
junk <- GET('https://oceanwatch.pifsc.noaa.gov/erddap/griddap/esa-cci-chla-monthly-v4-2.nc?chlor_a[(2018-01-01T12:00:00Z):1:(2018-12-01T12:00:00Z)][(23):1:(-16)][(180):1:(205)]'
            , write_disk("chl.nc", overwrite=TRUE))


nc=nc_open('chl.nc')
v1=nc$var[[1]]
chl=ncvar_get(nc,v1)
lon3=v1$dim[[1]]$vals 
lat3=v1$dim[[2]]$vals

chl_r=brick('chl.nc')
chl_resampled <- resample(chl_r, sst_r,method="ngb")
plot(chl_r[[1]],col=jet.colors(30))


#################################################################
##################   TA    ####################################
library(oceanmap)

res=read.csv('res-TA.csv',header=TRUE)

i=8

TA=raster2matrix(class_r[[i]])
sst_temp=raster2matrix(sst_r[[i]])
sss_temp=raster2matrix(sss_m_resampled[[i]])

for (i in 1:dim(res)[1]) {
  I=which(TA==res$class[i])
  TA[I]=res$intercept[i]+res$T[i]*sst_temp[I]+res$S[i]*sss_temp[I]
}

TA[TA<30]=NA


xlim=c(180,205) 
ylim=c(-16,23)

layout(matrix(c(1,2,3,0,4,0), nrow=1, ncol=2), widths=c(4,1), heights=4) 
par(mar=c(3,4,3,1)) 

land <- maps::map('world2', fill=TRUE, xlim=xlim, ylim=ylim, plot=FALSE)

ids <- sapply(strsplit(land$names, ":"), function(x) x[1]) 
bPols <- map2SpatialPolygons(land, IDs=ids, proj4string=CRS("+proj=longlat +datum=WGS84")) 
plot(bPols, col="grey", axes=FALSE,xlim=xlim,ylim=ylim,cex.axis=3, main='TA - August 2018') 

x=seq(120,260,10) 
axis(1,x,sapply(paste(-x+360,'ºW',sep=''), function(x) x[1])) 

y=seq(-50,50,10) 
axis(2,las=1,y,sapply(paste(y,'ºN',sep=''), function(x) x[1])) 
box() 


h=hist(TA,100,plot=FALSE)
n=length(h$breaks)-1 
c=jet.colors(n)

image(lon,lat,TA,breaks=h$breaks,col=c,add=TRUE)


par(mar=c(3,2,3,4))
image.scale(TA, col=c, breaks=h$breaks, horiz=FALSE, yaxt="n",xlab='',ylab='',main='TA') 
axis(4,las=1) 
box()


#################################################################
##################   pCO2    ####################################

res2=read.csv('res2-pCO2.csv',header=TRUE)

i=8

seas=raster2matrix(class_r[[i]])
pCO2=raster2matrix(class_r[[i]])
sst_temp=raster2matrix(sst_r[[i]])
sss_temp=raster2matrix(sss_m_resampled[[i]])
chl_temp=raster2matrix(chl_resampled[[i]])

#x11()
#par(mfrow=c(2,2))
#image(lon,lat,pCO2,col=c,main='Seascape')
#image(lon,lat,sst_temp,col=c,main='SST')
#image(lon,lat,sss_temp,col=c,main='SSS')
#image(lon,lat,log(chl_temp),col=c,main='log(Chl-a)')




for (i in 1:dim(res2)[1]) {

  I=which(pCO2==res2$class[i])
  dayp=cos(2*pi*(yday(dates[i])-res2$gamma[i])/365)
  pCO2[I]=res2$intercept[i]+res2$dayp[i]*dayp+res2$T[i]*sst_temp[I]+res2$S[i]*sss_temp[I]+res2$chl[i]*log(chl_temp[I])
  #+res2$bias[i]

}


pCO2[pCO2<30]=NA


xlim=c(180,205) 
ylim=c(-16,23)

layout(matrix(c(1,2,3,0,4,0), nrow=1, ncol=2), widths=c(4,1), heights=4) 
par(mar=c(3,4,3,1)) 

land <- maps::map('world2', fill=TRUE, xlim=xlim, ylim=ylim, plot=FALSE)

ids <- sapply(strsplit(land$names, ":"), function(x) x[1]) 
bPols <- map2SpatialPolygons(land, IDs=ids, proj4string=CRS("+proj=longlat +datum=WGS84")) 
plot(bPols, col="grey", axes=FALSE,xlim=xlim,ylim=ylim,cex.axis=3, main='pCO2 - August 2018') 

x=seq(120,260,10) 
axis(1,x,sapply(paste(-x+360,'ºW',sep=''), function(x) x[1])) 

y=seq(-50,50,10) 
axis(2,las=1,y,sapply(paste(y,'ºN',sep=''), function(x) x[1])) 
box() 


h=hist(pCO2,100,plot=FALSE)
n=length(h$breaks)-1 
c=jet.colors(n)

image(lon,lat,pCO2,breaks=h$breaks,col=c,add=TRUE)


par(mar=c(3,2,3,4))
image.scale(pCO2, col=c, breaks=h$breaks, horiz=FALSE, yaxt="n",xlab='',ylab='',main='pCO2') 
axis(4,las=1) 
box()






