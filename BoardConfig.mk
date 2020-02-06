#
# Copyright 2019 The Android Open Source Project
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

# This contains the module build definitions for the hardware-specific
# components for this device.
#
# As much as possible, those components should be built unconditionally,
# with device-specific names to avoid collisions, to avoid device-specific
# bitrot and build breakages. Building a component unconditionally does
# *not* include it on all devices, so it is safe even with hardware-specific
# components.

LOCAL_PATH := device/lenovo/X605F
BOARD_VENDOR := lenovo

# Architecture
TARGET_ARCH := arm64
TARGET_ARCH_VARIANT := armv8-a
TARGET_CPU_ABI := arm64-v8a
TARGET_CPU_ABI2 :=
TARGET_CPU_VARIANT := generic

TARGET_2ND_ARCH := arm
TARGET_2ND_ARCH_VARIANT := armv8-a
TARGET_2ND_CPU_ABI := armeabi-v7a
TARGET_2ND_CPU_ABI2 := armeabi
TARGET_2ND_CPU_VARIANT := cortex-a53

# binder
TARGET_USES_64_BIT_BINDER := true

# Bootloader
TARGET_BOOTLOADER_BOARD_NAME := msm8953
TARGET_NO_BOOTLOADER := true

# Dexpreopt
ifeq ($(HOST_OS),linux)
  ifneq ($(TARGET_BUILD_VARIANT),eng)
    WITH_DEXPREOPT ?= true
  endif
endif
WITH_DEXPREOPT_BOOT_IMG_AND_SYSTEM_SERVER_ONLY ?= true

# Kernel
BOARD_KERNEL_BASE := 0x80000000
BOARD_KERNEL_PAGESIZE := 2048
#BOARD_KERNEL_CMDLINE := sched_enable_hmp=1 sched_enable_power_aware=1 console=null
BOARD_KERNEL_CMDLINE := console=ttyHSL0,115200,n8 
BOARD_KERNEL_CMDLINE += androidboot.console=ttyHSL0 
BOARD_KERNEL_CMDLINE += androidboot.hardware=qcom 
BOARD_KERNEL_CMDLINE += msm_rtb.filter=0x237 
BOARD_KERNEL_CMDLINE += ehci-hcd.park=3 
BOARD_KERNEL_CMDLINE += lpm_levels.sleep_disabled=1 
BOARD_KERNEL_CMDLINE += androidboot.bootdevice=7824900.sdhci 
BOARD_KERNEL_CMDLINE += earlycon=msm_hsl_uart,0x78af000 
BOARD_KERNEL_CMDLINE += firmware_class.path=/vendor/firmware_mnt/image 
BOARD_KERNEL_CMDLINE += loop.max_part=7 
#BOARD_KERNEL_CMDLINE += androidboot.usbconfigfs=false 
#BOARD_KERNEL_CMDLINE += buildvariant=user
BOARD_KERNEL_CMDLINE += androidboot.selinux=permissive
BOARD_KERNEL_IMAGE_NAME := Image.gz-dtb
BOARD_KERNEL_OFFSET = 0x00008000
BOARD_KERNEL_TAGS_OFFSET := 0x0000100

# kernel - compile
NEED_KERNEL_MODULE_SYSTEM := true
TARGET_KERNEL_ARCH := arm64
TARGET_KERNEL_CONFIG := lineage_x605f_defconfig
TARGET_KERNEL_CROSS_COMPILE_PREFIX := aarch64-linux-android-
# TODO - can we use LOS generic kernel ? TARGET_KERNEL_SOURCE := kernel/lenovo/msm8953
TARGET_KERNEL_SOURCE := kernel/lenovo/x605f

# kernel - ramdisk
BOARD_RAMDISK_OFFSET := 0x01000000

# Partitions
BOARD_FLASH_BLOCK_SIZE := 131072
BOARD_BOOTIMAGE_PARTITION_SIZE := 0x04000000
BOARD_CACHEIMAGE_PARTITION_SIZE := 0x10000000
BOARD_RECOVERYIMAGE_PARTITION_SIZE := 0x04000000
BOARD_SYSTEMIMAGE_PARTITION_SIZE := 0xC0000000
BOARD_USERDATAIMAGE_PARTITION_SIZE := 0x05E2379E00
BOARD_PERSISTIMAGE_PARTITION_SIZE := 0x02000000
BOARD_VENDORIMAGE_PARTITION_SIZE := 0x40000000
# fs types
BOARD_CACHEIMAGE_FILE_SYSTEM_TYPE := ext4
BOARD_SYSTEMIMAGE_FILE_SYSTEM_TYPE := ext4
BOARD_USERDATAIMAGE_FILE_SYSTEM_TYPE := ext4
BOARD_VENDORIMAGE_FILE_SYSTEM_TYPE := ext4

# Platform
TARGET_BOARD_PLATFORM := msm8953
TARGET_BOARD_PLATFORM_GPU := qcom-adreno506

# Recovery
TARGET_RECOVERY_FSTAB := $(LOCAL_PATH)/recovery/root/etc/recovery.fstab

# SELinux
include device/qcom/sepolicy/sepolicy.mk
BOARD_SEPOLICY_DIRS += $(DEVICE_PATH)/sepolicy

# Vendor
TARGET_COPY_OUT_VENDOR := vendor

# Verified Boot
BOARD_AVB_ENABLE := true
BOARD_AVB_MAKE_VBMETA_IMAGE_ARGS += --set_hashtree_disabled_flag
BOARD_AVB_MAKE_VBMETA_IMAGE_ARGS += --flags 2

###############
#   devices   #
###############

