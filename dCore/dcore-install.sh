#!/bin/sh
#Warning! This is just a testing script!

#Written by LichenSymbiont -- who is not a scripter (C++ preferably).

#-------------------------------------------------------------------------------
#This program is free software: you can redistribute it and/or modify
#it under the terms of the GNU General Public License as published by
#the Free Software Foundation, either version 3 of the License, or
#(at your option) any later version.
#
#This program is distributed in the hope that it will be useful,
#but WITHOUT ANY WARRANTY; without even the implied warranty of
#MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#GNU General Public License for more details.
#
#You should have received a copy of the GNU General Public License
#along with this program.  If not, see <http://www.gnu.org/licenses/>.
#-------------------------------------------------------------------------------

#TODO:
#Colored text.
#Setup keyboard layout for TTY first!
#Find dependencies for all extra packages selected, and import them into a base.sce extension.
#In the future, you will be able to search other packages from this script, and select a bunch yourself.
#But for now, getting the basics set up is good enough, then you can install the rest in a terminal on your desktop.
#Disk partitioning with cfdisk... or something.
#Catch errors from commands and deal with them!
#Borrowing from the Arch Install Scripts!

pkg_flags="-bn"
suffic_ram=200
kernvr`uname -r`

ram=`grep MemTotal /proc/meminfo | awk '{print $2/1024}' | sed 's/\..*//'`
echo "You have $ram MB of RAM."
if [ $ram -gt $suffic_ram ]; then
pkg_flags="${pkg_flags}r"
echo "You have more than $suffic_ram MB of RAM; will use RAM to store transitory files."
fi

install_packages(){ #Install the packages:
echo "Now just wait for the package download and installation to complete."
sleep 2

sce-import $pkg_flags Xprogs
sce-import $pkg_flags gtk2
#and so on... until it contains the lib#-------------------------------------------------------------------------------

sce-import $pkg_flags $wm

sce-import $pkg_flags Xorg-$graphics

#mockup sound installation:
if [[ $sound == "alsa" ]]; then
sce-import $pkg_flags alsa-modules-${kernvr}-tinycore
sce-import $pkg_flags alsa-utils
else if [[ $sound == "oss" ]]; then

fi

#Install the extras you picked:
for s in $your_picks; do
sce-import $pkg_flags $s
done
}

echo "Set the partition you want to install dCore to (should be a Linux file-system). And if the partition you want to install to doesn't apprear, you might try your luck after rebooting and re-running this script (exit and reboot by \"sudo reboot\")."
#tce-setdrive 

wms="flwm_topside jwm fluxbox openbox icewm dwm uwm aewm++"
i=1
for s in $wms; do
echo "$i - $s"
i=`expr $i + 1`
done

echo "pick a number corresponding to your WM of choise: (or 0 to pick it yourself)"
read i

if [ $i -le 7 ] && [ $i -gt 0 ]; then
wm=$(echo $wms | awk '{print($'$i')}')
else
echo "Type the name of your WM: (must be the name of the deb package (without the verion-nr or .deb))"
read $wm
fi
echo "You picked $wm"

extras="wbar conky tilda build-essential xvesa"
echo "Pick extra programs that you'd like to install: (wbar is really useful when just using fltk_topside)"
your_picks=""
while [ 1==1 ]; do
	i=1
	for s in $extras; do
	echo "$i - $s"
	i=`expr $i + 1`
	done

	echo "Pick program: (type 0 to get on with it)"
	read i
	if not [ $i == "0" ]; then
	pick=$(echo $extras | awk '{print($'$i')}')
	extras=`echo $extras | sed "s/$pick//g"`
	your_picks="$your_picks $pick"
	else
	break
	fi
done

echo "Extra programs to be installed: $your_picks"

echo "What sound system to install?"
echo "0 - none"
echo "1 - Alsa"
echo "2 - OSS"
read i
case $i in
	0) sound="" ;;
	1) sound="alsa" ;;
	2) sound="oss" ;;
	*) sound="" ;;
esac

echo "Automate the Xorg configuration process, and start X after install? (\"y\" for yes)"
autox=""
read ans
if [[ $ans == "y" ]]; then
autox="y"
fi


#import whatever package contains lspci: (this is important for hw detection, and is a small utility, so it should probably be added to the core)
echo "Importing lspci for finding your drivers, and for making bug-reports with."
#sce-import -rbn lspci

#VGA drivers: (so "3D controller" may still be Nvidia, and require Bumblebee to function properly)
graphics=$(lspci | grep -m 1 "VGA")
case ${graphics} in
	*Intel*) graphics="intel" ;;
	*NVIDIA*) graphics="nv" ;;
	*ATI*) graphics="ati" ;;
	*) graphics="all" ;;
esac

echo "Graphics card: $graphics"

#Install the packages:
#install_packages


#Write the WM to the tc users xinitrc script: (using xinitrc instead of .initrc -- for testing)
if [ grep -m 1 "#WM:" ~/xinitrc > /dev/null 2>&1 ]; then
#replace the line under "#WM:" (+ tmpfile magic to not break sed, by writing to the file you're reading from):
sed "/#WM:/{n;s/.*/$wm/}" ~/xinitrc > tmpfile && mv tmpfile ~/xinitrc
else
printf "#WM:\n$wm\n" >> ~/xinitrc
fi

if [[ $autox == "y" ]]; then
sudo Xorg -configure
sudo mv /newconfigfile /etc/X11/um...
#could we just use Puppy's xorg startup script?
startx
else
echo "Now you can configure Xorg and the rest yourself! Have fun!"
fi

#backup
