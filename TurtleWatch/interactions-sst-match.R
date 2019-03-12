tot=read.csv('interactions-2019.csv')

dates=strptime(tot$date,'%Y-%m-%d',tz = 'GMT')
dates_day_before=dates-3600*24

sst = rep(NA, 4)
for (i in 1:13) {
  url = paste("https://oceanwatch.pifsc.noaa.gov/erddap/griddap/goes-poes-1d-ghrsst-RAN.csv?analysed_sst[(", 
              dates_day_before[i], "):1:(", dates_day_before[i], ")][(", tot$lat[i], "):1:(", tot$lat[i], 
              ")][(", tot$lon[i], "):1:(", tot$lon[i], ")]", sep = "")
  new = read.csv(url, skip = 2, header = FALSE)
  sst = rbind(sst, new)
}
sst = sst[-1, ]
names(sst) = c("matched_date", "matched_lat", "matched_lon", "matched_sst")