# Audio TODO
USE_XML_AUDIO_POLICY_CONF := 1
AUDIO_FEATURE_ENABLED_FM_POWER_OPT := true

#AUDIO_FEATURE_ENABLED_AAC_ADTS_OFFLOAD := true
#AUDIO_FEATURE_ENABLED_ACDB_LICENSE := true
#AUDIO_FEATURE_ENABLED_ALAC_OFFLOAD := true
#AUDIO_FEATURE_ENABLED_ANC_HEADSET := true
#AUDIO_FEATURE_ENABLED_APE_OFFLOAD := true
#AUDIO_FEATURE_ENABLED_AUDIOSPHERE := true
#AUDIO_FEATURE_ENABLED_COMPRESS_VOIP := true
#AUDIO_FEATURE_ENABLED_EXTN_FORMATS := true
#AUDIO_FEATURE_ENABLED_EXTN_FLAC_DECODER := true
## AUDIO_FEATURE_ENABLED_EXTN_RESAMPLER := true
#AUDIO_FEATURE_ENABLED_FM_POWER_OPT := true
#AUDIO_FEATURE_ENABLED_HFP := true
#AUDIO_FEATURE_ENABLED_KPI_OPTIMIZE := true
#AUDIO_FEATURE_ENABLED_MULTI_VOICE_SESSIONS := true
#AUDIO_FEATURE_ENABLED_PCM_OFFLOAD_24 := true
#AUDIO_FEATURE_ENABLED_PCM_OFFLOAD := true
#AUDIO_FEATURE_ENABLED_PROXY_DEVICE := true
#AUDIO_FEATURE_ENABLED_SOURCE_TRACKING := true
#AUDIO_FEATURE_ENABLED_SPKR_PROTECTION := true
#AUDIO_FEATURE_ENABLED_VBAT_MONITOR := true
#AUDIO_FEATURE_ENABLED_VOICE_CONCURRENCY :=true
#AUDIO_FEATURE_ENABLED_VORBIS_OFFLOAD := true
#AUDIO_FEATURE_ENABLED_WMA_OFFLOAD := true
#AUDIO_USE_LL_AS_PRIMARY_OUTPUT := true
#BOARD_USES_ALSA_AUDIO := true
#BOARD_SUPPORTS_SOUND_TRIGGER := true
#USE_CUSTOM_AUDIO_POLICY := 1
#USE_XML_AUDIO_POLICY_CONF := 1
#AUDIO_FEATURE_ENABLED_SND_MONITOR := true

# Bluetooth TODO
#BOARD_BLUETOOTH_BDROID_BUILDCFG_INCLUDE_DIR := $(LOCAL_PATH)/configs/bluetooth
#BOARD_HAVE_BLUETOOTH := true
#BOARD_HAVE_BLUETOOTH_QCOM := true
#BLUETOOTH_HCI_USE_MCT := true
#QCOM_BT_USE_BTNV := true
#QCOM_BT_USE_SMD_TTY := true

# Camera TODO
#USE_DEVICE_SPECIFIC_CAMERA := true
#BOARD_QTI_CAMERA_32BIT_ONLY := true
#TARGET_TS_MAKEUP := true
#TARGET_COMPILE_WITH_MSM_KERNEL := true
#TARGET_USES_QTI_CAMERA_DEVICE := true

# Charger
BOARD_CHARGER_ENABLE_SUSPEND := true

# DRM
TARGET_ENABLE_MEDIADRM_64 := true

# Filesystem
TARGET_FS_CONFIG_GEN := $(LOCAL_PATH)/config.fs

# FM TODO
BOARD_HAVE_QCOM_FM := true
BOARD_HAS_QCA_FM_SOC := "cherokee"

# GPS TODO
##BOARD_VENDOR_QCOM_GPS_LOC_API_HARDWARE := $(TARGET_BOARD_PLATFORM)
#BOARD_VENDOR_QCOM_LOC_PDK_FEATURE_SET := true
#TARGET_NO_RPC := true
#USE_DEVICE_SPECIFIC_GPS := true

# Graphics TODO
#TARGET_USES_HWC2 := true
#NUM_FRAMEBUFFER_SURFACE_BUFFERS := 3

# HIDL
DEVICE_MANIFEST_FILE := $(LOCAL_PATH)/manifest.xml
DEVICE_MATRIX_FILE := $(LOCAL_PATH)/compatibility_matrix.xml
DEVICE_FRAMEWORK_COMPATIBILITY_MATRIX_FILE := $(LOCAL_PATH)/framework_compatibility_matrix.xml

# Wifi TODO
#BOARD_HAS_QCOM_WLAN := true
#BOARD_HAS_QCOM_WLAN_SDK := true
#BOARD_WLAN_DEVICE := qcwcn
#BOARD_HOSTAPD_DRIVER := NL80211
#BOARD_HOSTAPD_PRIVATE_LIB := lib_driver_cmd_$(BOARD_WLAN_DEVICE)
#BOARD_WPA_SUPPLICANT_DRIVER := NL80211
#BOARD_WPA_SUPPLICANT_PRIVATE_LIB := lib_driver_cmd_$(BOARD_WLAN_DEVICE)
#TARGET_USES_QCOM_WCNSS_QMI       := true
#TARGET_PROVIDES_WCNSS_QMI        := true
#WIFI_DRIVER_FW_PATH_AP := "ap"
#WIFI_DRIVER_FW_PATH_STA := "sta"
#WIFI_DRIVER_FW_PATH_P2P := "p2p"
#WPA_SUPPLICANT_VERSION := VER_0_8_X
