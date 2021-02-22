#!/bin/sh
##
##  macOS-User-Install.sh
##

dst="$HOME/Library/Fonts"
echo "++ Installing fonts into user"
for font in ../dtp/*/*.ttf; do
    ttf=`echo $font | sed -e 's;^.*/;;'`
    echo "-- Installing font \"$ttf\""
    echo "   File-Source: $font"
    if [ -f "$dst/$ttf" ]; then
        echo "   File-Target: $dst/$ttf [REPLACE]"
        rm -f "$dst/$ttf"
        cp "$font" "$dst/$ttf"
    else
        echo "   File-Target: $dst/$ttf [NEW]"
        cp "$font" "$dst/$ttf"
    fi
done

