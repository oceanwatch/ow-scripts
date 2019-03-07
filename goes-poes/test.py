import glob
import numpy as np

tmp=np.zeros(17)
list_daily=glob.glob('/mnt/r01/data/goes-poes_ghrsst/daily/*.nc')
list_daily.sort()
i=0
for y in range(2003,2019):
    print("y = "+str(y))
    for j in range(0,len(list_daily)):
        if str(y) in list_daily[j]:
            tmp[i]=tmp[i]+1
    i=i+1

