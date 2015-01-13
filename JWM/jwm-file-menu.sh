#!/bin/bash

#Refreshes/generates the file-system menu.

echo "<?xml version="1.0"?>" > jwm-file-menu
echo "<JWM>" >> jwm-file-menu

echo "<RootMenu onroot=\"3\" icon=\"applications-other.png\" label=\"Files\">" >> jwm-file-menu
echo "<Program label=\"refresh\">~/jwm-file-menu.sh</Program>" >> jwm-file-menu

echo "*** Listing home-files..."
files=$(ls -F ~) || (echo "WTH!"; exit)

#generate the home directory list
echo "<Menu icon=\"applications-other.png\" label=\"Home\">" >> jwm-file-menu

for f in $files
do

#-m 1 == match 1 and break
#name=$(grep -i -m 1 '^name=' $f | cut -d"=" -f2)
#ico=$(grep -i -m 1 '^icon=' $f | cut -d"=" -f2 | cut -d"." -f1)

if [[ $f == */ ]]; then
echo "<Program label=\"${f}\">rox -d=${f}</Program>" >> jwm-file-menu
else
	if [[ $f == *@ ]]; then
	f=${f%?}/
	echo "<Program label=\"${f}\">rox -d=${f}</Program>" >> jwm-file-menu
	fi
fi

done

echo "</Menu>" >> jwm-file-menu

#List mountable and mounted partitions:

#disks=$(fdisk -l | grep "Disk /dev/")


files=$(df -l) || (echo "do you have df?"; exit)

for f in $files
do

if [[ $f == /mnt/* ]]; then
echo "<Program label=\"${f}: ${pf}\">rox -d=${f}</Program>" >> jwm-file-menu
else
	if [[ $f == / ]]; then
	echo "<Program label=\"${f}: ${pf}\">rox -d=${f}</Program>" >> jwm-file-menu
	fi
fi

pf=$f
done


echo "</RootMenu>" >> jwm-file-menu
echo "</JWM>" >> jwm-file-menu

jwm -reload

echo "*** Done!"
