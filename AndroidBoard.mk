LOCAL_PATH := $(call my-dir)

TI_OMX_POLICY_MANAGER := hardware/ti/omx/system/src/openmax_il/omx_policy_manager

# kernel binary
# this is here to use the pre-built kernel
ifeq ($(TARGET_PREBUILT_KERNEL),)
TARGET_PREBUILT_KERNEL := $(LOCAL_PATH)/kernel
endif

file := $(INSTALLED_KERNEL_TARGET)
ALL_PREBUILT += $(file)
$(file): $(TARGET_PREBUILT_KERNEL) | $(ACP)
         $(transform-prebuilt-to-target)

# keyboard layouts
#
PRODUCT_COPY_FILES += \
        $(LOCAL_PATH)/omap-keypad.kl:system/usr/keylayout/omap-keypad.kl


# system configuration files
#
PRODUCT_COPY_FILES += \
        $(LOCAL_PATH)/vold.conf:system/etc/vold.conf \
        $(LOCAL_PATH)/vold.fstab:system/etc/vold.fstab \
        $(LOCAL_PATH)/asound.conf:system/etc/asound.conf \
        $(TI_OMX_POLICY_MANAGER)/src/policytable.tbl:system/etc/policytable.tbl \
        $(LOCAL_PATH)/media_profiles.xml:system/etc/media_profiles.xml

# keyboard maps
#
include $(CLEAR_VARS)
LOCAL_SRC_FILES := omap-keypad.kcm
LOCAL_MODULE_TAGS:= optional

include $(BUILD_KEY_CHAR_MAP)

# board specific init.rc
#
PRODUCT_COPY_FILES += \
	$(LOCAL_PATH)/init.omap4sdp.rc:root/init.omap4sdp.rc
