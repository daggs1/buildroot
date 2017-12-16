#!/bin/sh
# post-build.sh for Odroid C2 taken from CubieBoard's post-build.sh
# 2013, Carlo Caione <carlo.caione@gmail.com>

BOARD_DIR="$(dirname $0)"
MKIMAGE=$HOST_DIR/bin/mkimage

# vendor u-boot uses uImage
if [ -f "${BINARIES_DIR}/Image" ]; then
    ${MKIMAGE} -A arm64 -O linux -T kernel -C none -a 0x1080000 -e 0x1080000 \
	     -n linux -d ${BINARIES_DIR}/Image ${BINARIES_DIR}/uImage
fi
