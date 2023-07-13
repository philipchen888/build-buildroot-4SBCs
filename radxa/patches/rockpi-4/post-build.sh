#!/bin/sh

MKIMAGE=$BUILD_DIR/uboot-stable-4.4-rockpi4/tools/mkimage
RKBIN=$BUILD_DIR/../../../rkbin
BOARD_DIR="$(dirname $0)"

$MKIMAGE -n rk3399 -T rksd -d $RKBIN/bin/rk33/rk3399_ddr_800MHz_v1.20.bin $BINARIES_DIR/idbloader.img
cat $RKBIN/bin/rk33/rk3399_miniloader_v1.19.bin >> $BINARIES_DIR/idbloader.img

$RKBIN/tools/loaderimage --pack --uboot $BUILD_DIR/uboot-stable-4.4-rockpi4/u-boot-dtb.bin $BINARIES_DIR/uboot.img 0x200000 --size 1024 1

cp $RKBIN/bin/rk33/rk3399_bl31_v1.26.elf .
cat >trust.ini <<EOF
[VERSION]
MAJOR=1
MINOR=0
[BL30_OPTION]
SEC=0
[BL31_OPTION]
SEC=1
PATH=./rk3399_bl31_v1.26.elf
ADDR=0x10000
[BL32_OPTION]
SEC=0
[BL33_OPTION]
SEC=0
[OUTPUT]
PATH=trust.img
EOF

$RKBIN/tools/trust_merger --size 1024 1 trust.ini

install -m 0644 -D trust.img $BINARIES_DIR/trust.img
install -m 0644 -D $BUILD_DIR/linux-release-4.4-rockpi4/arch/arm64/boot/dts/rockpi-4b-linux.dtb $BINARIES_DIR/rockpi-4b-linux.dtb
install -m 0644 -D $BOARD_DIR/extlinux.conf $BINARIES_DIR/extlinux/extlinux.conf
