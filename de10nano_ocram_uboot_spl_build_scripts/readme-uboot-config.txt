Truong Hy.  26/08/2023

Some notes on U-Boot-SPL configuration for OpenOCD
--------------------------------------------------

U-Boot-SPL
----------

The DE-10 Nano development board requires initialisations before the ARM Cortex A9 can use some of its
peripherals, e.g. the 1GB SD-RAM memory.  On a cold boot only a small 64kB OC-RAM (On-Chip RAM in the
processor) is available to run code from.

The regular U-Boot elf is too big to load and run from OC-RAM, instead we can use the smaller U-Boot-SPL
elf for this, infact the SPL was coded for this purpose.

What is the difference between normal U-Boot and small U-Boot-SPL?

The regular U-Boot elf actually contains two boot loaders, so U-Boot-SPL is included:
1. U-Boot-SPL (Secondary Program Loader, a low level loader for board initialisations)
2. U-Boot (a higher level loader for booting linux kernel, etc)

In normal cases you would use the regular U-Boot.  The difference is just that, U-Boot-SPL is just a
separated build from regular U-Boot.

Where can I find U-Boot-SPL?

After making U-Boot from the source code, you will find the compiled U-Boot-SPL inside its own folder:
spl/

There you will find:
u-boot-spl (elf file)
u-boot-spl.bin (binary version of the elf file)

U-Boot devicetree
-----------------

As you may already know, U-Boot has been using Devicetree configuration model for a while now -
a feature used by Linux Kernel sources for the embedded world. This enables replaceable or
selectable configurations files (files with different configs for the same board) that can be selected
at run-time, and without having to re-compile the whole of U-Boot again.

See here:
https://u-boot.readthedocs.io/en/latest/develop/devicetree/control.html

The downside is that you must now load a devicetree binary file .dtb for U-Boot to run.

But, because we just want to use it for debugging purposes; be able to run U-Boot-SPL from OpenOCD or
GDB and setup/initialise the board for us, it is not convenient to load a separate file.

U-Boot provides us with a config option to embed the devicetree .dtb to the end of the U-Boot-SPL
during the compile/make, to do this add this option into the socfpga_de10_nano_defconfig file:
CONFIG_OF_EMBED=y

U-Boot handoff files
--------------------

Board configuration rely on settings from you vendor (Intel in this case) and they require converting
into source files (.c / .h), which are then merged and referenced from vendor U-Boot source code.  The
vendor will provide their own tools or scripts for this process.  Specifically, for Cyclone V SoC the
process involves converting the files from a folder in your Quartus Prime project: hps_isw_handoff.

Intel/Altera likes to call this the build process flow.  They've changed their tools a sometime ago and
so there is an old build flow and now new build flow.  In the new build flow, they have provided us with
Python scripts included in latest stable branch of Intel/Altera's U-Boot fork.  They are located inside:
arch/arm/mach-socfpga/cv_bsp_generator

Unfortunately, these are Python 2 scripts and will not run with Python 3.  Latest Ubuntu auto installs
Python 3 and due to configuration collision, seems we cannot install Python 2 along side it.  I have
patched them for Python 3 and can be found in my scripts:
scripts/cv_bsp_generator

Anyway, my compile script will run this so you don't need to run them yourself.

Disabling I-Cache and D-Cache
-----------------------------

OpenOCD documentation recommends disabling caches.  Although, the DE10-Nano processor system
(or perhaps the boot ROM) will cold boot with the I-Cache enabled, and D-Cache disabled, I decided to
patch U-Boot vendor source file spl_gen5.c to disable both cache.

Enabling the Cyclone V HPS bridges
----------------------------------

The following Cyclone V interconnect bridges (system buses) are normally enabled by U-boot script or
running a command within linux:
F2H (FPGA-to-HPS)
H2F (HPS-to-FPGA)
L2F (LW-to-FPGA)

On a cold boot these are all held in the reset state (disabled).  For some projects, it may be useful
for the bootloader to enable them.

I have patched U-Boot source file spl_gen5.c to attempt at enabling these bridges.

In newer U-Boot, Intel/Altera added in a condition for the F2H bridge enable code, it will only
enable that bridge if the FPGA is already configured (programmed).  This means it will never be
enabled, unless you program a FPGA file first.  I guess that this is a safety feature, because enabling
the bridge when the FPGA is uninitialised may cause problems.  Actually, I think the real reason is
because enabling it before FPGA initialisation will prevent the debug from working!  OpenOCD will
error out!  A hardware bug?

Sometimes, for certain projects, it is useful to boot U-Boot-SPL first, enable the F2H bridge and then
load an FPGA file to use the F2H bridge all from OpenOCD, but will not work with this condition enabled.

I have patched out this condition in spl_gen5.c, but left it disabled by leaving it commentted it out.
If you want this feature just uncomment the patches I made.

