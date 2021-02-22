#!/bin/sh
##
##  macOS-System-Uninstall.sh
##

dst="/Library/Fonts"
echo "++ Uninstalling fonts from system"
for font in ../dtp/*/*.ttf; do
    ttf=`echo $font | sed -e 's;^.*/;;'`
    echo "-- Uninstalling font \"$ttf\""
    if [ -f "$dst/$ttf" ]; then
        echo "   File-Target: $dst/$ttf [DELETE]"
        sudo rm -f "$dst/$ttf"
    fi
done

