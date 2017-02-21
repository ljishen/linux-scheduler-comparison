#!/bin/bash -e
# Tested restoring kernel 4.4.50-v7+ with rsync version 3.1.1

if [ "$#" -ne 1 ]; then
    cat <<-ENDOFMESSAGE
Please specify the partial restore package as argument.
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
    read -p "Do you really want to restore using package \"${filename}\" ? [y/n] " yn
    case $yn in
        [Yy]* )
            echo -e "\nuncomparess package ..."
            tar -xf "${filename}"

            # start restore

            echo -e "\nrestore /boot/ ..."
            foldername="${filename%.*.*}"
            rsync --verbose --recursive --delete "${foldername}"/boot/ /media/pi/boot

            echo -e "\nrestore /lib/firmware/ ..."
            rsync --verbose --recursive --delete "${foldername}"/root/lib/firmware/ /media/pi/root/lib/firmware

            version=`ls "${foldername}"/root/lib/modules/`
            echo -e "\nrestore /lib/modules/${version}/ ..."
            rsync --verbose --recursive --delete "${foldername}"/root/lib/modules/"${version}/" /media/pi/root/lib/modules/"${version}"

            # do clean up
            echo -e "\ndo clean up ..."
            rm -rf "${foldername}"

            echo -e "\nRestored successfully. Plug the card into the Pi and boot it!"
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
