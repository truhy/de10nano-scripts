#!/bin/bash

# Get this script's path
SCRIPT_PATH=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" &> /dev/null && pwd)
# Get the parent folder path (one level up) from this script's path
SCRIPT_PATH="$(dirname "$SCRIPT_PATH")"

# Tools settings
TOOLCHAIN_PATH=~/devtools/xpack-arm-none-eabi-gcc-13.2.1-1.1/bin
OPENOCD_PATH=~/devtools/xpack-openocd-0.12.0-2/bin

# Bare-metal settings
export BM_OUT_PATH=$SCRIPT_PATH
export BM_HOME_PATH=$SCRIPT_PATH

# U-Boot settings
export UBOOT_OUT_PATH=~/sw-out
export UBOOT_ZIP=~/devtools/u-boot-2024.04.zip
export UBOOT_PATCH_FOLDER=u-boot-2024.04-patch
export UBOOT_BSP_GEN_FOLDER=cv_bsp_generator_202301
export UBOOT_DEFCONFIG=socfpga_de10_nano_defconfig
export UBOOT_DTS=socfpga_cyclone5_de10_nano
export ARCH=arm
export CROSS_COMPILE=arm-none-eabi-

# Search path settings
export PATH=$PATH:$SCRIPT_PATH/scripts-env:$SCRIPT_PATH/scripts-linux
if [ -n "${TOOLCHAIN_PATH+x}" ]; then export PATH=$PATH:$TOOLCHAIN_PATH; fi
if [ -n "${OPENOCD_PATH+x}" ]; then export PATH=$PATH:$OPENOCD_PATH; fi

# Messages
if [ -n "${TOOLCHAIN_PATH+x}" ]; then echo "Toolchain: $TOOLCHAIN_PATH"; fi
if [ -n "${OPENOCD_PATH+x}" ];   then echo "OpenOCD  : $OPENOCD_PATH"; fi
