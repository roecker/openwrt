# 
# Copyright (C) 2006-2010 OpenWrt.org
# Copyright (C) 2015
#
# This is free software, licensed under the GNU General Public License v2.
# See /LICENSE for more information.
#

include $(TOPDIR)/rules.mk

# The name of the package, as seen via menuconfig and ipkg
PKG_NAME:=nss

PKG_VERSION:=3.19.3
PKG_RELEASE:=1
PKG_SOURCE:=$(PKG_NAME)-$(PKG_VERSION)-with-nspr-4.10.8.tar.gz # The filename of the original sources
PKG_SOURCE_URL:=https://ftp.mozilla.org/pub/mozilla.org/security/nss/releases/NSS_3_19_3_RTM/src/
PKG_MD5SUM:=487bf2d8e70e0cfcfe18855b611756a9

HOST_BUILD_DIR:=$(BUILD_DIR_HOST)/$(PKG_NAME)-$(PKG_VERSION)

# Some/many packages that think autotools is a good idea end up needing "fixes"
# to work around autotools "accidentally" knowing better and using host tools
# instead of the build environment tools. OpenWrt defines some PKG_FIXUP rules
# to help work around this.
PKG_FIXUP:=libtool

include $(INCLUDE_DIR)/package.mk

## Build/Compile
# How to compile the source; in most cases you should leave this undefined,
# because then the default is used, which calls make. If you want to pass
# special arguments to make, use e.g. "$(call Build/Compile/Default,FOO=bar) 
#
##
# see: https://developer.mozilla.org/en-US/docs/Mozilla/Projects/NSS/Building
# BUILD_OPT (default=0) 
# USE_64 (default=0)
# CROSS_COMPILE=1 (default=0)
define Build/Compile
	(cd $(PKG_BUILD_DIR)/nss; \
		NSPR_CONFIGURE_OPTS="--host=i686-pc-linux-gnu \
						     --build=i686-pc-linux-gnu \
							 --target=i486-openwrt-linux-uclibc" \
		make nss_build_all CROSS_COMPILE=1 OS_TARGET=OpenWRT)
endef

# matches the argument passed to buildroot, this describes the package the
# menuconfig and ipkg entries. Within Package/ you can define the following
# variables:
# SECTION 	- The type of package (currently unused)
# CATEGORY 	- Which menu it appears in menuconfig
# TITLE 	- A short description of the package
# URL 		- Where to find the original software
define Package/libnss
  SECTION:=libs
  CATEGORY:=Libraries
  TITLE:=Library Network Security Services (NSS)
  URL:=http://www.mozilla.org/projects/security/pki/nss/
  DEPENDS:=+libpthread +librt +zlib
endef


# A free text description of the package 
define Package/libnss/description
  Library Network Security Services (NSS)
endef

