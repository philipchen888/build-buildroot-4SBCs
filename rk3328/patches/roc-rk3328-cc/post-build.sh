#!/bin/sh

MKIMAGE=$BUILD_DIR/uboot-u-boot-2023.07.y/tools/mkimage
RKBIN=$BUILD_DIR/../../../rkbin
BOARD_DIR="$(dirname $0)"

$MKIMAGE -n rk3328 -T rksd -d $RKBIN/rk33/rk3328_ddr_786MHz_v1.06.bin $BINARIES_DIR/idbloader.img
cat $RKBIN/rk33/rk3328_miniloader_v2.43.bin >> $BINARIES_DIR/idbloader.img

$RKBIN/tools/loaderimage --pack --uboot $BUILD_DIR/uboot-u-boot-2023.07.y/u-boot-dtb.bin $BINARIES_DIR/uboot.img 0x200000

cp $RKBIN/rk33/rk3328_bl31_v1.34.bin .
cat >trust.ini <<EOF
[VERSION]
MAJOR=1
MINOR=2
[BL30_OPTION]
SEC=0
[BL31_OPTION]
SEC=1
PATH=./rk3328_bl31_v1.34.bin
ADDR=0x10000
[BL32_OPTION]
SEC=0
[BL33_OPTION]
SEC=0
[OUTPUT]
PATH=trust.img
EOF

$RKBIN/tools/trust_merger trust.ini

install -m 0644 -D trust.img $BINARIES_DIR/trust.img
install -m 0644 -D $BUILD_DIR/linux-custom/arch/arm64/boot/dts/rk3328-roc-cc.dtb $BINARIES_DIR/rk3328-roc-cc.dtb
install -m 0644 -D $BOARD_DIR/extlinux.conf $BINARIES_DIR/extlinux/extlinux.conf
