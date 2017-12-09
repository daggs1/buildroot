################################################################################
#
# meson-tools
#
################################################################################

HOST_MESON_TOOLS_VERSION = 5e01cbadc6f6f21ad88a63492a83182fc4b19d37
HOST_MESON_TOOLS_SITE = $(call github,afaerber,meson-tools,$(HOST_MESON_TOOLS_VERSION))
HOST_MESON_TOOLS_LICENSE = GPL-2.0+
HOST_MESON_TOOLS_LICENSE_FILES = COPYING README.md
HOST_MESON_TOOLS_DEPENDENCIES = host-openssl

HOST_MESON_TOOLS_PROGS = amlbootsig unamlbootsig amlinfo

define HOST_MESON_TOOLS_BUILD_CMDS
	$(MAKE) -C $(@D) CC="$(HOSTCC)" CFLAGS="$(HOST_CFLAGS)" LDFLAGS="$(HOST_LDFLAGS) -lssl -lcrypto"
endef

define HOST_MESON_TOOLS_INSTALL_CMDS
	$(foreach f,$(HOST_MESON_TOOLS_PROGS),
		$(INSTALL) -D -m 0755 $(@D)/$(f) $(HOST_DIR)/bin/$(f))
endef

$(eval $(host-generic-package))
