#!/bin/bash

set -e

DEST=bin

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

download_bin terraform https://releases.hashicorp.com/terraform/0.11.13/terraform_0.11.13_linux_amd64.zip terraform/bin