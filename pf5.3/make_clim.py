from datetime import datetime
import os 
import glob
import subprocess
start_time = datetime.now()


output_path="/mnt/r00/data/pf5.3/monthly/*.nc"
list_monthly=glob.glob(output_path)
list_monthly.sort()

#let's remove the last 4 months of 1981 and 2018 to get the full list from 1982 - 2017
list_monthly_clean=list_monthly[4:436]


output_file="pf5.3-1982-2017-clim.nc"

list1=['ncea','-v','sea_surface_temperature']
command=list1+list_monthly_clean+[output_file]

subprocess.run(command)


end_time = datetime.now()
time_diff = end_time - start_time
print('All files processed in ' + str(time_diff.seconds) + 's')


