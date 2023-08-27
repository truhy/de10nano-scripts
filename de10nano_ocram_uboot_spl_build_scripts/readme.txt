Truong Hy.  26/08/2023

Linux Bash shell scripts to build U-Boot for OpenOCD board initialisation
-------------------------------------------------------------------------

Contains Bash shell scripts for building U-Boot (actually U-Boot-SPL) for use with OpenOCD to configure the
Terasic DE-10 Nano dev kit.  Before programs can run off the SDRAM, we need to initialise the 1GB DDR3 SDRAM,
setup clocks and PLLs according to the settings described by handoff files (folder hps_isw_handoff).  The
handoff files is from my HPS UART controller HDL project, and gets updated after a Platform Designer (Qsys)
generate, so you may want to replace them with yours.

U-Boot-SPL can be loaded into the On-Chip RAM (of the processor), directly from OpenOCD, using the load_image
and resume command.  The SPL can then run and initialise the DE-10 Nano.  Then we can load and run a user
program from SDRAM and debug it.

In the past, when I first got the DE-10 Nano development board, I saw guides about bare-metal programming
with the DE10-Nano, but that always required ARM's DS-5 IDE, which is bundled with the Altera's EDS
(Embedded Design Suite) tool.  There was a Community License lasting only 30 days, which I used.
ARM uses their own propietary GDB server/debugger called D-STREAM, but that stopped working after the license
expired.  I decided to find an open source and free way to debug - sorry Arm, I am a hobbyist with
small funds.

Script notes:

The scripts are not perfect, sorry I am mostly a Windows user.  Tested on Ubuntu 22.04.2 LTS within Oracle
Virtual Box, and with newer GNU Arm toolchain and U-Boot versions.

All script settings are placed inside the parameters.sh, so edit this if you using different
toolchain or U-Boot versions.

Quick steps:

1. In your home directory, create a folder named DevTools for storing toolchain and U-Boot source zip

2. Download the toolchain from:
  https://github.com/xpack-dev-tools/arm-none-eabi-gcc-xpack/releases

  Hints:
    You may need to click on Assets, and Show all x files.
    The version I used is v12.2.1-1.2:
      https://github.com/xpack-dev-tools/arm-none-eabi-gcc-xpack/releases/tag/v12.2.1-1.2
      File: xpack-arm-none-eabi-gcc-12.2.1-1.2-linux-x64.tar.gz

2. Decompress it to DevTools folder

3. Download U-Boot source code from:
  https://github.com/u-boot/u-boot/tags

  Hints:
    The source code version I used is v2022.10:
      https://github.com/u-boot/u-boot/releases/tag/v2022.10
      File: u-boot-2022.10.zip
      
Alternatively, download Intel/Altera's fork:
  https://github.com/altera-opensource/u-boot-socfpga
  
  Hints:
    Currently, the last stable branch version is (no RC label):
     https://github.com/altera-opensource/u-boot-socfpga/tree/socfpga_v2023.01

4. Move the U-Boot source code zip to DevTools folder

5. Start a terminal and change working directory to the scripts folder, then run ./prep_uboot.sh.
This will unzip it into a new folder called software and also applies my patches

6. In the terminal run ./compile_uboot.sh

If everything is ok you should find the compiled U-Boot-SPL elf file:
software/bootloader/u-boot-socfpga/spl/u-boot-spl

Running with OpenOCD
--------------------

Sorry, I have no time to write a detail guide on using OpenOCD in this document, instead will show
some quick notes.

First make sure you put U-Boot-SPL in your terminal working directory.  OpenOCD will search current
directory for file.

Run OpenOCD and connect to it.  If you want to use GDB then you know the usual, type monitor infront
of each command.

Here are some useful commands:

==============================================

To warm reset the DE-10 Nano processor system (HPS) from a terminal connected to OpenOCD:
halt
mww 0xffd05004 0x00100002

Alternatively, you can just press the HPS warm reset button (KEY3) on the board - the one right
next to the slider switches.

==============================================

To run U-Boot-SPL from a terminal connected to OpenOCD:
halt
load_image u-boot-spl
resume 0xffff0000

==============================================

To run U-Boot-SPL and a user application from a terminal connected to OpenOCD:
halt
load_image u-boot-spl
resume 0xffff0000
sleep 200
halt
arm core_state arm
load_image your_app.elf
resume your_app_entry_point_address

==============================================

To get entry point of your elf, run readelf commandline tool from your toolchain, e.g. from a
command prompt or command/shell terminal:
arm-none-eabi-readelf -h your_app.elf

