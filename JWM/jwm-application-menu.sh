#!/bin/bash

#TODO:
#*If an icon doesn't exist, icon="" shouldn't be included.
#*Enumerate the sub-categories of all .desktop files,

echo "<?xml version="1.0"?>" > jwm-menu
echo "<JWM>" >> jwm-menu
echo "<Menu icon=\"applications-other.png\" label=\"Other\">" >> jwm-menu

echo "<?xml version="1.0"?>" > jwm-menu-utils
echo "<JWM>" >> jwm-menu-utils
echo "<Menu icon=\"applications-utilities.png\" label=\"Utils\">" >> jwm-menu-utils

echo "<?xml version="1.0"?>" > jwm-menu-dev
echo "<JWM>" >> jwm-menu-dev
echo "<Menu icon=\"applications-development.png\" label=\"Dev\">" >> jwm-menu-dev

echo "<?xml version="1.0"?>" > jwm-menu-media
echo "<JWM>" >> jwm-menu-media
echo "<Menu icon=\"applications-multimedia.png\" label=\"Media\">" >> jwm-menu-media

echo "<?xml version="1.0"?>" > jwm-menu-net
echo "<JWM>" >> jwm-menu-net
echo "<Menu icon=\"applications-internet.png\" label=\"Net\">" >> jwm-menu-net

echo "<?xml version="1.0"?>" > jwm-menu-conf
echo "<JWM>" >> jwm-menu-conf
echo "<Menu icon=\"applications-system.png\" label=\"Settings\">" >> jwm-menu-conf

echo "<?xml version="1.0"?>" > jwm-menu-fun
echo "<JWM>" >> jwm-menu-fun
echo "<Menu icon=\"applications-games.png\" label=\"Fun\">" >> jwm-menu-fun


echo "*** Getting .desktop files..."
files=$(find /usr/share/applications -name "*.desktop") || (echo "WTH!"; exit)
echo "*** Building JWM Menus..."
for f in $files
do

name=$(grep -i -m 1 '^name=' $f | cut -d"=" -f2)
ico=$(grep -i -m 1 '^icon=' $f | cut -d"=" -f2 | cut -d"." -f1)

ex=$(grep -i -m 1 '^exec=' $f | cut -d"=" -f2)
echo $ex
desk_app=$(echo $ex | cut -d" " -f2)
ex=$(echo $ex | sed -e {'s/%u//g'} -e {'s/%U//g'} -e {'s/%f//g'} -e {'s/%F//g'})

echo $ex

#don't add desktop apps (apps using the %U DE variable)
if ! [ $desk_app == "%U" ]; then

category=$(grep -i -m 1 '^categories=' $f | cut -d"=" -f2)

if [ $(echo $category | grep Util) ]; then
echo "<Program icon=\"${ico}.png\" label=\"${name}\">${ex}</Program>" >> jwm-menu-utils
else
	if [ $(echo $category | grep Dev) ]; then
	echo "<Program icon=\"${ico}.png\" label=\"${name}\">${ex}</Program>" >> jwm-menu-dev
	else
		if [ $(echo $category | grep "AudioVideo\|Graphics") ]; then
		echo "<Program icon=\"${ico}.png\" label=\"${name}\">${ex}</Program>" >> jwm-menu-media
		else
			if [ $(echo $category | grep "Net") ]; then
			echo "<Program icon=\"${ico}.png\" label=\"${name}\">${ex}</Program>" >> jwm-menu-net
			else
				if [ $(echo $category | grep "Setting") ]; then
				echo "<Program icon=\"${ico}.png\" label=\"${name}\">${ex}</Program>" >> jwm-menu-conf
				else
				if [ $(echo $category | grep "Game") ]; then
				echo "<Program icon=\"${ico}.png\" label=\"${name}\">${ex}</Program>" >> jwm-menu-fun
				else
				echo "<Program icon=\"${ico}.png\" label=\"${name}\">${ex}</Program>" >> jwm-menu
				fi
				fi
			fi
		fi
	fi
fi

else
echo "${ex} not included!"
fi

done

echo "</Menu>" >> jwm-menu
echo "</JWM>" >> jwm-menu

echo "</Menu>" >> jwm-menu-utils
echo "</JWM>" >> jwm-menu-utils

echo "</Menu>" >> jwm-menu-dev
echo "</JWM>" >> jwm-menu-dev

echo "</Menu>" >> jwm-menu-media
echo "</JWM>" >> jwm-menu-media

echo "</Menu>" >> jwm-menu-net
echo "</JWM>" >> jwm-menu-net

echo "</Menu>" >> jwm-menu-conf
echo "</JWM>" >> jwm-menu-conf

echo "</Menu>" >> jwm-menu-fun
echo "</JWM>" >> jwm-menu-fun

jwm -reload

echo "*** Done!"
