setenv loadaddr "0x1080000"
setenv dtb_loadaddr "0x01000000"
setenv kernel_filename "uImage"
setenv fdt_filename "meson-gxbb-odroidc2.dtb"
setenv bootargs "console=ttyAML0,115200n8 earlyprintk root=/dev/mmcblk1p2 rootwait panic=10 ${extra} rw"

fatload mmc 0:1 ${loadaddr} ${kernel_filename}
fatload mmc 0:1 ${dtb_loadaddr} ${fdt_filename}

bootm ${loadaddr} - ${dtb_loadaddr}
