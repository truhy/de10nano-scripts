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
export UBOOT_OUT_PATH=$SCRIPT_PATH
export UBOOT_ZIP=~/devtools/u-boot-2024.04.zip
export UBOOT_PATCH_FOLDER=u-boot-2024.04-patch
export UBOOT_BSP_GEN_FOLDER=cv_bsp_generator_202301
export UBOOT_DEFCONFIG=socfpga_de10_nano_defconfig
export UBOOT_DTS=socfpga_cyclone5_de10_nano
# Note: the QTS location depends on the selected xxx_defconfig file and the parameter CONFIG_TARGET_xxx=y,
# which is processed by arch\arm\mach-socfpga\Kconfig file, for the conditions, see section "config SYS_BOARD" and "config SYS_VENDOR"
# So for DE10-nano we could use socfpga_de10_nano_defconfig file and inside there is parameter CONFIG_TARGET_SOCFPGA_TERASIC_DE10_NANO=y,
# therefore the Kconfig file will use files in board/terasic/de10-nano/qts
#export UBOOT_QTS_FOLDER=board/is1/qts
#export UBOOT_QTS_FOLDER=board/sr1500/qts
#export UBOOT_QTS_FOLDER=board/altera/cyclone5-socdk/qts
#export UBOOT_QTS_FOLDER=board/altera/arria10-socdk/qts
#export UBOOT_QTS_FOLDER=board/altera/arria5-socdk/qts
#export UBOOT_QTS_FOLDER=board/altera/nios2/qts
#export UBOOT_QTS_FOLDER=board/altera/stratix10-socdk/qts
#export UBOOT_QTS_FOLDER=board/aries/mcvevk/qts
#export UBOOT_QTS_FOLDER=board/devboards/dbm-soc1/qts
#export UBOOT_QTS_FOLDER=board/ebv/socrates/qts
#export UBOOT_QTS_FOLDER=board/google/chameleonv3/qts
#export UBOOT_QTS_FOLDER=board/intel/agilex-n6010/qts
#export UBOOT_QTS_FOLDER=board/intel/agilex-socdk/qts
#export UBOOT_QTS_FOLDER=board/intel/agilex5-socdk/qts
#export UBOOT_QTS_FOLDER=board/intel/agilex7-socdk/qts
#export UBOOT_QTS_FOLDER=board/intel/n5x-socdk/qts
#export UBOOT_QTS_FOLDER=board/keymile/secu1/qts
#export UBOOT_QTS_FOLDER=board/softing/vining_fpga/qts
#export UBOOT_QTS_FOLDER=board/terasic/de0-nano-soc/qts
#export UBOOT_QTS_FOLDER=board/terasic/de1-soc/qts
export UBOOT_QTS_FOLDER=board/terasic/de10-nano/qts
#export UBOOT_QTS_FOLDER=board/terasic/de10-standard/qts
#export UBOOT_QTS_FOLDER=board/terasic/sockit/qts
export ARCH=arm
export CROSS_COMPILE=arm-none-eabi-

# Search path settings
export PATH=$PATH:$SCRIPT_PATH/scripts-env:$SCRIPT_PATH/scripts-linux
if [ -n "${TOOLCHAIN_PATH+x}" ]; then export PATH=$PATH:$TOOLCHAIN_PATH; fi
if [ -n "${OPENOCD_PATH+x}" ]; then export PATH=$PATH:$OPENOCD_PATH; fi

# Messages
if [ -n "${TOOLCHAIN_PATH+x}" ]; then echo "Toolchain: $TOOLCHAIN_PATH"; fi
if [ -n "${OPENOCD_PATH+x}" ];   then echo "OpenOCD  : $OPENOCD_PATH"; fi
