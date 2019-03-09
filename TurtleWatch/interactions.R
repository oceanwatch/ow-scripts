rm(list=ls())
library(ncdf4)
library(httr)
library(plotrix)
source('../../../scale.R')
jet.colors <-colorRampPalette(c("blue", "#007FFF", "cyan","#7FFF7F", "yellow", "#FF7F00", "red", "#7F0000"))


pdf('interactions.pdf',width=10.95,height=4.45,onefile=TRUE,bg='white')
T=read.csv('interactions-2019.csv',header=TRUE)

for (index in 1:dim(T)[1]) {
#i=1


#temperature basemap
junk <- GET(paste('https://oceanwatch.pifsc.noaa.gov/erddap/griddap/goes-poes-1d-ghrsst-RAN.nc?analysed_sst[(',T$date[index],')][(20):1:(45)][(185):1:(235)]',sep=''), write_disk("sst.nc"))
nc=nc_open('sst.nc')
v1=nc$var[[1]]
sst_K=ncvar_get(nc,v1)
sst_F=(sst_K-273.15)*9/5+32 
sst_c=sst_K-273.15 
sst.date1=as.POSIXlt(v1$dim[[3]]$vals,origin='1970-01-01',tz='GMT')
print(sst.date1)
sst.date2=sst.date1+1*24*3600
sst.date1=format(sst.date1,'%Y/%m/%d')
sst.date2=format(sst.date2,'%Y/%m/%d')
lon2=v1$dim[[1]]$vals
lat2=v1$dim[[2]]$vals
nc_close(nc)
rm(junk,v1)


#plot
breaks=seq(50,83,0.05)
n=length(breaks)-1
c=jet.colors(n)

#png('interactions.png',width=10.95,height=4.45, units="in",bg='white',res=96)

layout(matrix(c(1,2,3,0,4,0), nrow=1, ncol=2), widths=c(8,1), heights=4)
#layout.show(2)

par(mar=c(3,3,3,1),las=1)
image(lon2,lat2,sst_F,col=c,breaks=breaks,xlab='',ylab='',axes=FALSE,xaxs='i',yaxs='i',asp=1,main=paste("Sea Surface Temperature : ",sst.date1,sep=''),cex.main=1.1,ylim=c(20,38))
axis(1,seq(185,235,5),c("175ºW","170ºW","165ºW","160ºW","155ºW","150ºW","145ºW","140ªW","135ªW","130ºW","125ºW"))
axis(2,seq(20,35,5),c("20ºN","25ºN","30ºN","35ºN"))
box()

tdim <- ncdim_def("lat","degrees_north",as.double(lat2))
londim <- ncdim_def("lon","degrees_east",as.double(lon2))
latdim <- ncdim_def("lat","degrees_north",as.double(lat2))
tmp_def <- ncvar_def("sst","deg_C",list(londim,latdim),prec="single")
ncout <- nc_create('sst-celsius.nc',list(tmp_def),force_v4=TRUE)
ncvar_put(ncout,tmp_def,sst_c)
nc_close(ncout)


system("gmt grdcontour \"sst-celsius.nc?sst\" -Jm0.05i -C17.5 -Dcontour_17.5_%d.txt")
system("gmt grdcontour \"sst-celsius.nc?sst\" -Jm0.05i -C18.6 -Dcontour_18.6_%d.txt")

l=list.files(pattern="contour_17.5_*")
len=rep(NA,length(l))
for (i in 1:length(l)) {
    c1=read.table(l[i],header=FALSE,skip=1)
    len[i]=dim(c1)[1]
}
I=which(len==max(len))

p1=rep(NA,3)
if (length(l)>0) {
	c1=read.table(l[I],header=FALSE,skip=1)
	if (dim(c1)[1]>1) {
		lines(c1[,1]+360,c1[,2],lwd=2,col=1)
		p1=rbind(p1,c1)
	}
	if (length(l)>1) {
		l=l[-I]
		for (i in 1:length(l)) {
        		c1=read.table(l[i],header=FALSE,skip=1)
		        polygon(c1[,1]+360,c1[,2],col=rgb(204/255,0,0,1))
		}
	}

}
if (length(l)==0) {
	p1=matrix(c(225,185, 38,38),nrow=2,ncol=2,byrow=FALSE)
}
p1=p1[-1,]


l=list.files(pattern="contour_18.6_*")
len=rep(NA,length(l))
for (i in 1:length(l)) {
    c2=read.table(l[i],header=FALSE,skip=1)
    len[i]=dim(c2)[1]
}
I=which(len==max(len))

p2=rep(NA,3)
c2=read.table(l[I],header=FALSE,skip=1)
print(paste("l=",dim(c2)[1]))
if (dim(c2)[1]>1) {
	lines(c2[,1]+360,c2[,2],lwd=2)
	p2=rbind(p2,c2)
}
p2=p2[-1,]

if (length(l)>1) {
	l=l[-I]
	for (i in 1:length(l)) {
	    c2=read.table(l[i],header=FALSE,skip=1)
	    polygon(c2[,1]+360,c2[,2],col=rgb(204/255,0,0,1))
	}
}

polygon(c(p1[,1]+360,rev(p2[,1])+360),c(p1[,2],rev(p2[,2])),col=rgb(204/255,0,0,1))


#graticule

lines(c(190,190),c(10,50),lwd=2)
lines(c(195,195),c(10,50),lwd=2)
lines(c(200,200),c(10,50),lwd=2)
lines(c(205,205),c(10,50),lwd=2)
lines(c(210,210),c(10,50),lwd=2)
lines(c(215,215),c(10,50),lwd=2)
lines(c(220,220),c(10,50),lwd=2)
lines(c(225,225),c(10,50),lwd=2)
lines(c(230,230),c(10,50),lwd=2)
lines(c(180,240),c(20,20),lwd=2)
lines(c(180,240),c(25,25),lwd=2)
lines(c(180,240),c(30,30),lwd=2)
lines(c(180,240),c(35,35),lwd=2)

#contour labels
#I=which(sst_c>=16.9 & sst_c<=17.1,arr.ind=TRUE)
I=which(sst_c>=17.4 & sst_c<=17.6,arr.ind=TRUE)
x=which(lon2[I[,1]]>=212.9 & lon2[I[,1]]<=213.1)
ind=I[x[1],]
if (lat2[ind[2]]<38) boxed.labels(lon2[ind[1]],lat2[ind[2]],'17.5',bg="white",border=NA)

I=which(sst_c>=18.4 & sst_c<=18.6,arr.ind=TRUE)
x=which(lon2[I[,1]]>=186 & lon2[I[,1]]<=187)
ind=I[x[1],]
if (lat2[ind[2]]<38) boxed.labels(lon2[ind[1]],lat2[ind[2]],'18.5',bg="white",border=NA)

points(T$lon[index],T$lat[index],pch=20,cex=1.8)

#scale
par(mar=c(3,1,3,3),las=1)
image.scale(sst_F, col=c, breaks=breaks, horiz=FALSE, yaxt="n",xlab='',ylab='',main='SST (ºF)')
axis(4)
box()

contour_files=dir(path = '.', pattern = "^contour")
file.remove("sst-celsius.nc","sst.nc",contour_files)

}
dev.off()





