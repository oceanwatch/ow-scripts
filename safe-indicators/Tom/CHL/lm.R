T=read.csv('chl-Wake.csv',header=TRUE)

time=1:dim(T)[1]
m1=lm(T$ts~time)
summary(m1) 

# 2020 mean
mean(T$ts[265:276],na.rm=TRUE)

# 2020 range
min(T$ts[265:276],na.rm=TRUE)
max(T$ts[265:276],na.rm=TRUE)

# climatological range
min(T$ts[1:264],na.rm=TRUE)
max(T$ts[1:264],na.rm=TRUE)

# 2020 mean of anom
mean(T$anom[265:276],na.rm=TRUE)

