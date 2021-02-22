#!/bin/sh
##
##  macOS-User-Uninstall.sh
##

dst="$HOME/Library/Fonts"
echo "++ Uninstalling fonts from user"
for font in ../dtp/*/*.ttf; do
    ttf=`echo $font | sed -e 's;^.*/;;'`
    echo "-- Uninstalling font \"$ttf\""
    if [ -f "$dst/$ttf" ]; then
        echo "   File-Target: $dst/$ttf [DELETE]"
        rm -f "$dst/$ttf"
    fi
done

