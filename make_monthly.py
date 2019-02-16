from datetime import datetime
import os 
import glob
import subprocess
start_time = datetime.now()

ndays=[31,28,31,30,31,30,31,31,30,31,30,31]
#ndays=[31,29,31,30,31,30,31,31,30,31,30,31]  #leap years

output_path="/mnt/r01/data/goes-poes_ghrsst/monthly/*.nc"
list_monthly=glob.glob(output_path)

# We'll start the processing from the last file
print("Last monthly file in the monthly directory: "+os.path.basename(list_monthly[-1]))
start=int(os.path.basename(list_monthly[-1]).split('-')[0][4:6])+1

for y in range(2019,2020):
    for i,nday in enumerate(ndays[start:]):
        m=i+start
        print("Working on "+str(y)+" "+str(m)+" with "+str(nday)+" days:")
        input_string="/mnt/r01/data/goes-poes_ghrsst/daily/"+str(y)+str(f"{m:02d}")+'*.nc'
        monthly_file=str(y)+str(f"{m:02d}")+"-gp-monthly.nc"


        list1=['ncea','-v','analysed_sst,sea_ice_fraction']
        list2=glob.glob(input_string)
        print("there are "+str(len(list2))+" daily files")
        command=list1+list2+[monthly_file]

        if len(list2)==nday:
            subprocess.run(command)
            subprocess.run(["mv",monthly_file,"/mnt/r01/data/goes-poes_ghrsst/monthly/"])


end_time = datetime.now()
time_diff = end_time - start_time
print('All files processed in ' + str(time_diff.seconds) + 's')


