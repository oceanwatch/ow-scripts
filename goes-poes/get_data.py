from ftplib import FTP
from datetime import datetime
import os 
import glob
from subprocess import *

start = datetime.now()

# log in to FTP server
ftp = FTP('ftp.star.nesdis.noaa.gov')
ftp.login() 

y=2019

ftp.cwd('/pub/socd2/coastwatch/sst_blended/sst5km/night/ghrsst/'+str(y)+'/')
    
# Get list of files in ftp directory
files = ftp.nlst()

# get list of files in our local directory
list_local=glob.glob('/mnt/r01/data/goes-poes_ghrsst/daily/*.nc')
for i in range(len(list_local)):
    list_local[i]=os.path.basename(list_local[i])
    list_local[i]=list_local[i].split('-0-360')[0]+list_local[i].split('-0-360')[1]

# find missing files
diff=list(set(files)-set(list_local))
print(diff)

if len(diff)==0:
    body="/mnt/r01/data/goes-poes_ghrsst/bin/get_data.py did not find a new daily file in ftp://ftp.star.nesdis.noaa.gov/pub/socd2/coastwatch/sst_blended/sst5km/night/ghrsst/2019/"
    print(body)
    readBody = Popen(["/bin/echo", body], stdout=PIPE)
    mail = Popen(["/bin/mail", "-s", "No new file for goes-poes-1d", "melanie.abecassis@noaa.gov"], stdin=readBody.stdout, stdout=PIPE)
    output = mail.communicate()[0]

if len(diff)>0:
    # download only missing files
    print('downloading ' + str(len(diff)) + ' file(s) for ' + str(y))
    for file in diff:
        print("Downloading..." + file)
        ftp.retrbinary("RETR " + file ,open(file, 'wb').write)
        new_file=os.path.splitext(file)[0]+"-0-360.nc"
    
        #shift longitudes to 0-360º
        call(["ncks", "-O", "--msa_usr_rdr", "-d", "lon,0.0,180.0", "-d", "lon,-180.0,0.0",file,new_file])
        call(["ncap2", "-O", "-s", "where(lon<0) lon=lon+360", new_file, new_file])
        #edit attributes
        call(["ncatted","-O","-a","valid_min,lon,o,f,0.0",new_file])
        call(["ncatted","-O","-a","valid_max,lon,o,f,360.0", new_file])
        call(["ncatted","-O","-a","westernmost_longitude,global,o,f,0.0",new_file])
        call(["ncatted","-O","-a","easternmost_longitude,global,o,f,360.0",new_file])
        #move files
        call(["mv",new_file,"/mnt/r01/data/goes-poes_ghrsst/daily/"])
        call(["rm",file])

ftp.close()

end = datetime.now()
time_diff = end - start
print('All files downloaded in ' + str(time_diff.seconds) + 's')


