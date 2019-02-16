from datetime import datetime
import os 
import glob
import subprocess
start = datetime.now()


list_daily=glob.glob('/mnt/r01/data/goes-poes_ghrsst/daily/*.nc')
list_daily.sort()


# get list of files in our local directory
list_8day=glob.glob('/mnt/r01/data/goes-poes_ghrsst/8day/*.nc')
list_8day.sort()

last_8d_file=int(os.path.basename(list_8day[-1]).split('-')[0])
#index of last file in daily list
I = [i for i, s in enumerate(list_daily) if str(last_8d_file) in s]
start=I[0]+1 #we'll start with the next file

#each 8-day file will be the average of day - 4 to day + 3

for i in range(start,len(list_daily)-4):
        
        tmp_list=list_daily[i-4:i+4]

        print("Working on \n"+str(tmp_list))

        base=os.path.basename(list_daily[i])
        new_file=base.split('-')[0]+"-gp-8day.nc"
        
        list1=['ncea','-v','analysed_sst,sea_ice_fraction']
        list2=tmp_list
        command=list1+list2+[new_file]

        subprocess.run(command)
        subprocess.run(["mv",new_file,"/mnt/r01/data/goes-poes_ghrsst/8day/"])


end = datetime.now()
time_diff = end - start
print('All files processed in ' + str(time_diff.seconds) + 's')


