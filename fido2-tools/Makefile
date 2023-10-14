#
# Copyright (C) 2023 Andew Krasichkov
#
# This is free software, licensed under the GNU General Public License v2.
# See /LICENSE for more information.
#

include $(TOPDIR)/rules.mk

PKG_NAME:=libfido2
PKG_VERSION:=1.13.0
PKG_RELEASE:=1

PKG_SOURCE:=$(PKG_NAME)-$(PKG_VERSION).tar.gz
PKG_SOURCE_URL:=https://developers.yubico.com/libfido2/Releases/$(PKG_SOURCE)?
PKG_HASH:=51d43727e2a1c4544c7fd0ee47786f443e39f1388ada735a509ad4af0a2459ca

PKG_MAINTAINER:=Andrew Krasichkov <openwrt@buglloc.cc>
PKG_LICENSE:=GPL-3.0-or-later
PKG_LICENSE_FILES:=COPYING

PKG_FORTIFY_SOURCE:=0
CMAKE_INSTALL:=1

include $(INCLUDE_DIR)/package.mk
include $(INCLUDE_DIR)/cmake.mk

define Package/libfido2
  SECTION:=libs
  CATEGORY:=Libraries
  TITLE:=FIDO2 Library
  URL:=https://github.com/Yubico/libfido2
  ABI_VERSION:=1
  DEPENDS += +libcbor +libopenssl +libudev +zlib
endef

define Package/libfido2/description
 libfido2 provides library functionality to communicate with a FIDO device over USB, and to verify attestation and assertion signatures.

 libfido2 supports the FIDO U2F (CTAP 1) and FIDO 2.0 (CTAP 2) protocols.
endef

define Package/fido2-tools
  SECTION:=utils
  CATEGORY:=Utilities
  SUBMENU:=Encryption
  TITLE:=FIDO2 tools
  URL:=https://github.com/Yubico/libfido2
  ABI_VERSION:=1
  DEPENDS += +libfido2
endef

define Package/fido2-tools/description
 fido2-tools provides command-line tools to communicate with a FIDO device over USB, and to verify attestation and assertion signatures.
endef

CMAKE_OPTIONS += \
	-DBUILD_EXAMPLES=OFF \
	-DBUILD_MANPAGES=OFF \
	-DBUILD_SHARED_LIBS=ON \
	-DBUILD_STATIC_LIBS=OFF \
	-DBUILD_TOOLS=ON
	-DFUZZ=OFF \
	-DLIBFUZZER=OFF \
	-DUSE_HIDAPI=OFF

define Package/fido2-tools/install
	$(INSTALL_DIR) $(1)/usr/lib
	$(CP) $(PKG_INSTALL_DIR)/usr/lib/libfido2.so.* $(1)/usr/lib/
endef

$(eval $(call BuildPackage,libfido2))
$(eval $(call BuildPackage,fido2-tools))
