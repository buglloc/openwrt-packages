#
# Copyright (C) 2023 Andew Krasichkov
#
# This is free software, licensed under the GNU General Public License v2.
# See /LICENSE for more information.
#

include $(TOPDIR)/rules.mk

PKG_NAME:=fidele
PKG_VERSION:=0.9.0
PKG_RELEASE:=1

include $(INCLUDE_DIR)/package.mk

define Package/fidele
  SECTION:=utils
  CATEGORY:=Utilities
  SUBMENU:=Encryption
  TITLE:=Unlock LUKS encrypted disk with an FIDO2 compatible key.
#  DEPENDS:=+cryptsetup +fido2-tools
endef

define Package/fidele/description
	Fidele is a bunch of scripts that will allow you to unlock your LUKS
	encrypted disk with an FIDO2 compatible key.
endef

define Package/fidele/conffiles
/etc/fidele.conf
endef

define Build/Compile
endef

define Package/fidele/install
	$(INSTALL_DIR) $(1)/usr/share/fidele
	$(INSTALL_DATA) ./files/usr/share/fidele/utils.sh $(1)/usr/share/fidele/utils.sh
	$(INSTALL_DIR) $(1)/usr/sbin/
	$(INSTALL_BIN) ./files/usr/sbin/fidele-new-passphrase $(1)/usr/sbin/
	$(INSTALL_BIN) ./files/usr/sbin/fidele-passphrase $(1)/usr/sbin/
	$(INSTALL_BIN) ./files/usr/sbin/fidele-luks-open $(1)/usr/sbin/
	$(INSTALL_DIR) $(1)/etc/
	$(INSTALL_CONF) ./files/etc/fidele.conf $(1)/etc/
endef

$(eval $(call BuildPackage,fidele))
