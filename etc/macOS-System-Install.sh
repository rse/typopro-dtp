#!/bin/sh
##
##  macOS-System-Install.sh
##

dst="/Library/Fonts"
echo "++ Installing fonts into system"
for font in ../dtp/*/*.ttf; do
    ttf=`echo $font | sed -e 's;^.*/;;'`
    echo "-- Installing font \"$ttf\""
    echo "   File-Source: $font"
    if [ -f "$dst/$ttf" ]; then
        echo "   File-Target: $dst/$ttf [REPLACE]"
        sudo rm -f "$dst/$ttf"
        sudo cp "$font" "$dst/$ttf"
    else
        echo "   File-Target: $dst/$ttf [NEW]"
        sudo cp "$font" "$dst/$ttf"
    fi
done

