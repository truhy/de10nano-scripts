#!/bin/bash

THIS_SCRIPT_PATH=`pwd`

chmod +x ./parameters.sh
source ./parameters.sh

export PATH=$GCC_ARM_ROOT/bin:$PATH

$CROSS_COMPILE"objcopy" -O binary $BARE_ELF "other/"$BARE_BIN
