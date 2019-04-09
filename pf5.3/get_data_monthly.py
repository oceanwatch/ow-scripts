#!/usr/bin/env python
# -*- coding: utf-8 -*-

from subprocess import call

#file output.txt generated from Anaconda. with script VM/OceanWatch/PF5.3/grab_data.py

file = open('output3.txt','r')
for line in file:   
    call(['wget', 'https://coastwatch.pfeg.noaa.gov/erddap/files/erdPH53sstnmday/' + line.strip()])
