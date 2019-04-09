from datetime import datetime
import os 
import glob
from subprocess import call

start = datetime.now()


dir="/mnt/r01/data/pf5.3/weekly/"

# get list of files in our local directory
list_local=glob.glob(dir+'*.nc')
list_local.sort()

for file in list_local:
    print(file)
    new_file=os.path.splitext(file)[0]+"-0-360.nc"
    #shift longitudes to 0-360º
    call(["ncks", "-O", "--msa_usr_rdr", "-d", "longitude,0.0,180.0", "-d", "longitude,-180.0,0.0",file,new_file])
    call(["ncap2", "-O", "-s", "where(longitude<0) longitude=longitude+360", new_file, new_file])
    #edit attributes
    call(["ncatted","-O","-a","valid_min,longitude,o,f,0.0",file])
    call(["ncatted","-O","-a","valid_max,longitude,o,f,360.0", file])
    call(["ncatted","-O","-a","actual_range,longitude,o,f,0.0208,359.9792", file])
    call(["ncatted","-O","-a","westernmost_longitude,global,o,f,0.0",file])
    call(["ncatted","-O","-a","easternmost_longitude,global,o,f,360.0",file])
    call(["ncatted","-O","-a","geospatial_lon_min,global,o,f,0.0208",file])
    call(["ncatted","-O","-a","geospatial_lon_max,global,o,f,359.9792",file])
    #move files
    #call(["mv",new_file,dir])
    call(["rm",file])


end = datetime.now()
time_diff = end - start
print('All files modified in ' + str(time_diff.seconds) + 's')

