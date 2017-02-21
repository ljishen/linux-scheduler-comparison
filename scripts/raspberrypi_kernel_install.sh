#!/bin/bash -e
# This script only work for Pi 2/3.

if [ "$#" -ne 1 ]; then
    cat <<-ENDOFMESSAGE
Please specify the installation package as argument.
Usage: $0 <package>
ENDOFMESSAGE
    exit 1
fi

if [ ! $( id -u ) -eq 0 ]; then
    echo "ERROR: $0 should be run using sudo or as the root user."
    exit 1
fi

filename="$1"
if [ ! -f "$filename" ]; then
    echo "file $filename not found."
    exit 1
fi

while true; do
    read -p "Do you really want to install package \"${filename}\" ? [y/n] " yn
    case $yn in
        [Yy]* )
            echo -e "\nuncomparess package ..."
            tar -xf "${filename}"
            
            # start installation

            KERNEL=kernel7
            echo -e "\ncopy files to / ..."
            foldername="${filename%.*.*}"
            cp -r "${foldername}"/root/* /
            
            echo -e "\nbackup $KERNEL.img as $KERNEL-backup.img ..."
            cp /boot/$KERNEL.img /boot/$KERNEL-backup.img

            echo -e "\ncopy files to /boot/ ..."
            cp -r "${foldername}"/boot/* /boot/

            # do clean up
            echo -e "\ndo clean up ..."
            rm -rf "${foldername}"

            echo -e "\nInstalled successfully. Please reboot to apply changes."
            break
            ;;
        [Nn]* )
            exit
            ;;
        *     )
            echo "Please answer yes or no."
            ;;
    esac
done
