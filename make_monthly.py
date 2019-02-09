from datetime import datetime
import os
import glob
import subprocess
import shlex
start = datetime.now()


for y in range(2002,2019):
    for m in range(1,13):

        print("Working on "+str(y)+" "+str(m)+":")
        input_string="/mnt/r01/data/goes-poes_ghrsst/daily/"+str(y)+str(f"{m:02d}")+'*.nc'
        monthly_file=str(y)+str(f"{m:02d}")+"-gp-monthly.nc"

        list1=['ncea','-v','analysed_sst,sea_ice_fraction']
        list2=glob.glob(input_string)
        command=list1+list2+[monthly_file]
        subprocess.run(command)

        subprocess.run(["mv",monthly_file,"/mnt/r01/data/goes-poes_ghrsst/monthly/"])


end = datetime.now()
time_diff = end - start
print('All files processed in ' + str(time_diff.seconds) + 's')

