# test to check that there are no duplicate time stamps


import glob
from subprocess import Popen, PIPE

list_daily=glob.glob('/mnt/r01/data/goes-poes_ghrsst/8day/*.nc')
list_daily.sort()
i=0
for f in list_daily[5200:]:
    p1=Popen(["ncdump", "-h", f],stdout=PIPE)
    p2=Popen(["grep", "time_coverage_end"],stdin=p1.stdout, stdout=PIPE)
    p1.stdout.close() 
    output=p2.communicate()[0]
    print(output)