##
# For things needed to compile packages against it (static libs, header files),
# but that are of no use on the target device. 
#
# $1              :  ~aa/tmp/stage-nss
# $PKG_BUILD_DIR  :  ~aa/build_dir/target-i386_uClibc-0.9.33.2/nss-3.19.3 	# ~nss
# $PKG_INSTALL_DIR:  ~aa/build_dir/target-i386_uClibc-0.9.33.2/nss-3.19.3/ipkg-install
# $STAGING_DIR    :  ~aa/staging_dir/target-i386_uClibc-0.9.33.2
define Build/InstallDev
	$(INSTALL_DIR) $(1)/usr/include
	$(CP) $(PKG_BUILD_DIR)/nspr/pr/include/*.h $(1)/usr/include/
	$(CP) $(PKG_BUILD_DIR)/nspr/pr/include/md/_linux.cfg $(1)/usr/include/prcpucfg.h
	$(CP) $(PKG_BUILD_DIR)/nspr/lib/ds/*.h $(1)/usr/include/
	$(CP) $(PKG_BUILD_DIR)/nspr/lib/libc/include/*.h $(1)/usr/include/

	$(CP) $(PKG_BUILD_DIR)/nss/lib/nss/nss.h $(1)/usr/include/
	$(CP) $(PKG_BUILD_DIR)/nss/lib/util/*.h $(1)/usr/include/
	$(CP) $(PKG_BUILD_DIR)/nss/lib/pk11wrap/*.h $(1)/usr/include/
	$(CP) $(PKG_BUILD_DIR)/nss/lib/cryptohi/*.h $(1)/usr/include/
	$(CP) $(PKG_BUILD_DIR)/nss/lib/certdb/*.h $(1)/usr/include/
	$(CP) $(PKG_BUILD_DIR)/nss/lib/pkcs7/*.h $(1)/usr/include/
	$(CP) $(PKG_BUILD_DIR)/nss/lib/smime/*.h $(1)/usr/include/
	$(CP) $(PKG_BUILD_DIR)/nss/lib/certhigh/*.h $(1)/usr/include/

	$(INSTALL_DIR) $(1)/usr/lib
	$(CP) $(PKG_BUILD_DIR)/nss/lib/nss/OpenWRT4.0_x86_i486-openwrt-linux-uclibc-gcc_glibc_PTH_DBG.OBJ/libnss3.so $(1)/usr/lib/
	$(CP) $(PKG_BUILD_DIR)/nss/lib/nss/OpenWRT4.0_x86_i486-openwrt-linux-uclibc-gcc_glibc_PTH_DBG.OBJ/libnss.a $(1)/usr/lib/

	$(CP) $(PKG_BUILD_DIR)/nspr/OpenWRT4.0_x86_i486-openwrt-linux-uclibc-gcc_glibc_PTH_DBG.OBJ/lib/libc/src/libplc4.so $(1)/usr/lib/
	$(CP) $(PKG_BUILD_DIR)/nss/lib/util/OpenWRT4.0_x86_i486-openwrt-linux-uclibc-gcc_glibc_PTH_DBG.OBJ/libnssutil3.so $(1)/usr/lib/
	$(CP) $(PKG_BUILD_DIR)/nspr/OpenWRT4.0_x86_i486-openwrt-linux-uclibc-gcc_glibc_PTH_DBG.OBJ/pr/src/libnspr4.so $(1)/usr/lib/
	$(CP) $(PKG_BUILD_DIR)/nspr/OpenWRT4.0_x86_i486-openwrt-linux-uclibc-gcc_glibc_PTH_DBG.OBJ/lib/ds/libplds4.so $(1)/usr/lib/

	$(INSTALL_DIR) $(1)/usr/include/obsolete
	$(CP) $(PKG_BUILD_DIR)/nspr/pr/include/obsolete/*.h $(1)/usr/include/obsolete/

	$(INSTALL_DIR) $(1)/usr/lib/pkgconfig
	$(CP) ./files/nss.pc.in $(1)/usr/lib/pkgconfig/nss.pc
	$(SED) 's#EXEC_PREFIX#/usr#g' $(1)/usr/lib/pkgconfig/nss.pc
	$(SED) 's#PREFIX#/usr#g' $(1)/usr/lib/pkgconfig/nss.pc
	$(SED) 's#VERSION#${PKG_VERSION}#g' $(1)/usr/lib/pkgconfig/nss.pc

	$(CP) ./files/nspr.pc.in $(1)/usr/lib/pkgconfig/nspr.pc
	$(SED) 's#EXEC_PREFIX#/usr#g' $(1)/usr/lib/pkgconfig/nspr.pc
	$(SED) 's#PREFIX#/usr#g' $(1)/usr/lib/pkgconfig/nspr.pc
	$(SED) 's#VERSION#${PKG_VERSION}#g' $(1)/usr/lib/pkgconfig/nspr.pc
endef


##
# A set of commands to copy files into the ipkg which is represented by the
# $(1) directory. As source you can use relative paths which will install from
# the unpacked and compiled source, or $(PKG_INSTALL_DIR) which is where the
# files in the Build/Install step above end up. 
#
# $1              :  ~aa/build_dir/target-i386_uClibc-0.9.33.2/nss-3.19.3/ipkg-x86/libnss
# $PKG_BUILD_DIR  :  ~aa/build_dir/target-i386_uClibc-0.9.33.2/nss-3.19.3
# $PKG_INSTALL_DIR:  ~aa/build_dir/target-i386_uClibc-0.9.33.2/nss-3.19.3/ipkg-install
define Package/libnss/install
	$(INSTALL_DIR) $(1)/lib
#	$(CP) \
#		$(PKG_BUILD_DIR)/nss/lib/nss/OpenWRT4.0_x86_i486-openwrt-linux-uclibc-gcc_glibc_PTH_DBG.OBJ/libnss3.so \
#		$(1)/lib/
#	$(CP) \
#		$(PKG_BUILD_DIR)/nspr/OpenWRT4.0_x86_i486-openwrt-linux-uclibc-gcc_glibc_PTH_DBG.OBJ/pr/src/libnspr4.so \
#		$(1)/lib/
#	$(CP) \
#		$(PKG_BUILD_DIR)/nss/lib/util/OpenWRT4.0_x86_i486-openwrt-linux-uclibc-gcc_glibc_PTH_DBG.OBJ/libnssutil3.so \
#		$(1)/lib/
#	$(CP) \
#		$(PKG_BUILD_DIR)/nspr/OpenWRT4.0_x86_i486-openwrt-linux-uclibc-gcc_glibc_PTH_DBG.OBJ/lib/libc/src/libplc4.so \
#		$(1)/lib/
#	$(CP) \
#		$(PKG_BUILD_DIR)/nspr/OpenWRT4.0_x86_i486-openwrt-linux-uclibc-gcc_glibc_PTH_DBG.OBJ/lib/ds/libplds4.so \
#		$(1)/lib/
#	$(CP) \
#		$(PKG_BUILD_DIR)/nss/lib/smime/OpenWRT4.0_x86_i486-openwrt-linux-uclibc-gcc_glibc_PTH_DBG.OBJ/libsmime* \
#		$(1)/lib/
#	$(CP) \
#		$(PKG_BUILD_DIR)/nss/lib/ssl/OpenWRT4.0_x86_i486-openwrt-linux-uclibc-gcc_glibc_PTH_DBG.OBJ/libssl* \
#		$(1)/lib/
#	$(CP) \
#		$(PKG_BUILD_DIR)/nss/lib/sqlite/OpenWRT4.0_x86_i486-openwrt-linux-uclibc-gcc_glibc_PTH_DBG.OBJ/libsqlite* \
#		$(1)/lib/

	$(FIND) $(PKG_BUILD_DIR)/nss $(PKG_BUILD_DIR)/nspr -type f -name *.a -exec $(CP) -a {} $(1)/lib/ \;
	$(FIND) $(PKG_BUILD_DIR)/nss $(PKG_BUILD_DIR)/nspr -type f -name *.so -exec $(CP) -a {} $(1)/lib/ \;


	$(INSTALL_DIR) $(1)/bin
	$(CP) \
		$(PKG_BUILD_DIR)/nss/cmd/certutil/OpenWRT4.0_x86_i486-openwrt-linux-uclibc-gcc_glibc_PTH_DBG.OBJ/certutil \
		$(1)/bin
	$(CP) \
		$(PKG_BUILD_DIR)/nss/cmd/smimetools/OpenWRT4.0_x86_i486-openwrt-linux-uclibc-gcc_glibc_PTH_DBG.OBJ/cmsutil \
		$(1)/bin
	$(CP) \
		$(PKG_BUILD_DIR)/nss/cmd/crlutil/OpenWRT4.0_x86_i486-openwrt-linux-uclibc-gcc_glibc_PTH_DBG.OBJ/crlutil \
		$(1)/bin
	$(CP) \
		$(PKG_BUILD_DIR)/nss/cmd/pk12util/OpenWRT4.0_x86_i486-openwrt-linux-uclibc-gcc_glibc_PTH_DBG.OBJ/pk12util \
		$(1)/bin
	$(CP) \
		$(PKG_BUILD_DIR)/nss/cmd/signtool/OpenWRT4.0_x86_i486-openwrt-linux-uclibc-gcc_glibc_PTH_DBG.OBJ/signtool \
		$(1)/bin
	$(CP) \
		$(PKG_BUILD_DIR)/nss/cmd/signver/OpenWRT4.0_x86_i486-openwrt-linux-uclibc-gcc_glibc_PTH_DBG.OBJ/signver \
		$(1)/bin
	$(CP) \
		$(PKG_BUILD_DIR)/nss/cmd/ssltap/OpenWRT4.0_x86_i486-openwrt-linux-uclibc-gcc_glibc_PTH_DBG.OBJ/ssltap \
		$(1)/bin
endef


$(eval $(call BuildPackage,libnss))
