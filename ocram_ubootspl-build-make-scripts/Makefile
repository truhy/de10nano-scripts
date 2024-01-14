# This is free script released into the public domain.
# GNU make file v20240114 created by Truong Hy.
#
# Builds U-Boot for the DE10-Nano development board (contains Intel Cyclone V SoC).
#
# For usage, type make help
#
# Windows limitations:
#   - Natively does not support building U-Boot, use WSL2, Cygwin or MSYS2
#
# Common requirements:
#   - GCC ARM cross compiler toolchain.  The bin directory added to the search path
#   - GNU make (for Windows use xPack's build tools).  The bin directory added to the search path
#
# U-Boot preparation requirements, please see the makefiles:
#   - Makefile-prep-ub.mk
#
# U-Boot's own build dependencies on a fresh Ubuntu 22.04.3 LTS distro:
#   - GNU make
#   - GCC ARM cross compiler toolchain (for building target U-Boot)
#   - gcc (for building host tools)
#   - bison
#   - flex
#   - libssl-dev
#   - bc
#
# This makefile is already complicated, but to keep things a bit more simple:
#   - We assume the required global variables are already set
#   - We assume the required files and paths are relative to the location of this Makefile

ifeq ($(OS),Windows_NT)
$(error Building U-Boot is not supported natively in Windows, use WSL2, Cygwin or MSYS2)
endif

# These variables are assumed to be set already
ifndef BM_OUT_PATH
$(error BM_OUT_PATH environment variable is not set)
endif
ifndef UBOOT_DEFCONFIG
$(error UBOOT_DEFCONFIG env. variable not set, e.g. export UBOOT_DEFCONFIG=socfpga_de10_nano_defconfig)
endif
ifndef UBOOT_OUT_PATH
$(error UBOOT_OUT_PATH env. variable not set)
endif

# Convert back-slashes
ifeq ($(OS),Windows_NT)
BM_OUT_PATH := $(subst \,/,$(BM_OUT_PATH))
UBOOT_OUT_PATH := $(subst \,/,$(UBOOT_OUT_PATH))
endif

# ===============
# Common settings
# ===============

UBOOT_IN_PATH := scripts-linux/uboot

# =======================
# U-Boot settings (Debug)
# =======================

DBG_UBOOT_IN_PATH := $(UBOOT_IN_PATH)/Debug
DBG_UBOOT_OUT_PATH := $(UBOOT_OUT_PATH)/Debug
DBG_UBOOT_SRC_PATH := $(DBG_UBOOT_OUT_PATH)/u-boot
DBG_UBOOT_SUB_PATH := $(DBG_UBOOT_OUT_PATH)/ub-out
DBG_UBOOT_CP_PATH := $(BM_OUT_PATH)/Debug

# =========================
# U-Boot settings (Release)
# =========================

REL_UBOOT_IN_PATH := $(UBOOT_IN_PATH)/Release
REL_UBOOT_OUT_PATH := $(UBOOT_OUT_PATH)/Release
REL_UBOOT_SRC_PATH := $(REL_UBOOT_OUT_PATH)/u-boot
REL_UBOOT_SUB_PATH := $(REL_UBOOT_OUT_PATH)/ub-out
REL_UBOOT_CP_PATH := $(BM_OUT_PATH)/Release

# ===========
# Build rules
# ===========

# Options
.PHONY: all help release debug clean cleantemp

# Default build
all: release

# Dummy force always rule
FORCE:
	

help:
	@echo "Builds the bare-metal C program"
	@echo "Usage:"
	@echo "  make [targets] [options]"
	@echo ""
	@echo "targets:"
	@echo "  release       Build U-Boot Release (default)"
	@echo "  debug         Build U-Boot Debug"
	@echo "  clean         Delete all built files"
	@echo "  cleantemp     Clean except target files"

# ===========
# Clean rules
# ===========

