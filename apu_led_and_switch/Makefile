#
# Copyright (C) 2006-2009 OpenWrt.org
#
# This is free software, licensed under the GNU General Public License v2.
# See /LICENSE for more information.
#

include $(TOPDIR)/rules.mk
include $(INCLUDE_DIR)/kernel.mk

PKG_NAME:=leds-apu
PKG_RELEASE:=1

PKG_VERSION:=1.0

PKG_BUILD_DIR:=$(BUILD_DIR)/leds-apu-$(PKG_VERSION)
PKG_SOURCE:=apu-leds.tgz
PKG_SOURCE_URL:=http://daduke.org/dl/
#PKG_MD5SUM:=9d937bb2480bb17702f87bfba0fe248f
PKG_MD5SUM:=c3239f2503a86ed09d278233360daacc
PKG_CAT:=zcat

PKG_BUILD_DIR:=$(KERNEL_BUILD_DIR)/$(PKG_NAME)-$(PKG_VERSION)

include $(INCLUDE_DIR)/package.mk

define KernelPackage/apu_leds
  SUBMENU:=LED modules
  TITLE:=PC Engines APU LED support
  FILES:=$(PKG_BUILD_DIR)/leds-apu.ko $(PKG_BUILD_DIR)/apu_button.ko
  AUTOLOAD:=$(call AutoLoad,90,leds-apu.ko)
  KCONFIG+=
endef

define KernelPackage/apu_leds/description
  Modules to access the 3 front LEDs and the reset-button of the PC Engines APU board
endef

MAKE_OPTS:= \
    ARCH="$(LINUX_KARCH)" \
	CROSS_COMPILE="$(TARGET_CROSS)" \
	SUBDIRS="$(PKG_BUILD_DIR)"

define Build/Prepare
	mkdir -p $(PKG_BUILD_DIR)
	$(CP) ./src/* $(PKG_BUILD_DIR)/
endef

define Build/Compile
	$(MAKE) -C "$(LINUX_DIR)" \
		$(MAKE_OPTS) \
		modules
endef

define KernelPackage/apu_leds/install
	$(INSTALL_DIR) $(1)/lib/modules/$(LINUX_VERSION)
	$(INSTALL_DIR) $(1)/etc/modules.d
#	$(INSTALL_DATA) ./files/etc/modules.d/50-apu-leds $(1)/etc/modules.d/50-apu-leds
#	$(INSTALL_DATA) ./files/etc/modules.d/50-apu-button $(1)/etc/modules.d/50-apu-button
	$(INSTALL_DIR) $(1)/usr/bin
	$(INSTALL_BIN) ./files/usr/bin/reset_button.sh $(1)/usr/bin/reset_button.sh
endef

$(eval $(call KernelPackage,apu_leds))


