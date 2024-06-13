#!/bin/bash

change_wallpaper () {
	echo "set background"
	gsettings set org.gnome.desktop.background picture-uri $1
	echo "set dark mode background"
	gsettings set org.gnome.desktop.background picture-uri-dark $1
}

change_screensaver () {
	echo "set lockscreen background"
	gsettings set org.gnome.desktop.screensaver picture-uri $1
#	gsettings set org.gnome.desktop.screensaver picture-uri-dark $1
}

adjoin () {
		srcdir=$1
		wallsdir=$srcdir/HD
		echo "taking and adjoining wallpapers from " $wallsdir
		rm -f $walls_dir/mydesktop.jpg $walls_dir/mylogin.jpg
		selection1=$(find $walls_dir -type f -name "*.jpg" -o -name "*.png" | shuf -n1)
		selection2=$(find $walls_dir -type f -name "*.jpg" -o -name "*.png" | shuf -n1)
		selection3=$(find $walls_dir -type f -name "*.jpg" -o -name "*.png" | shuf -n1)
		selection4=$(find $walls_dir -type f -name "*.jpg" -o -name "*.png" | shuf -n1)
		montage $selection1 $selection2 -adjoin -geometry 1920x1080 $walls_dir/mydesktop.jpg
		montage $selection3 $selection4 -adjoin -geometry 1920x1080 $walls_dir/mylogin.jpg
		#gsettings set org.gnome.desktop.background picture-uri "file://$walls_dir/mydesktop.jpg"
		#gsettings set org.gnome.desktop.screensaver picture-uri "file://$walls_dir/mylogin.jpg"
		desktop=$walls_dir/mydesktop.jpg
		login=$walls_dir/mylogin.jpg
		change_wallpaper "file://$desktop"	
		change_screensaver "file://$login"
}

srcdir="$HOME/Pictures/Wallpaper"
resolution=$(xdpyinfo | grep dimensions | awk '{print $2}')
dualres="3840x1080"
hdres="1920x1080"
if [ "$resolution" == "$dualres" ]; then
	adjoin=0 #$(shuf -i0-1 -n1)
	echo "resolution = " $resolution
	echo "adjoin = " $adjoin
	if [ $adjoin == 1 ]; then
		adjoin $srcdir
	else
		walls_dir="$srcdir/DualHD"
		echo "taking wallpapers from " $walls_dir
		desktop=$(find $walls_dir -type f -name "*.jpg" -o -name "*.png" | shuf -n1)
		#gsettings set org.gnome.desktop.background picture-uri "file://$desktop"
		change_wallpaper "file://$desktop"	
		login=$(find $walls_dir -type f -name "*.jpg" -o -name "*.png" | shuf -n1)
		change_screensaver "file://$login"
		#gsettings set org.gnome.desktop.screensaver picture-uri "file://$login"
	fi
elif [ "$resolution" == "$hdres" ]; then
	walls_dir="$srcdir/HD"
	desktop=$(find $walls_dir -type f -name "*.jpg" -o -name "*.png" | shuf -n1)
	change_wallpaper "file://$desktop"	
#gsettings set org.gnome.desktop.background picture-uri "file://$desktop"
	login=$(find $walls_dir -type f -name "*.jpg" -o -name "*.png" | shuf -n1)
	change_screensaver "file://$login"
	#gsettings set org.gnome.desktop.screensaver picture-uri "file://$login"
else
	echo "Resolution is neither HD nor DualHD"
fi

