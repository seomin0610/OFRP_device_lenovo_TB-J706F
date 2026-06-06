#
# Copyright (C) 2026 The Android Open Source Project
# Copyright (C) 2026 SebaUbuntu's TWRP device tree generator
#
# SPDX-License-Identifier: Apache-2.0
#

LOCAL_PATH := device/lenovo/pearl_prc_wifi
# A/B
AB_OTA_POSTINSTALL_CONFIG += \
    RUN_POSTINSTALL_system=true \
    POSTINSTALL_PATH_system=system/bin/otapreopt_script \
    FILESYSTEM_TYPE_system=ext4 \
    POSTINSTALL_OPTIONAL_system=true

# Boot control HAL
PRODUCT_PACKAGES += \
    android.hardware.boot@1.0-impl \
    android.hardware.boot@1.0-service

PRODUCT_PACKAGES += \
    bootctrl.sm6150

PRODUCT_PACKAGES += \
    qseecomd_recovery \
    otapreopt_script \
    cppreopts.sh \
    update_engine \
    update_verifier \
    update_engine_sideload

PRODUCT_COPY_FILES += \
    $(LOCAL_PATH)/prebuilt/goodix_cfg_group.bin:$(TARGET_COPY_OUT_RECOVERY)/root/vendor/firmware/goodix_cfg_group.bin \
    $(LOCAL_PATH)/recovery/root/vendor/etc/fstab.default:$(TARGET_COPY_OUT_RECOVERY)/root/vendor/etc/fstab.default

# keymaster lib
RECOVERY_LIBRARY_SOURCE_FILES += \
    $(LOCAL_PATH)/recovery/root/vendor/lib64/libqcbor.so \
    $(LOCAL_PATH)/recovery/root/vendor/lib64/libion.so \
    $(LOCAL_PATH)/recovery/root/vendor/lib64/libhidlbase.so \
    $(LOCAL_PATH)/recovery/root/vendor/lib64/android.hardware.keymaster@3.0.so \
    $(LOCAL_PATH)/recovery/root/vendor/lib64/android.hardware.keymaster@4.0.so \
    $(LOCAL_PATH)/recovery/root/vendor/lib64/android.hardware.keymaster@4.1.so \
    $(LOCAL_PATH)/recovery/root/vendor/lib64/libbase.so \
    $(LOCAL_PATH)/recovery/root/vendor/lib64/libc++.so \
    $(LOCAL_PATH)/recovery/root/vendor/lib64/libcrypto.so \
    $(LOCAL_PATH)/recovery/root/vendor/lib64/libcutils.so \
    $(LOCAL_PATH)/recovery/root/vendor/lib64/libhardware.so \
    $(LOCAL_PATH)/recovery/root/vendor/lib64/libprocessgroup.so \
    $(LOCAL_PATH)/recovery/root/vendor/lib64/libutils.so \
    $(LOCAL_PATH)/recovery/root/vendor/lib64/libqtikeymaster4.so \
    $(LOCAL_PATH)/recovery/root/vendor/lib64/libcryptfshwcommon.so \
    $(LOCAL_PATH)/recovery/root/vendor/lib64/libcryptfshwhidl.so \
    $(LOCAL_PATH)/recovery/root/vendor/lib64/libQSEEComAPI.so \
    $(LOCAL_PATH)/recovery/root/vendor/lib64/libdrmfs.so \
    $(LOCAL_PATH)/recovery/root/vendor/lib64/vendor.qti.hardware.cryptfshw@1.0.so \
    $(LOCAL_PATH)/recovery/root/vendor/lib64/libhidltransport.so \
    $(LOCAL_PATH)/recovery/root/vendor/lib64/libhwbinder.so \
    $(LOCAL_PATH)/recovery/root/vendor/lib64/libkeymasterdeviceutils.so \
    $(LOCAL_PATH)/recovery/root/vendor/lib64/libkeymasterprovision.so \
    $(LOCAL_PATH)/recovery/root/vendor/lib64/libkeymasterutils.so \
    $(LOCAL_PATH)/recovery/root/vendor/lib64/libc++_shared.so \
    $(LOCAL_PATH)/recovery/root/vendor/lib64/libdiag.so \
    $(LOCAL_PATH)/recovery/root/vendor/lib64/libdrm.so \
    $(LOCAL_PATH)/recovery/root/vendor/lib64/libdrmutils.so


# some OrangeFox-specific settings
$(call inherit-product, $(LOCAL_PATH)/fox_pearl_prc_wifi.mk)
