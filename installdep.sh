#!/bin/bash

set -e

DEST=$3

function download_bin() {
    if [ -f $DEST/$1 ]; then
        echo "$1 is already installed"
    else
        echo "Installing $1"
        local TEMP=`mktemp`
        curl $2 -o $TEMP
        unzip $TEMP -d $DEST
        rm $TEMP
        echo "$1 installed ok"
    fi
}

mkdir -p $DEST

download_bin $1 $2