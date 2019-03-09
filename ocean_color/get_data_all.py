from bs4 import BeautifulSoup
import requests
from subprocess import call
import os
import shutil



################### MONTHLY DATA #################################################################

#make list of files at oceandata:
page  = requests.get("https://oceandata.sci.gsfc.nasa.gov/SeaWiFS/Mapped/Monthly/9km/chlor_a/")
soup = BeautifulSoup(page.text,'html.parser')

f = open("listM.txt","w") 
list1M=[] 
for y in range(1997,2020):
    for link in soup.find_all('a'):
        text=link.get('href')
        if ("S"+str(y) in str(text)):
            f.write(text+"\n") 
            list1M.append(text.split('/')[5])

f.close()


#get list of files in /mnt/r00/data/seawifs_chla/data/monthly
list2M=os.listdir('/mnt/r00/data/seawifs_chla/data/monthly')
for i in range(len(list2M)):
    list2M[i]=os.path.basename(list2M[i])
    list2M[i]=list2M[i].split('-0-360')[0]+list2M[i].split('-0-360')[1]


#compare the 2 lists of files to see if there are new files in oceandata
diffM=list(set(list1M)-set(list2M))
diffM.sort()

if (len(diffM)>0):
    for f in diffM:   
        call(['wget', 'https://oceandata.sci.gsfc.nasa.gov/cgi/getfile/'+f])
        new_file=os.path.splitext(f)[0]+"-0-360.nc"
        #switch longitudes
        call(["ncks", "-O", "--msa_usr_rdr", "-d", "lon,0.0,180.0", "-d", "lon,-180.0,0.0",f,new_file])
        call(["ncap2", "-O", "-s", "where(lon<0) lon=lon+360", new_file, new_file])
        #edit attributes
        call(["ncatted","-O","-a","valid_min,lon,o,f,0.0",new_file])
        call(["ncatted","-O","-a","valid_max,lon,o,f,360.0", new_file])
        call(["ncatted","-O","-a","westernmost_longitude,global,o,f,0.0",new_file])
        call(["ncatted","-O","-a","easternmost_longitude,global,o,f,360.0",new_file])
        call(["ncatted","-O","-a","geospatial_lon_max,global,o,f,360.0",new_file])
        call(["ncatted","-O","-a","geospatial_lon_min,global,o,f,0.0",new_file])
        call(["ncatted","-O","-a","sw_point_longitude,global,o,f,0.04166667",new_file])
        #let's move the new files to /mnt/r00/data/seawifs_chla/data/monthly
        call(["mv",new_file,"/mnt/r00/data/seawifs_chla/data/monthly"])       
        call(["rm",f])



################### WEEKLY DATA #################################################################

#make list of files at oceandata:
for y in range(1997,2020):
    page  = requests.get("https://oceandata.sci.gsfc.nasa.gov/SeaWiFS/Mapped/8-Day/9km/chlor_a/"+str(y)+"/")
    soup = BeautifulSoup(page.text,'html.parser')
    
    f = open("list8d.txt","w")
    list18d=[]
    for link in soup.find_all('a'):
        text=link.get('href')
        if ("S"+str(y) in str(text)):
            f.write(text+"\n")
            list18d.append(text.split('/')[5])
    
    f.close()
    
    
    #get list of files in /mnt/r00/data/seawifs_chla/data/weekly
    list28d=os.listdir('/mnt/r00/data/seawifs_chla/data/weekly')
    for i in range(len(list28d)):
        list28d[i]=os.path.basename(list28d[i])
        list28d[i]=list28d[i].split('-0-360')[0]+list28d[i].split('-0-360')[1]


    #compare the 2 lists of files to see if there are new files in oceandata
    diff8d=list(set(list18d)-set(list28d))
    diff8d.sort()

    if (len(diff8d)>0):
        for f in diff8d:
            call(['wget', 'https://oceandata.sci.gsfc.nasa.gov/cgi/getfile/'+f])
            new_file=os.path.splitext(f)[0]+"-0-360.nc"
            #switch longitudes
            call(["ncks", "-O", "--msa_usr_rdr", "-d", "lon,0.0,180.0", "-d", "lon,-180.0,0.0",f,new_file])
            call(["ncap2", "-O", "-s", "where(lon<0) lon=lon+360", new_file, new_file])
            #edit attributes
            call(["ncatted","-O","-a","valid_min,lon,o,f,0.0",new_file])
            call(["ncatted","-O","-a","valid_max,lon,o,f,360.0", new_file])
            call(["ncatted","-O","-a","westernmost_longitude,global,o,f,0.0",new_file])
            call(["ncatted","-O","-a","easternmost_longitude,global,o,f,360.0",new_file])
            call(["ncatted","-O","-a","geospatial_lon_max,global,o,f,360.0",new_file])
            call(["ncatted","-O","-a","geospatial_lon_min,global,o,f,0.0",new_file])
            call(["ncatted","-O","-a","sw_point_longitude,global,o,f,0.04166667",new_file])
            #let's move the new files to /mnt/r00/data/seawifs_chla/data/weekly
            call(["mv",new_file,"/mnt/r00/data/seawifs_chla/data/weekly"])          
            call(["rm",f])


####################### DAILY DATA ###########################################

for y in range(1997,2020):
    page  = requests.get("https://oceandata.sci.gsfc.nasa.gov/SeaWiFS/Mapped/Daily/9km/chlor_a/"+str(y)+"/")
    soup = BeautifulSoup(page.text,'html.parser')

    f = open("listd.txt","w")
    list1d=[]
    for link in soup.find_all('a'):
        text=link.get('href')
        if ("S"+str(y) in str(text)):
            f.write(text+"\n")
            list1d.append(text.split('/')[5])

    f.close()


    #get list of files in /mnt/r00/data/seawifs_chla/data/daily
    list2d=os.listdir('/mnt/r00/data/seawifs_chla/data/daily')
    for i in range(len(list2d)):
        list2d[i]=os.path.basename(list2d[i])
        list2d[i]=list2d[i].split('-0-360')[0]+list2d[i].split('-0-360')[1]


    #compare the 2 lists of files to see if there are new files in oceandata
    diffd=list(set(list1d)-set(list2d))
    diffd.sort()

    if (len(diffd)>0):
        for f in diffd:
            call(['wget', 'https://oceandata.sci.gsfc.nasa.gov/cgi/getfile/'+f])
            new_file=os.path.splitext(f)[0]+"-0-360.nc"
            #switch longitudes
            call(["ncks", "-O", "--msa_usr_rdr", "-d", "lon,0.0,180.0", "-d", "lon,-180.0,0.0",f,new_file])
            call(["ncap2", "-O", "-s", "where(lon<0) lon=lon+360", new_file, new_file])
            #edit attributes
            call(["ncatted","-O","-a","valid_min,lon,o,f,0.0",new_file])
            call(["ncatted","-O","-a","valid_max,lon,o,f,360.0", new_file])
            call(["ncatted","-O","-a","westernmost_longitude,global,o,f,0.0",new_file])
            call(["ncatted","-O","-a","easternmost_longitude,global,o,f,360.0",new_file])
            call(["ncatted","-O","-a","geospatial_lon_max,global,o,f,360.0",new_file])
            call(["ncatted","-O","-a","geospatial_lon_min,global,o,f,0.0",new_file])
            call(["ncatted","-O","-a","sw_point_longitude,global,o,f,0.04166667",new_file])
            #let's move the new files to /mnt/r00/data/seawifs_chla/data/daily
            call(["mv",new_file,"/mnt/r00/data/seawifs_chla/data/daily"])
            call(["rm",f])

