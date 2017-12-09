################################################################################
#
# odroidc2-ATF
#
################################################################################

HOST_ODROIDC2_ATF_VERSION = 1dad487200543c2c1d116e8b2f070fe491070432
HOST_ODROIDC2_ATF_SITE = $(call github,hardkernel,u-boot,$(HOST_ODROIDC2_ATF_VERSION))
HOST_ODROIDC2_ATF_LICENSE = GPL-2.0
HOST_ODROIDC2_ATF_LICENSE_FILES = COPYING COPYING.txt README
HOST_ODROIDC2_ATF_FIRMWARE_FOLDER = $(HOST_DIR)/usr/share/odroidc2_atf
HOST_ODROIDC2_ATF_FIRMWARE_FILES = sd_fuse/bl1.bin.hardkernel fip/gxb/bl30.bin fip/gxb/bl301.bin fip/gxb/bl31.bin fip/gxb/bl2.package

define HOST_ODROIDC2_ATF_BUILD_CMDS
	$(MAKE) -C $(@D)/tools/fip_create CC="$(HOSTCC)" CFLAGS="$(HOST_CFLAGS)" LDFLAGS="$(HOST_LDFLAGS)"
endef

define HOST_ODROIDC2_ATF_INSTALL_CMDS
	$(INSTALL) -D -m 0755 $(@D)/tools/fip_create/fip_create $(HOST_DIR)/bin
	mkdir -p $(HOST_ODROIDC2_ATF_FIRMWARE_FOLDER)
	$(foreach f,$(HOST_ODROIDC2_ATF_FIRMWARE_FILES),
		$(INSTALL) -D -m 0644 $(@D)/$(f) $(HOST_ODROIDC2_ATF_FIRMWARE_FOLDER)/
	)
endef

$(eval $(host-generic-package))
