#
# Copyright (C) 2017-2018 The LineageOS Project
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

# Get vendor-specific stuff
$(call inherit-product, vendor/lenovo/X605F/X605F-vendor.mk)

# Overlay
DEVICE_PACKAGE_OVERLAYS += \
    $(LOCAL_PATH)/overlay \
    $(LOCAL_PATH)/overlay-lineage

# Properties
-include $(LOCAL_PATH)/vendor_prop.mk

# AAPT - screen density (224ppi=hdpi)
PRODUCT_AAPT_CONFIG := normal
PRODUCT_AAPT_PREF_CONFIG := hdpi

# Device characteristics
PRODUCT_CHARACTERISTICS := tablet

# Android ID (AID) file system configs
PRODUCT_PACKAGES += \
    fs_config_files

# Audio
PRODUCT_PACKAGES += \
    audio.a2dp.default \
    android.hardware.audio@2.0-impl \
    android.hardware.audio@2.0-service \
    android.hardware.audio.effect@2.0-impl \
    android.hardware.audio@4.0-impl \
    android.hardware.audio.effect@4.0-impl \
    android.hardware.soundtrigger@2.0-impl \
    android.hardware.soundtrigger@2.1-impl

# TODO
#    audiod \
#    audio.primary.msm8953 \
#    audio.r_submix.default \
#    audio.usb.default \
#    libaudio-resampler \
#    libaudioroute \
#    libqcompostprocbundle \
#    libqcomvisualizer \
#    libqcomvoiceprocessing \
#    libtinycompress \
#    tinymix \

