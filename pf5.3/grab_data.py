from bs4 import BeautifulSoup

import requests
log = open("output2.txt", "w")
for y in range(1981,2019):
    r  = requests.get("https://coastwatch.pfeg.noaa.gov/erddap/files/erdPH53sstn8day/"+str(y)+"/")
    data = r.text
    soup = BeautifulSoup(data)

    for link in soup.find_all('a'):
        if "_sstn.nc" in link.get('href'):
            print(str(y)+"/"+link.get('href'),file=log)
