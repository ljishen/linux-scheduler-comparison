#!/usr/bin/env bash
# This script helps to create Raspberry Pi kernel installation package for Pi 2/3.

set -eu

show_help () {
cat << EOF
Usage: ${0##*/} <-s SOURCE_PATH> <-t TOOLCHAIN_PATH>

Please specify the location of Raspbian kernel source as well as the toolchain.

    -h      display this help and exit
    -s      Raspbian kernel source path, e.g. /home/foo/source/linux
    -t      toolchain for building Raspbian kernel, e.g. /home/foo/tools
EOF
}

source_path=""
toolchain_path=""

OPTIND=1
# Resetting OPTIND is necessary if getopts was used previously in the script.
# It is a good idea to make OPTIND local if you process options in a function.

while getopts hs:t: opt; do
    case $opt in
        h)
            show_help
            exit 0
            ;;
        s)  source_path="${OPTARG}"
            ;;
        t)  toolchain_path="${OPTARG}"
            ;;
        *)
            show_help >&2
            exit 1
            ;;
    esac
done
shift "$((OPTIND-1))" # Shift off the options and optional --.

if [ -z "${source_path}" ] || [ -z "${toolchain_path}" ]; then
    show_help >&2
    exit 1
fi

sys_info=`strings "${source_path}"/vmlinux | grep "Linux version"`
ker_rel=`echo "${sys_info}" | cut -d ' ' -f 3`

readonly FOLDERNAME="raspberrypi-${ker_rel}"
mkdir -p "${FOLDERNAME}/root"
mkdir -p "${FOLDERNAME}/boot/overlays"

current="${PWD}"
cd "${source_path}"

readonly KERNEL=kernel7

make ARCH=arm CROSS_COMPILE="${toolchain_path}"/arm-bcm2708/gcc-linaro-arm-linux-gnueabihf-raspbian-x64/bin/arm-linux-gnueabihf- INSTALL_MOD_PATH="${current}/${FOLDERNAME}/root/" modules_install
scripts/mkknlimg arch/arm/boot/zImage "${current}/${FOLDERNAME}/boot/$KERNEL.img"
cp arch/arm/boot/dts/*.dtb "${current}/${FOLDERNAME}/boot/"
cp arch/arm/boot/dts/overlays/*.dtb* "${current}/${FOLDERNAME}/boot/overlays/"
cp arch/arm/boot/dts/overlays/README "${current}/${FOLDERNAME}/boot/overlays/"

cd "${current}"

readonly ARCHIVE="${FOLDERNAME}.tar.gz"
tar czf "${ARCHIVE}" "${FOLDERNAME}"

# do clean up
rm -rf "${FOLDERNAME}"

echo -e "\nSuccessfully created ${ARCHIVE} ."
