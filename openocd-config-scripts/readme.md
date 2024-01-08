# Scripts

Enclosed is OpenOCD scripts for Intel/Terasic DE10-Nano development board:

| File                             | Description                                         |
| -------------------------------- | --------------------------------------------------- |
| target/altera_fpgasoc_de.cfg     | Target setup TCL script                             |
| board/altera_de10nano.cfg        | Board setup TCL script                              |

Copy the altera_fpgasoc_de.cfg to your OpenOCD target scripts folder, for example:
C:\devtools\xpack-openocd-0.12.0-2\share\openocd\scripts\target

The altera_de10nano.cfg is an optional script, which I don't use it, but it would go into the board scripts folder, for example:
C:\devtools\xpack-openocd-0.12.0-2\share\openocd\scripts\board

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

Halt then print registers:
```
halt
reg
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
