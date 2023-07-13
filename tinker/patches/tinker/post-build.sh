#!/bin/sh

MKIMAGE=$BUILD_DIR/uboot-release/tools/mkimage
BOARD_DIR="$(dirname $0)"

$MKIMAGE -n rk3288 -T rksd -d $BINARIES_DIR/u-boot-spl-dtb.bin $BINARIES_DIR/u-boot-spl-dtb.img
cat $BINARIES_DIR/u-boot.bin >> $BINARIES_DIR/u-boot-spl-dtb.img

install -m 0644 -D $BUILD_DIR/linux-custom/arch/arm/boot/dts/rk3288-miniarm.dtb $BINARIES_DIR/rk3288-miniarm.dtb
install -m 0644 -D $BOARD_DIR/hw_intf.conf $BINARIES_DIR/hw_intf.conf
install -m 0644 -D $BOARD_DIR/extlinux.conf $BINARIES_DIR/extlinux/extlinux.conf
