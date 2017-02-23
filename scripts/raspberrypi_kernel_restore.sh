#!/bin/bash -e
# Tested restoring kernel >=4.4.49-v7+ with rsync version 3.1.1

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

readonly FILENAME="$1"
if [ ! -f "$FILENAME" ]; then
  echo "File ${FILENAME} not found."
  exit 1
fi

get_mount_points () {
  local os_info p_root p_boot

  os_info="$(cat /etc/os-release 2> /dev/null)"
  if [[ ${os_info} == *"raspbian"* ]]; then
    while true; do
      read -p "Do you modify the current Raspbian OS ? [y/n] " yn
      case $yn in
        [Yy]* )
          read -p "Are you sure ? [y/n] " su
          if [[ ${su} =~ ^[Nn]*$ ]]; then
            echo -e "\nPlease restart this script to continue." >&2
            exit 1
          fi
          p_root="/"
          p_boot="/boot"
          break
          ;;
        [Nn]* )
          p_root="/media/pi/root"
          p_boot="/media/pi/boot"
          break
          ;;
        *     )
          echo "Please answer yes or no." >&2
          ;;
      esac
    done
  else
    read -p "root mount point of the restoring Raspbian OS ? " p_root
    read -p "boot mount point of the restoring Raspbian OS ? " p_boot
  fi

  if [ -z "${p_root}" ] || [ ! -d "${p_root}" ]; then
    echo -e "\nERROR: root mount point ${p_root} is invalid." >&2
    exit 1
  fi
  
  if [ -z "${p_boot}" ] || [ ! -d "${p_boot}" ]; then
    echo -e "\nERROR: boot mount point ${p_boot} is invalid." >&2
    exit 1
  fi

  echo "${p_root}" "${p_boot}"
}

restore () {
  local p_root p_boot
  mount_points=`get_mount_points`
  p_root=`echo "${mount_points}" | awk '{print $1}'`
  p_boot=`echo "${mount_points}" | awk '{print $2}'`

  echo -e "\nuncomparess package ..."
  tar -xf "${FILENAME}"

  # start restore

  echo -e "\nrestore /boot/ ..."
  local foldername
  foldername="${FILENAME%.*.*}"
  rsync --verbose --recursive --delete "${foldername}"/boot/ "${p_boot}"

  echo -e "\nrestore /lib/firmware/ ..."
  rsync --verbose --recursive --delete "${foldername}"/root/lib/firmware/ "${p_root}"/lib/firmware

  echo -e "\nrestore /lib/modules/ ..."
  rsync --verbose --recursive --delete "${foldername}"/root/lib/modules/ "${p_root}"/lib/modules

  # do clean up
  echo -e "\ndo clean up ..."
  rm -rf "${foldername}"
}


while true; do
  echo
  read -p "Do you really want to restore using package \"${FILENAME}\" ? [y/n] " yn
  case $yn in
    [Yy]* )
      restore
      echo -e "\nRestored successfully. Restart or Plug the card into the Pi and boot it!"
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
