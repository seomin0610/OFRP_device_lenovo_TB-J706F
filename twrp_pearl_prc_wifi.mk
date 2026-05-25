#
# Copyright (C) 2026 The Android Open Source Project
# Copyright (C) 2026 SebaUbuntu's TWRP device tree generator
#
# SPDX-License-Identifier: Apache-2.0
#

# Inherit from those products. Most specific first.
$(call inherit-product, $(SRC_TARGET_DIR)/product/core_64_bit.mk)
$(call inherit-product, $(SRC_TARGET_DIR)/product/full_base_telephony.mk)

# Inherit some common Omni stuff.
$(call inherit-product, vendor/twrp/config/common.mk)

# Inherit from pearl_prc_wifi device
$(call inherit-product, device/lenovo/pearl_prc_wifi/device.mk)

PRODUCT_DEVICE := pearl_prc_wifi
PRODUCT_NAME := twrp_pearl_prc_wifi
PRODUCT_BRAND := Lenovo
PRODUCT_MODEL := Lenovo TB-J706F
PRODUCT_MANUFACTURER := lenovo

PRODUCT_GMS_CLIENTID_BASE := android-lenovo

PRODUCT_BUILD_PROP_OVERRIDES += \
    PRIVATE_BUILD_DESC="LenovoTB-J706F_PRC-user 12 SKQ1.220213.001 14.0.280_230626 release-keys"

BUILD_FINGERPRINT := Lenovo/LenovoTB-J706F_PRC/J706F:12/SKQ1.220213.001/14.0.280_230626:user/release-keys