PRODUCT_COPY_FILES += $(foreach audio_config, $(wildcard $(LOCAL_PATH)/configs/audio/*), \
    $(audio_config):$(addprefix $(TARGET_COPY_OUT_VENDOR)/etc/, $(notdir $(audio_config))) )

# bluetooth
PRODUCT_PACKAGES += \
    libbt-vendor \
    libbthost_if \
    android.hardware.bluetooth@1.0-impl-qti \
    android.hardware.bluetooth@1.0-impl \
    android.hardware.bluetooth@1.0-service

# Camera
PRODUCT_PACKAGES += \
    Snap \
    camera.msm8953 \
    libmm-qcamera

# Camera - hidl
PRODUCT_PACKAGES += \
    android.hardware.camera.provider@2.4-impl \
    android.hardware.camera.provider@2.4-service

# Display
PRODUCT_PACKAGES += \
    libvulkan \
    vendor.display.config@1.0

# DRM - hidl
PRODUCT_PACKAGES += \
    android.hardware.drm@1.0-impl \
    android.hardware.drm@1.0-service \
    android.hardware.drm@1.1-service.clearkey

# FM
PRODUCT_PACKAGES += \
    FM2 \
    libqcomfm_jni \
    qcom.fmradio

# GPS
PRODUCT_PACKAGES += \
    libcurl \
#    libgnss \
#    libgnsspps

PRODUCT_COPY_FILES += $(foreach gps_config, $(wildcard $(LOCAL_PATH)/configs/gps/*), \
    $(gps_config):$(addprefix $(TARGET_COPY_OUT_VENDOR)/etc/, $(notdir $(gps_config))) )

# gps - hidl
PRODUCT_PACKAGES += \
    android.hardware.gnss@1.0-impl \
    android.hardware.gnss@1.0-impl-qti

# graphics - hidl
PRODUCT_PACKAGES += \
    android.hardware.graphics.allocator@2.0-impl \
    android.hardware.graphics.allocator@2.0-service \
    android.hardware.graphics.composer@2.1-impl \
    android.hardware.graphics.composer@2.1-service 

# Health
PRODUCT_PACKAGES += \
    android.hardware.health@2.0-service

# dummy HIDL lib
PRODUCT_PACKAGES += \
    android.hidl.base@1.0

# init - vendor-provided service definitions (executed by init scripts)
PRODUCT_COPY_FILES += \
    $(foreach vendor_service, $(wildcard $(LOCAL_PATH)/configs/init/*.rc), \
      $(vendor_service):$(addprefix $(TARGET_COPY_OUT_VENDOR)/etc/init/, $(notdir $(vendor_service))) )

PRODUCT_COPY_FILES += \
    $(foreach vendor_hw_service, $(wildcard $(LOCAL_PATH)/configs/init/hw/*.rc), \
      $(vendor_hw_service):$(addprefix $(TARGET_COPY_OUT_VENDOR)/etc/init/hw/, $(notdir $(vendor_hw_service))) )

PRODUCT_COPY_FILES += \
    $(foreach vendor_service_bin, $(wildcard $(LOCAL_PATH)/configs/init/bin/*.sh), \
      $(vendor_service_bin):$(addprefix $(TARGET_COPY_OUT_VENDOR)/bin/, $(notdir $(vendor_service_bin))) )

PRODUCT_COPY_FILES += \
    $(LOCAL_PATH)/configs/init.recovery.qcom.rc:root/init.recovery.qcom.rc \
    $(LOCAL_PATH)/configs/init.qcom.rc:root/init.qcom.rc \
    $(LOCAL_PATH)/configs/fstab.qcom:$(TARGET_COPY_OUT_VENDOR)/etc/fstab.qcom \
    $(LOCAL_PATH)/configs/ueventd.rc:$(TARGET_COPY_OUT_VENDOR)/ueventd.rc

# input
PRODUCT_COPY_FILES += $(foreach input_config, $(wildcard $(LOCAL_PATH)/configs/keylayouts/*), \
    $(input_config):$(addprefix system/usr/keylayout/, $(notdir $(input_config))) )

# IPC router config
PRODUCT_COPY_FILES += \
    $(LOCAL_PATH)/configs/sec_config:$(TARGET_COPY_OUT_VENDOR)/etc/sec_config

# IRQ
PRODUCT_COPY_FILES += $(foreach irq_config, $(wildcard $(LOCAL_PATH)/configs/irqbalance/*), \
    $(irq_config):$(addprefix $(TARGET_COPY_OUT_VENDOR)/etc/, $(notdir $(irq_config))) )

# Light - hidl
PRODUCT_PACKAGES += \
    android.hardware.light@2.0-impl \
    android.hardware.light@2.0-service

# Media
PRODUCT_PACKAGES += \
    libstagefrighthw    

# Media - codecs - device-specific
PRODUCT_COPY_FILES += $(foreach media_config, $(wildcard $(LOCAL_PATH)/configs/media/*), \
    $(media_config):$(addprefix $(TARGET_COPY_OUT_VENDOR)/etc/, $(notdir $(media_config))) )

# Media - codecs - standard google codecs we need
PRODUCT_COPY_FILES += \
    frameworks/av/media/libstagefright/data/media_codecs_google_telephony.xml:$(TARGET_COPY_OUT_VENDOR)/etc/media_codecs_google_telephony.xml \
    frameworks/av/media/libstagefright/data/media_codecs_google_video.xml:$(TARGET_COPY_OUT_VENDOR)/etc/media_codecs_google_video.xml \
    frameworks/av/media/libstagefright/data/media_codecs_google_video_le.xml:$(TARGET_COPY_OUT_VENDOR)/etc/media_codecs_google_video_le.xml

# Memtrack - hidl
PRODUCT_PACKAGES += \
    android.hardware.memtrack@1.0-impl \
    android.hardware.memtrack@1.0-service

# Misc
PRODUCT_PACKAGES += \
    telephony-ext

# Net
PRODUCT_PACKAGES += \
    libandroid_net \
    netutils-wrapper-1.0

# Permissions
PRODUCT_COPY_FILES += \
    frameworks/native/data/etc/android.hardware.bluetooth.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.bluetooth.xml \
    frameworks/native/data/etc/android.hardware.bluetooth_le.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.bluetooth_le.xml \
    frameworks/native/data/etc/android.hardware.camera.flash-autofocus.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.camera.flash-autofocus.xml \
    frameworks/native/data/etc/android.hardware.camera.front.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.camera.front.xml \
    frameworks/native/data/etc/android.hardware.camera.full.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.camera.full.xml \
    frameworks/native/data/etc/android.hardware.camera.raw.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.camera.raw.xml \
    frameworks/native/data/etc/android.hardware.location.gps.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.location.gps.xml \
    frameworks/native/data/etc/android.hardware.opengles.aep.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.opengles.aep.xml \
    frameworks/native/data/etc/android.hardware.sensor.accelerometer.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.sensor.accelerometer.xml \
    frameworks/native/data/etc/android.hardware.sensor.stepcounter.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.sensor.stepcounter.xml \
    frameworks/native/data/etc/android.hardware.sensor.stepdetector.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.sensor.stepdetector.xml \
    frameworks/native/data/etc/android.hardware.telephony.cdma.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.telephony.cdma.xml \
    frameworks/native/data/etc/android.hardware.telephony.gsm.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.telephony.gsm.xml \
    frameworks/native/data/etc/android.hardware.touchscreen.multitouch.jazzhand.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.touchscreen.multitouch.jazzhand.xml \
    frameworks/native/data/etc/android.hardware.usb.accessory.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.usb.accessory.xml \
    frameworks/native/data/etc/android.hardware.usb.host.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.usb.host.xml \
    frameworks/native/data/etc/android.hardware.vulkan.compute-0.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.vulkan.compute-0.xml \
    frameworks/native/data/etc/android.hardware.vulkan.level-0.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.vulkan.level-0.xml \
    frameworks/native/data/etc/android.hardware.vulkan.version-1_1.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.vulkan.version-1_1.xml \
    frameworks/native/data/etc/android.hardware.wifi.direct.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.wifi.direct.xml \
    frameworks/native/data/etc/android.hardware.wifi.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.wifi.xml \
    frameworks/native/data/etc/android.software.midi.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.software.midi.xml \
    frameworks/native/data/etc/android.software.sip.voip.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.software.sip.voip.xml \
    frameworks/native/data/etc/handheld_core_hardware.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/handheld_core_hardware.xml \

# Public Libraries
PRODUCT_COPY_FILES += \
    $(LOCAL_PATH)/configs/public.libraries.txt:$(TARGET_COPY_OUT_VENDOR)/etc/public.libraries.txt

# QTI
PRODUCT_COPY_FILES += \
    $(LOCAL_PATH)/configs/privapp-permissions-qti.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/privapp-permissions-qti.xml

# Qualcomm dependencies
PRODUCT_PACKAGES += \
    libtinyxml \
    libxml2

# Seccomp
PRODUCT_COPY_FILES += $(foreach seccomp_config, $(wildcard $(LOCAL_PATH)/configs/seccomp_policy/*), \
    $(seccomp_config):$(addprefix $(TARGET_COPY_OUT_VENDOR)/etc/seccomp_policy/, $(notdir $(seccomp_config))) )

# Sensors
PRODUCT_COPY_FILES += $(foreach sensor_config, $(wildcard $(LOCAL_PATH)/configs/sensors/*), \
    $(sensor_config):$(addprefix $(TARGET_COPY_OUT_VENDOR)/etc/sensors/, $(notdir $(sensor_config))) )

# Sensors - hidl
PRODUCT_PACKAGES += \
    android.hardware.sensors@1.0-impl \
    android.hardware.sensors@1.0-service

# Create a link for sensors.qcom which expects the default sensor configuration at /etc/sensors
# To be able to move this file to /vendor a link /vendor/snsc is created, which points to
# /vendor/etc/sensors
CREATE_SYMLINKS += \
    /vendor/etc/sensors:/vendor/snsc

# System Properties
-include $(LOCAL_PATH)/system_prop.mk

# Whitelist
PRODUCT_COPY_FILES += \
    $(LOCAL_PATH)/configs/qti_whitelist.xml:system/etc/sysconfig/qti_whitelist.xml

############# start wifi #############
# Wifi
# TODO
PRODUCT_PACKAGES += \
    wcnss_service \
    libwifi-hal-qcom \
    wpa_supplicant \
    wificond \
    hostapd \
    libwcnss_qmi

#    wifilogd \
#    libqsap_sdk \
#    libQWiFiSoftApCfg \
#    wpa_supplicant.conf \
#    libqmi_cci \
#    libmdmdetect \
#    libqmiservices \

# wifi - hidl
PRODUCT_PACKAGES += \
    android.hardware.wifi@1.0-service \
    android.hardware.wifi.supplicant@1.0-service

# /vendor/etc/wifi
PRODUCT_COPY_FILES += $(LOCAL_PATH)/configs/wifi/p2p_supplicant_overlay.conf:$(TARGET_COPY_OUT_VENDOR)/etc/wifi/p2p_supplicant_overlay.conf
PRODUCT_COPY_FILES += $(LOCAL_PATH)/configs/wifi/wpa_supplicant.conf:$(TARGET_COPY_OUT_VENDOR)/etc/wifi/wpa_supplicant.conf
PRODUCT_COPY_FILES += $(LOCAL_PATH)/configs/wifi/wpa_supplicant_overlay.conf:$(TARGET_COPY_OUT_VENDOR)/etc/wifi/wpa_supplicant_overlay.conf
PRODUCT_COPY_FILES += $(LOCAL_PATH)/configs/wifi/WCNSS_qcom_cfg.ini:$(TARGET_COPY_OUT_VENDOR)/etc/wifi/WCNSS_qcom_cfg.ini

# /vendor/firmware/wlan/prima
PRODUCT_COPY_FILES += $(LOCAL_PATH)/configs/wifi/WCNSS_qcom_wlan_nv.bin:$(TARGET_COPY_OUT_VENDOR)/firmware/wlan/prima/WCNSS_qcom_wlan_nv.bin
PRODUCT_COPY_FILES += $(LOCAL_PATH)/configs/wifi/WCNSS_wlan_dictionary.dat:$(TARGET_COPY_OUT_VENDOR)/firmware/wlan/prima/WCNSS_wlan_dictionary.dat

# /system/etc/firmware/wlan/prima  (in proprietary-files.txt)
#PRODUCT_COPY_FILES += $(LOCAL_PATH)/configs/wifi/WCNSS_cfg.dat:system/etc/firmware/wlan/prima/WCNSS_cfg.dat

# /system/etc/hostapd
PRODUCT_COPY_FILES += $(LOCAL_PATH)/configs/wifi/hostapd_default.conf:system/etc/hostapd/hostapd_default.conf 

# symlink to WCNSS_qcom_cfg.ini
CREATE_SYMLINKS += \
    /vendor/etc/wifi/WCNSS_qcom_cfg.ini:/vendor/firmware/wlan/prima/WCNSS_qcom_cfg.ini

# symlink to iwpriv, which some modules expect in system/xbin
CREATE_SYMLINKS += \
    /system/bin/iwpriv:/system/xbin/iwpriv

############# end wifi #############

###
# add some JARs to the BOOTCLASSPATH
###
PRODUCT_BOOT_JARS += \
    qcom.fmradio 
# TODO these are in BOOTCLASSPATH of stock M10 - do we need them pre-loaded?
#    com.qualcomm.qti.camera \
#    ifaa_fw \
#    QPerformance \
#    tcmiface \
#    telephony-ext \
#    UxPerformance \
#    WfdCommon

