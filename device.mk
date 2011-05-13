#
# Copyright (C) 2011 Texas Instruments Inc.
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

ifeq ($(TARGET_PREBUILT_KERNEL),)
LOCAL_KERNEL := device/ti/blaze/boot/zImage
else
LOCAL_KERNEL := $(TARGET_PREBUILT_KERNEL)
endif

PRODUCT_COPY_FILES := \
	$(LOCAL_KERNEL):kernel \
        device/ti/blaze/boot/fastboot.sh:fastboot.sh \
        $(LOCAL_KERNEL):boot/zImage \
        device/ti/blaze/boot/MLO_es2.2_emu:boot/MLO_es2.2_emu \
        device/ti/blaze/boot/MLO_es2.2_gp:boot/MLO_es2.2_gp \
        device/ti/blaze/boot/u-boot.bin:boot/u-boot.bin \
	device/ti/blaze/init.omap4blazeboard.rc:root/init.omap4blazeboard.rc \
	device/ti/blaze/ueventd.omap4blazeboard.rc:root/ueventd.omap4blazeboard.rc \
	device/ti/blaze/omap4-keypad.kl:system/usr/keylayout/omap4-keypad.kl \
	device/ti/blaze/media_profiles.xml:system/etc/media_profiles.xml \
	frameworks/base/data/etc/android.hardware.usb.host.xml:system/etc/permissions/android.hardware.usb.host.xml \
	frameworks/base/data/etc/android.hardware.usb.accessory.xml:system/etc/permissions/android.hardware.usb.accessory.xml

PRODUCT_PACKAGES := \
	com.android.future.usb.accessory

PRODUCT_PROPERTY_OVERRIDES := \
	hwui.render_dirty_regions=false

PRODUCT_CHARACTERISTICS := tablet,nosdcard

PRODUCT_TAGS += dalvik.gc.type-precise

PRODUCT_PACKAGES += \
	librs_jni \
	com.android.future.usb.accessory

# Filesystem management tools
PRODUCT_PACKAGES += \
	make_ext4fs

# Generated kcm keymaps
PRODUCT_PACKAGES += \
        omap4-keypad.kcm

$(call inherit-product, frameworks/base/build/tablet-dalvik-heap.mk)
$(call inherit-product-if-exists, vendor/ti/proprietary/omap4/ti-omap4-vendor.mk)
