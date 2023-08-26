Truong Hy.  26/08/2023

Some notes on U-Boot-SPL configuration for OpenOCD
--------------------------------------------------

U-Boot-SPL
----------

The DE-10 Nano development board requires initialisations before the ARM Cortex A9 can use some of its
peripherals, e.g. the 1GB SD-RAM memory.  On a cold boot only a small 64kB OC-RAM (On-Chip RAM) is
available to run code from.

The regular U-Boot elf is too big to load and run from there, instead we can use the smaller U-Boot-SPL
elf, which its purpose is for this.

What is the difference?

The regular U-Boot elf actually contains two boot loaders, merged into one:
1. U-Boot-SPL (Secondary Program Loader, a low level loader for board initialisations)
2. U-Boot (a higher level loader for booting linux kernel, etc)

So, in normal cases you would only use the regular U-Boot because it contains U-Boot-SPL.

Where is U-Boot-SPL?

After making U-Boot from the sources, you will find the U-Boot-SPL in a separate folder:
spl/

There you will find:
u-boot-spl (elf file)
u-boot-spl.bin (binary version of the elf file)

Devicetree
----------

As you may already know U-Boot has been using Devicetree configuration model - a feature that
came from Linux Kernel sources for the embedded world. This enables replaceable or selectable
configurations files (with different configs for the same board) to be used at run-time, and
without having to re-compile the whole of U-Boot again.

See here:
https://u-boot.readthedocs.io/en/latest/develop/devicetree/control.html

The downside is that you must now load a devicetree binary file .dtb for U-Boot.

Because we want to for debugging purposes, to be able to run the U-Boot-SPL elf file from
OpenOCD or GDB to setup/initialise the board for us, it is not convenient to load a separate
file.

The embed the .dtb file into the U-Boot-SPL during compile/make, add this option into socfpga_de10_nano_defconfig:
CONFIG_OF_EMBED=y

U-Boot handoff files
--------------------

Board configuration rely on files from you vendor to convert into source files (.c / .h) and merging and
referencing them in their vendor U-Boot code.  For Cyclone V SoC we need to process and convert the
files in your Quartus Prime project folder: hps_isw_handoff.

In the new process you can convert them using Python script included in latest stable branch of
Intel/Altera's U-Boot fork.  The Python scripts are inside:
arch/arm/mach-socfpga/cv_bsp_generator

Unfortunately, they are Python 2 scripts and will not run with Python 3.  Latest Ubuntu auto installs Python 3
and takes alot of effort to install Python 2.  I have patched it to work for Python 3 and can be found in my:
scripts/cv_bsp_generator

Anyway, my Bash shell script compile script will run this for you.

Disabling I-Cache and D-Cache
-----------------------------

OpenOCD documentation recommends disabling caches.  Although, the DE10-Nano processor system
(or rather the boot ROM) cold boots with the I-Cache enabled, and D-Cache disabled, I have
patched U-Boot source file spl_gen5.c to disable both cache.

Enabling the Cyclone V HPS bridges
----------------------------------

The following interconnect bridges (system buses) are normally enabled by U-boot script or running a command
within linux:
F2H (FPGA-to-HPS)
H2F (HPS-to-FPGA)
L2F (LW-to-FPGA)

On a cold boot these are all held in reset state (disabled).

For some projects, it may be useful the bootloader enables these bridges for us.

I have patched U-Boot source file spl_gen5.c to attempt enabling these bridges.

In newer U-Boot, Intel/Altera added in a condition for the F2H bridge enable, where it will now
only enable the bridge if the FPGA is already configured (programmed).  This means it will never
be enabled, unless you program a FPGA file first.  This is a safety feature because enabling the
bridge when the FPGA is uninitialised may cause problems.

Because our purpose is debugging using OpenOCD, in certain projects we may want to boot U-Boot-SPL
first and then load the FPGA to use the F2H bridge, but will not work.

I have patched out this condition in the same source file, but left it disabled by leaving it
commentted it out.  If you want this feature just uncomment the patches I made.

