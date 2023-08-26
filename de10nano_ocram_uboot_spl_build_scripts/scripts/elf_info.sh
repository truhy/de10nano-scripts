#!/bin/bash

THIS_SCRIPT_PATH=`pwd`

chmod +x ./parameters.sh
source ./parameters.sh

export PATH=$GCC_ARM_ROOT/bin:$PATH

$CROSS_COMPILE"readelf" -h $BARE_ELF
$CROSS_COMPILE"readelf" --symbols $BARE_ELF