# Clean U-Boot folder
clean:
ifneq ($(OS),Windows_NT)
	@if [ -d "$(UBOOT_OUT_PATH)" ]; then \
		if [ -d "$(DBG_UBOOT_SUB_PATH)" ]; then echo rm -rf $(DBG_UBOOT_SUB_PATH); rm -rf $(DBG_UBOOT_SUB_PATH); fi; \
		if [ -d "$(REL_UBOOT_SUB_PATH)" ]; then echo rm -rf $(REL_UBOOT_SUB_PATH); rm -rf $(REL_UBOOT_SUB_PATH); fi; \
		if [ -d "$(DBG_UBOOT_SRC_PATH)/Makefile)" ]; then make -C $(DBG_UBOOT_SRC_PATH) --no-print-directory clean; fi; \
		make -C $(UBOOT_IN_PATH) --no-print-directory -f Makefile-prep-ub.mk clean; \
	fi
	@if [ -d "$(BM_OUT_PATH)" ]; then \
		if [ -f "$(DBG_UBOOT_CP_PATH)/u-boot-spl" ]; then echo rm -f $(DBG_UBOOT_CP_PATH)/u-boot-spl; rm -f $(DBG_UBOOT_CP_PATH)/u-boot-spl; fi; \
		if [ -f "$(REL_UBOOT_CP_PATH)/u-boot-spl" ]; then echo rm -f $(REL_UBOOT_CP_PATH)/u-boot-spl; rm -f $(REL_UBOOT_CP_PATH)/u-boot-spl; fi; \
		if [ -d "$(DBG_UBOOT_CP_PATH)" ]; then echo rm -df $(DBG_UBOOT_CP_PATH); rm -df $(DBG_UBOOT_CP_PATH); fi; \
		if [ -d "$(REL_UBOOT_CP_PATH)" ]; then echo rm -df $(REL_UBOOT_CP_PATH); rm -df $(REL_UBOOT_CP_PATH); fi; \
	fi
endif

# ===============================================================
# Clean temporary files rules (does not remove user target files)
# ===============================================================

# Clean U-Boot folder
cleantemp:
ifneq ($(OS),Windows_NT)
	@if [ -d "$(UBOOT_OUT_PATH)" ]; then \
		if [ -d "$(DBG_UBOOT_SRC_PATH)/Makefile)" ]; then make -C $(DBG_UBOOT_SRC_PATH) --no-print-directory clean; fi; \
		make -C $(UBOOT_IN_PATH) --no-print-directory -f Makefile-prep-ub.mk clean; \
	fi
	@if [ -d "$(BM_OUT_PATH)" ]; then \
		if [ -f "$(DBG_UBOOT_CP_PATH)/u-boot-spl" ]; then echo rm -f $(DBG_UBOOT_CP_PATH)/u-boot-spl; rm -f $(DBG_UBOOT_CP_PATH)/u-boot-spl; fi; \
		if [ -f "$(REL_UBOOT_CP_PATH)/u-boot-spl" ]; then echo rm -f $(REL_UBOOT_CP_PATH)/u-boot-spl; rm -f $(REL_UBOOT_CP_PATH)/u-boot-spl; fi; \
	fi
endif

# ===========
# Build rules
# ===========

# =================
# Top level targets
# =================

debug: dbg_update_uboot

release: rel_update_uboot

# ===================
# Update U-Boot rules
# ===================

dbg_update_uboot:
	@echo "Running make to prepare U-Boot"
	@make -C $(UBOOT_IN_PATH) --no-print-directory -f Makefile-prep-ub.mk debug
	@echo ""
	@echo "Running make from U-Boot source"
	@make -C $(DBG_UBOOT_SRC_PATH) --no-print-directory $(UBOOT_DEFCONFIG)
	@make -C $(DBG_UBOOT_SRC_PATH) --no-print-directory -j 8
ifneq ($(UB_OUT_PATH),$(BM_OUT_PATH))
	@if [ -f "$(DBG_UBOOT_SRC_PATH)/spl/u-boot-spl" ]; then \
		mkdir -p $(DBG_UBOOT_CP_PATH); \
		cp -f -u $(DBG_UBOOT_SRC_PATH)/spl/u-boot-spl $(DBG_UBOOT_CP_PATH); \
		echo Copied to: $(DBG_UBOOT_CP_PATH)/u-boot-spl; \
	fi
endif

rel_update_uboot:
	@echo "Running make to prepare U-Boot"
	@make -C $(UBOOT_IN_PATH) --no-print-directory -f Makefile-prep-ub.mk release
	@echo ""
	@echo "Running make from U-Boot source"
	@make -C $(REL_UBOOT_SRC_PATH) --no-print-directory $(UBOOT_DEFCONFIG)
	@make -C $(REL_UBOOT_SRC_PATH) --no-print-directory -j 8
ifneq ($(UB_OUT_PATH),$(BM_OUT_PATH))
	@if [ -f "$(REL_UBOOT_SRC_PATH)/spl/u-boot-spl" ]; then \
		mkdir -p $(REL_UBOOT_CP_PATH); \
		cp -f -u $(REL_UBOOT_SRC_PATH)/spl/u-boot-spl $(REL_UBOOT_CP_PATH); \
		echo Copied to: $(REL_UBOOT_CP_PATH)/u-boot-spl; \
	fi
endif
