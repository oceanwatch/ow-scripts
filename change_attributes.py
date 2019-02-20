from datetime import datetime
import os 
import glob
from subprocess import call

start = datetime.now()


# get list of files in our local directory
list_local=glob.glob('/mnt/r01/data/goes-poes_ghrsst/daily/*.nc')

for file in list_local:
    call(["ncatted","-O","-a","valid_min,lon,o,f,0.0",file])
    call(["ncatted","-O","-a","valid_max,lon,o,f,360.0", file])
    call(["ncatted","-O","-a","westernmost_longitude,global,o,f,0.0",file])
    call(["ncatted","-O","-a","easternmost_longitude,global,o,f,360.0",file])


end = datetime.now()
time_diff = end - start
print('All files modified in ' + str(time_diff.seconds) + 's')




#for time stamps, for the duplicate files
ncatted -O -a start_time,global,o,c,20180317T000000Z 20180321000000-gp-8day.nc
ncatted -O -a time_coverage_start,global,o,c,20180317T000000Z 20180321000000-gp-8day.nc
ncatted -O -a stop_time,global,o,c,20180318T000000Z 20180321000000-gp-8day.nc
ncatted -O -a time_coverage_end,global,o,c,20180318T000000Z 20180321000000-gp-8day.nc

