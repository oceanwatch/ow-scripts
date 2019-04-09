from datetime import datetime
import os 
import glob
from subprocess import call

start = datetime.now()


# get list of files in our local directory
list_local=glob.glob('/mnt/r01/data/pf5.3/monthly/*.nc')
list_local.sort()

for file in list_local:
    print(file)
    call(["ncatted","-O","-a","valid_min,longitude,o,f,0.0",file])
    call(["ncatted","-O","-a","valid_max,longitude,o,f,360.0", file])
    call(["ncatted","-O","-a","actual_range,longitude,o,f,0.0208,359.9792", file])
    call(["ncatted","-O","-a","westernmost_longitude,global,o,f,0.0",file])
    call(["ncatted","-O","-a","easternmost_longitude,global,o,f,360.0",file])
    call(["ncatted","-O","-a","geospatial_lon_min,global,o,f,0.0208",file])
    call(["ncatted","-O","-a","geospatial_lon_max,global,o,f,359.9792",file])


end = datetime.now()
time_diff = end - start
print('All files modified in ' + str(time_diff.seconds) + 's')

