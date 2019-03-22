tot=read.csv('2019-03-21_DRAFT.csv',header=TRUE)

dates=strptime(tot$interaction_date,'%Y-%m-%d',tz = 'GMT')
dates_day_before=dates-3600*24
lon=tot$Dec_Long +360
lat=tot$Dec_Lat

sst = rep(NA, 4)
for (i in 1:20) {
  if (!is.na(lat[i])) {
    url = paste("https://oceanwatch.pifsc.noaa.gov/erddap/griddap/goes-poes-1d-ghrsst-RAN.csv?analysed_sst[(", 
                dates_day_before[i], "):1:(", dates_day_before[i], ")][(", lat[i], "):1:(", lat[i], 
                ")][(", lon[i], "):1:(", lon[i], ")]", sep = "")
    new = read.csv(url, skip = 2, header = FALSE)
    sst = rbind(sst, new)
  }
}
sst = sst[-1, ]
names(sst) = c("matched_date", "matched_lat", "matched_lon", "matched_sst")