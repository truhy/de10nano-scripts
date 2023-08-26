#!/bin/bash

# Quartus paths
export QUARTUS_BIN=$QSYS_ROOTDIR/../../bin

# Various paths
export SOFTWARE_ROOT=software
export BOOTLOADER_ROOT=bootloader
export SDCARD_IMAGE_ROOT=sdcard_image
export UBOOT_SRC_ROOT=u-boot-socfpga
export UBOOT_SRC_ZIP_FOLDER=u-boot-2022.10
export UBOOT_SRC_ZIP=~/DevTools/u-boot-2022.10.zip
export UBOOT_MODIFY=other/u-boot-2022-10-modify

# DE10-Nano
export UBOOT_DEFCONFIG=socfpga_de10_nano_defconfig
export UBOOT_QTSFILTER_OUTPUT=board/terasic/de10-nano/qts/
export UBOOT_QTSFILTER_SOC_TYPE=cyclone5
export UBOOT_DTS=socfpga_cyclone5_de10_nano

# Cyclone 5 (generic)
#export UBOOT_DEFCONFIG=socfpga_cyclone5_defconfig
#export UBOOT_QTSFILTER_OUTPUT=board/altera/cyclone5-socdk/qts/
#export UBOOT_QTSFILTER_SOC_TYPE=cyclone5

# GNU ARM tool chain (i.e. Compiler)
export GCC_ARM_ROOT=~/DevTools/xpack-arm-none-eabi-gcc-12.2.1-1.2
export CROSS_COMPILE=arm-none-eabi-

# Linaro ARM tool chain (i.e. Compiler)
#export GCC_ARM_ROOT=~/gcc-linaro-7.5.0-2019.12-x86_64_arm-eabi
#export CROSS_COMPILE=arm-eabi-

# Baremetal program
export BARE_ELF=./your_app.elf
export BARE_BIN=your_app.bin

