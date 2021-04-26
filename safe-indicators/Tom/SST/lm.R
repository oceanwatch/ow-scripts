T=read.csv('sst-CRW-Wake.csv',header=TRUE)


time=1:dim(T)[1]
m1=lm(T$ts~time)
summary(m1)

# 2020 mean
mean(T$ts[421:432],na.rm=TRUE)

# 2020 range
min(T$ts[421:432],na.rm=TRUE)
max(T$ts[421:432],na.rm=TRUE)

# climatological range
min(T$ts[1:420],na.rm=TRUE)
max(T$ts[1:420],na.rm=TRUE)

# 2020 mean of anom
mean(T$anom[421:432],na.rm=TRUE)

