LOCAL_PATH := $(call my-dir)

include $(CLEAR_VARS)

LOCAL_MODULE_TAGS := optional
LOCAL_C_INCLUDES := system/core/init
LOCAL_C_INCLUDES += system/core/base/include
LOCAL_CFLAGS := -Wall
LOCAL_SRC_FILES := init_x605f.cpp
LOCAL_MODULE := libinit_x605f

include $(BUILD_STATIC_LIBRARY)

