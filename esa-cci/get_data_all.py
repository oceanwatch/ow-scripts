from ftplib import FTP
from datetime import datetime
import os 
import glob
from subprocess import call

start = datetime.now()

# log in to FTP server
ftp = FTP('oceancolour.org')
ftp.login(user='oc-cci-data', passwd = 'ELaiWai8ae') 

for y in range(1997,2020):
    ftp.cwd('/occci-v3.1/geographic/netcdf/monthly/chlor_a/'+str(y)+'/')
    
    # Get list of files in ftp directory
    files = ftp.nlst()

    # get list of files in our local directory
    list_local=glob.glob('/mnt/r01/data/esa-cci_chla/monthly/*.nc')
    for i in range(len(list_local)):
        list_local[i]=os.path.basename(list_local[i])
        list_local[i]=list_local[i].split('-0-360')[0]+list_local[i].split('-0-360')[1]

    # find missing files
    diff=list(set(files)-set(list_local))
    print(diff)
    print('downloading ' + str(len(diff)) + ' file(s) for ' + str(y))

    # download only missing files
    for file in diff:
        print("Downloading..." + file)
        ftp.retrbinary("RETR " + file ,open(file, 'wb').write)
        
        new_file=os.path.splitext(file)[0]+"-0-360.nc"

        #shift longitudes to 0-360º
        call(["ncks", "-O", "--msa_usr_rdr", "-d", "lon,0.0,180.0", "-d", "lon,-180.0,0.0",file,new_file])
        call(["ncap2", "-O", "-s", "where(lon<0) lon=lon+360", new_file, new_file])
        #edit attributes
        call(["ncatted","-O","-a","valid_min,lon,o,f,0.02083",new_file])
        call(["ncatted","-O","-a","valid_max,lon,o,f,359.9792", new_file])
        call(["ncatted","-O","-a","geospatial_lon_min,global,o,f,0.0",new_file])
        call(["ncatted","-O","-a","geospatial_lon_max,global,o,f,360.0",new_file])
        #move files
        call(["mv",new_file,"/mnt/r01/data/esa-cci_chla/monthly/"])
        call(["rm",file])
        

ftp.close()

end = datetime.now()
time_diff = end - start
print('All files downloaded in ' + str(time_diff.seconds) + 's')
