#!/bin/sh

BOARD_DIR="$(dirname $0)"
GENIMAGE_TMP="${BUILD_DIR}/genimage.tmp"
TARGET_MAINLINE="$2"
IM_FILE=""
CLEANUPS_CMD=""

if [ "${TARGET_MAINLINE}" = "yes" ]; then
	GENIMAGE_CFG="${BOARD_DIR}/genimage-mainline.cfg"
	SIGNED_UBOOT_IMG="${BINARIES_DIR}/uboot-odc2.img"
	ODRODIDC2_ATF_FOLDER="${HOST_DIR}/usr/share/odroidc2_atf"
	IM_FILE="${ODRODIDC2_ATF_FOLDER}/bl1.bin.hardkernel"
	CLEANUPS_CMD="rm -rf ${BINARIES_DIR}/fip.bin ${BINARIES_DIR}/boot_new.bin ${BINARIES_DIR}/u-boot.img"

	${HOST_DIR}/bin/fip_create --bl30 ${ODRODIDC2_ATF_FOLDER}/bl30.bin --bl301 ${ODRODIDC2_ATF_FOLDER}/bl301.bin --bl31 ${ODRODIDC2_ATF_FOLDER}/bl31.bin --bl33 ${BINARIES_DIR}/u-boot.bin ${BINARIES_DIR}/fip.bin
	${HOST_DIR}/bin/fip_create --dump ${BINARIES_DIR}/fip.bin
	cat ${ODRODIDC2_ATF_FOLDER}/bl2.package ${BINARIES_DIR}/fip.bin > ${BINARIES_DIR}/boot_new.bin
	${HOST_DIR}/bin/amlbootsig ${BINARIES_DIR}/boot_new.bin ${BINARIES_DIR}/u-boot.img

	dd if=${BINARIES_DIR}/u-boot.img of=${SIGNED_UBOOT_IMG} bs=512 skip=96
else
	GENIMAGE_CFG="${BOARD_DIR}/genimage.cfg"
	IM_FILE="${BINARIES_DIR}/u-boot.bin"

	cp ${BOARD_DIR}/boot.ini ${BINARIES_DIR}/
fi

rm -rf "${GENIMAGE_TMP}"

genimage                           \
	--rootpath "${TARGET_DIR}"     \
	--tmppath "${GENIMAGE_TMP}"    \
	--inputpath "${BINARIES_DIR}"  \
	--outputpath "${BINARIES_DIR}" \
	--config "${GENIMAGE_CFG}"

dd if=${IM_FILE} of=${BINARIES_DIR}/sdcard.img bs=1 count=442 conv=sync,notrunc
dd if=${IM_FILE} of=${BINARIES_DIR}/sdcard.img bs=512 skip=1 seek=1 conv=fsync,notrunc

${CLEANUPS_CMD}
