from datetime import datetime
import os 
import glob
import subprocess
start_time = datetime.now()


output_path="/mnt/r01/data/esa-cci_chla/monthly/*.nc"
list_monthly=glob.glob(output_path)
list_monthly.sort()

#let's keep July 1998 to June 2017 and July 2017 to June 2018 since 2018 isn't complete.
#list_monthly_clean=list_monthly[10:238]
list_monthly_clean=list_monthly[239:250]


#output_file="esa-cci_chla-07-1998-06-2017-clim.nc"
output_file="esa-cci_chla-07-2017-06-2018-clim.nc"

list1=['ncea','-v','chlor_a']
command=list1+list_monthly_clean+[output_file]

subprocess.run(command)


end_time = datetime.now()
time_diff = end_time - start_time
print('All files processed in ' + str(time_diff.seconds) + 's')

