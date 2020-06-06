#
# reads WLAN MAC address from persist storage
#
LOCAL_PATH := $(call my-dir)

include $(CLEAR_VARS)

LOCAL_MODULE := libwcnss_qmi
LOCAL_MODULE_TAGS := optional
LOCAL_VENDOR_MODULE := true

LOCAL_SRC_FILES += wcnss_qmi_client.c
LOCAL_CFLAGS += -DWCNSS_QMI -Wall
LOCAL_SHARED_LIBRARIES := libc libcutils libutils liblog

include $(BUILD_SHARED_LIBRARY)

