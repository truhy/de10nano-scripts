// SPDX-License-Identifier: GPL-2.0+
/*
 * (C) Copyright 2013
 * Andreas Bießmann <andreas@biessmann.org>
 *
 * This file consolidates all the different hang() functions implemented in
 * u-boot.
 */

#include <common.h>
#include <bootstage.h>
#include <hang.h>
#include <os.h>
#include <cpu_func.h>  // Truong patch

/**
 * hang - stop processing by staying in an endless loop
 *
 * The purpose of this function is to stop further execution of code cause
 * something went completely wrong.  To catch this and give some feedback to
 * the user one needs to catch the bootstage_error (see show_boot_progress())
 * in the board code.
 */
void hang(void)
{
	// Truong patches..
	#if defined(CONFIG_TARGET_SOCFPGA_GEN5)
		puts("Disabling WatchDog0\n");
		socfpga_per_reset(SOCFPGA_RESET(L4WD0), 1);  // Disable watchdog0, i.e. put it into reset state
		//writel(0xC1B6C0C5, socfpga_get_rstmgr_addr() + RSTMGR_GEN5_PERMODRST);  // Disable watchdogs, enable DE10 Nano peripherals: SDRAM, DMA, GPIO0, GPIO1, GPIO2, SDMMC, SPIM1, UART0, I2C0, I2C1, SPTIMER0, SPTIMER1, OSCLTIMER0. OSCLTIMER1, USB1, EMAC1
		//writel(0, socfpga_get_rstmgr_addr() + RSTMGR_GEN5_PER2MODRST);  // Enable all DMA channel interface adapters between FPGA Fabric and HPS DMA Controller
		puts("Enabling all bridges\n");
		socfpga_bridges_reset(0);  // Enable all bridges, i.e. put them out of reset
	#endif

	puts("Disabling I-Cache\n");
	icache_disable();
	puts("Disabling D-Cache\n");
	dcache_disable();

#if !defined(CONFIG_SPL_BUILD) || \
		(CONFIG_IS_ENABLED(LIBCOMMON_SUPPORT) && \
		 CONFIG_IS_ENABLED(SERIAL))
	//puts("### ERROR ### Please RESET the board ###\n");
#endif
	// End of patches

	bootstage_error(BOOTSTAGE_ID_NEED_RESET);
	if (IS_ENABLED(CONFIG_SANDBOX))
		os_exit(1);
	for (;;)
		;
}
