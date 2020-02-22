#
# hardware/qcom/wlan-caf/wcnss-service does not build libwcnss_qmi, so we have to build it ourselves.
# The extra proprietary headers are needed because CAF does not build libril-qc-qmi-services-headers.
#
LOCAL_PATH := $(call my-dir)

include $(CLEAR_VARS)

MY_WCNSS_PATH := ../../../../../hardware/qcom/wlan-caf/wcnss-service

LOCAL_MODULE := libwcnss_qmi
LOCAL_MODULE_TAGS := optional
LOCAL_VENDOR_MODULE := true

LOCAL_SRC_FILES += $(MY_WCNSS_PATH)/wcnss_qmi_client.c
LOCAL_CFLAGS += -DWCNSS_QMI -Wall
LOCAL_SHARED_LIBRARIES := libc libcutils libutils liblog
LOCAL_SHARED_LIBRARIES += libqmiservices libqmi_cci
LOCAL_SHARED_LIBRARIES += libmdmdetect

LOCAL_C_INCLUDES += $(TARGET_OUT_HEADERS)/qmi-framework/inc
LOCAL_C_INCLUDES += $(TARGET_OUT_HEADERS)/qmi/services
LOCAL_C_INCLUDES += $(TARGET_OUT_HEADERS)/qmi/platform
LOCAL_C_INCLUDES += $(TARGET_OUT_HEADERS)/qmi/inc
LOCAL_C_INCLUDES += $(TARGET_OUT_HEADERS)/libmdmdetect/inc
LOCAL_C_INCLUDES += $(MY_WCNSS_PATH)
LOCAL_C_INCLUDES += $(LOCAL_PATH)

include $(BUILD_SHARED_LIBRARY)

