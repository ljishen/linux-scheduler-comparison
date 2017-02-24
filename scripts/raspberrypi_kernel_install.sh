#!/usr/bin/env bash
# This script only works for Pi 2/3.

set -eu

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

readonly FILENAME="$1"
if [ ! -f "$FILENAME" ]; then
  echo "File ${FILENAME} not found."
  exit 1
fi

install () {
  echo -e "\nuncomparess package ..."
  tar -xf "${FILENAME}"

  # start installation

  readonly KERNEL=kernel7
  echo -e "\ncopy files to / ..."
  local foldername
  foldername="${FILENAME%.*.*}"
  cp -r "${foldername}"/root/* /

  echo -e "\nbackup $KERNEL.img as $KERNEL-backup.img ..."
  cp /boot/$KERNEL.img /boot/$KERNEL-backup.img

  echo -e "\ncopy files to /boot/ ..."
  cp -r "${foldername}"/boot/* /boot/

  # do clean up
  echo -e "\ndo clean up ..."
  rm -rf "${foldername}"
}

while true; do
  read -p "Do you really want to install package \"${FILENAME}\" ? [y/n] " yn
  case $yn in
    [Yy]* )
      install
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
