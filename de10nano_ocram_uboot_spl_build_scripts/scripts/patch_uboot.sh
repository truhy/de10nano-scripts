#!/bin/bash

# Patch (if any) u-boot source code..

THIS_SCRIPT_PATH=`pwd`

chmod +x ./parameters.sh
source ./parameters.sh

# Patch u-boot
cp $UBOOT_MODIFY/$UBOOT_DEFCONFIG ../$SOFTWARE_ROOT/$BOOTLOADER_ROOT/$UBOOT_SRC_ROOT/configs
#cp $UBOOT_MODIFY/reset_manager_gen5.c ../$SOFTWARE_ROOT/$BOOTLOADER_ROOT/$UBOOT_SRC_ROOT/arch/arm/mach-socfpga
cp $UBOOT_MODIFY/spl_gen5.c ../$SOFTWARE_ROOT/$BOOTLOADER_ROOT/$UBOOT_SRC_ROOT/arch/arm/mach-socfpga
#cp $UBOOT_MODIFY/hang.c ../$SOFTWARE_ROOT/$BOOTLOADER_ROOT/$UBOOT_SRC_ROOT/lib
