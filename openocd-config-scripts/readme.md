# Scripts

Enclosed is OpenOCD scripts for Intel/Terasic DE10-Nano development board:

| File                              | Description                                         |
| --------------------------------- | --------------------------------------------------- |
| target/altera_fpgasoc_de.cfg      | Target setup TCL script for single core (core 0)    |
| target/altera_fpgasoc_de_dual.cfg | Target setup TCL script for core 0 and core 1       |
| interface/altera-usb-blaster2.cfg | JTAG adapter interface setup TCL script             |
| board/altera_de10nano.cfg         | Board setup TCL script                              |

Copy the altera_fpgasoc_de.cfg & target/altera_fpgasoc_de_dual.cfg to your OpenOCD target scripts folder, for example:
C:\devtools\xpack-openocd-0.12.0-2\share\openocd\scripts\target

Copy the altera-usb-blaster2.cfg to your OpenOCD interface scripts folder, for example:
C:\devtools\xpack-openocd-0.12.0-2\share\openocd\scripts\interface

The altera_de10nano.cfg is an optional script, which I don't use it, but it would go into the board scripts folder, for example:
C:\devtools\xpack-openocd-0.12.0-2\share\openocd\scripts\board

The USB Blaster II is the official programming JTAG adapter for Intel FPGAs, and it is already integrated on the DE10-Nano board. It requires a driver and the firmware file blaster_6810.hex to work. The driver and firmware file comes bundled with "Quartus Prime Programmer and Tools" and also "Quartus Prime Lite", and so you can install either one. If you're not going to use "Quartus Prime Lite", you may prefer the smaller size of "Quartus Prime Programmer and Tools". During the setup just make sure to include the driver as part of the installation.

OpenOCD requires the path to the blaster_6810.hex file to be specified.  Since the installation of Quartus creates environment variable QUARTUS_ROOTDIR or QSYS_ROOTDIR for us, I've added TCL code to the target script (altera-usb-blaster2.cfg) which will make use these to find the path to the blaster_6810.hex file.

# U-Boot SPL (preloader)

You will need to run a preloader first, using OpenOCD or GDB, to configure and initialise the DE10-Nano board, otherwise you cannot do much with the HPS.

I have included precompiled example files for the DE10-Nano:

| File                                | Description                                                       |
| ----------------------------------- | ----------------------------------------------------------------- |
| example-de10nano/u-boot-spl-nocache | Precompiled U-Boot SPL (elf) with embedded DTB and cache disabled |
| example-de10nano/helloworld.elf     | Precompiled "Hello, World!" elf standalone application            |

Copy the file to a location of your choice, preferably relative to somewhere in your current path.

# Quick start notes

Below assumes the u-boot-spl-nocache and helloworld.elf is in your current path.

## Start OpenOCD server

To start OpenOCD with USB-Blaster II JTAG adapter and run the SPL preloader, start a command prompt and enter:
```
openocd -f interface/altera-usb-blaster2.cfg -f target/altera_fpgasoc_de.cfg -c "init; halt; c5_reset; halt; load_image u-boot-spl-nocache; resume 0xffff0000; sleep 200; halt; arm core_state arm"
```

## Connect with telnet

In another command prompt, enter:
```
telnet localhost 4444
```

Note: First, start a SSH terminal, e.g. PuTTY and connect to the DE10-Nano's UART USB port, to enable you view the hello message.
Load and run the bare-metal elf:
```
load_image helloworld.elf
resume 0x131c
```

### Some useful commands

Halt then print registers:
```
halt
reg
```

List targets and current state:
```
targets
```

## Connect with GDB

In another command prompt, enter:
```
arm-none-eabi-gdb -iex="target extended-remote localhost:3333" -ex="set pagination off" -ex="set confirm off"
```

Load and run the bare-metal elf, also sets a temporary breakpoint on _exit() so that we can get back to GDB:
```
file helloworld.elf
load
thb _exit
continue
```
