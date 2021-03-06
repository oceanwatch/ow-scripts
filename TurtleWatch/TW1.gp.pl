#!/usr/bin/perl
#
# This is a perl script to generate TurtleWatch daily maps.
#
# Author - Melanie Abecassis (melanie.abecassis@noaa.gov)
# 12/21/16
#
system("umask 022");
system("rm sst.nc");
system("rm sst-celsius.nc");
system("rm myplot.png today.png");
system("rm contour*.txt");
system("rm temp.grd");
system("rm temp.png");

system("R CMD BATCH newTW2-simplfied-q50-goes-poes.R");
system("composite -geometry +75+275 \\( myplot.png -resize 190% \\) TurtleWatch_Template_V1.0.png temp.png");
system("convert temp.png -background \"#FFFFFF\" -flatten today.png");
system("chmod 644 today.png");

($sec,$min,$hour,$mday,$mon,$year,$wday,$yday,$isdst) = localtime(); $year += 1900; $mon++;
system("cp today.png archive/TW-${mon}-${mday}-${year}.png");
$subject = "TurtleWatch map for $mon/$mday/$year";
system("mutt -s \"$subject\" -a today.png -- melanie.abecassis\@noaa.gov < message.txt");

