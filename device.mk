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

DEVICE_PACKAGE_OVERLAYS := device/ti/omap5sevm/overlay

ifeq ($(TARGET_PREBUILT_KERNEL),)
LOCAL_KERNEL := device/ti/omap5sevm/boot/zImage
else
LOCAL_KERNEL := $(TARGET_PREBUILT_KERNEL)
endif

PRODUCT_COPY_FILES := \
	$(LOCAL_KERNEL):kernel \
	$(LOCAL_KERNEL):boot/zImage \
	device/ti/omap5sevm/init.omap5sevmboard.rc:root/init.omap5sevmboard.rc \
	device/ti/omap5sevm/init.omap5sevmboard.usb.rc:root/init.omap5sevmboard.usb.rc \
	device/ti/omap5sevm/ueventd.omap5sevmboard.rc:root/ueventd.omap5sevmboard.rc \
	device/ti/omap5sevm/omap4-keypad.kl:system/usr/keylayout/omap4-keypad.kl \
	device/ti/omap5sevm/qtouch-touchscreen.idc:system/usr/idc/qtouch-touchscreen.idc \
	device/ti/omap5sevm/omap4-keypad.kcm:system/usr/keychars/omap4-keypad.kcm \
        device/ti/omap5sevm/twl6030_pwrbutton.kl:system/usr/keylayout/twl6030_pwrbutton.kl \
        device/ti/omap5sevm/palmas-pwrbutton.kl:system/usr/keylayout/palmas-pwrbutton.kl \
	device/ti/omap5sevm/media_profiles.xml:system/etc/media_profiles.xml \
	device/ti/omap5sevm/init.rc:root/init.rc

# to mount the external storage (sdcard)
PRODUCT_COPY_FILES += \
        device/ti/omap5sevm/vold.fstab:system/etc/vold.fstab

# These are the hardware-specific features
PRODUCT_COPY_FILES += \
	frameworks/base/data/etc/android.hardware.usb.host.xml:system/etc/permissions/android.hardware.usb.host.xml \
	frameworks/base/data/etc/android.hardware.usb.accessory.xml:system/etc/permissions/android.hardware.usb.accessory.xml \
	frameworks/base/data/etc/android.hardware.wifi.xml:system/etc/permissions/android.hardware.wifi.xml \
	frameworks/base/data/etc/android.hardware.wifi.direct.xml:system/etc/permissions/android.hardware.wifi.direct.xml \
	device/ti/omap5sevm/android.hardware.bluetooth.xml:system/etc/permissions/android.hardware.bluetooth.xml \
        frameworks/base/data/etc/android.hardware.nfc.xml:system/etc/permissions/android.hardware.nfc.xml \
        frameworks/base/nfc-extras/com.android.nfc_extras.xml:system/etc/permissions/com.android.nfcextras.xml \
        device/sample/nxp/com.nxp.mifare.xml:system/etc/permissions/com.nxp.mifare.xml \
        device/ti/omap5sevm/nfcee_access.xml:system/etc/nfcee_access.xml \
	frameworks/base/data/etc/android.hardware.sensor.proximity.xml:system/etc/permissions/android.hardware.sensor.proximity.xml \
	frameworks/base/data/etc/android.hardware.sensor.light.xml:system/etc/permissions/android.hardware.sensor.light.xml \
	frameworks/base/data/etc/android.hardware.touchscreen.multitouch.jazzhand.xml:system/etc/permissions/android.hardware.touchscreen.multitouch.jazzhand.xml \
	packages/wallpapers/LivePicker/android.software.live_wallpaper.xml:system/etc/permissions/android.software.live_wallpaper.xml

PRODUCT_PACKAGES := \
    libOMX_Core \
    libOMX.TI.DUCATI1.VIDEO.DECODER

# Tiler
PRODUCT_PACKAGES += \
    libtimemmgr

#HWC Hal
PRODUCT_PACKAGES += \
    hwcomposer.omap5

#Lib Skia test
PRODUCT_PACKAGES += \
    SkLibTiJpeg_Test

# Camera
PRODUCT_PACKAGES += \
    Camera \
    CameraOMAP4 \
    camera_test

PRODUCT_PACKAGES += \
	com.android.future.usb.accessory

PRODUCT_PACKAGES += \
	boardidentity \
	libboardidentity \
	libboard_idJNI \
	Board_id

PRODUCT_PROPERTY_OVERRIDES := \
	hwui.render_dirty_regions=false

PRODUCT_DEFAULT_PROPERTY_OVERRIDES += \
	persist.sys.usb.config=mtp

PRODUCT_PROPERTY_OVERRIDES += \
	ro.opengles.version=131072

PRODUCT_PROPERTY_OVERRIDES += \
	ro.sf.lcd_density=320

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

# WI-Fi
PRODUCT_PACKAGES += \
	dhcpcd.conf \
	hostapd.conf \
	wifical.sh \
	TQS_D_1.7.ini \
	TQS_D_1.7_127x.ini \
	crda \
	regulatory.bin \
	calibrator

# Audio HAL module
PRODUCT_PACKAGES += audio.primary.omap5sevmboard


# BlueZ a2dp Audio HAL module
PRODUCT_PACKAGES += audio.a2dp.default

# Audioout libs
PRODUCT_PACKAGES += libaudioutils

# Lights
PRODUCT_PACKAGES += \
        lights.omap5sevm

# Sensors
PRODUCT_PACKAGES += \
        sensors.omap5sevm \
        sensor.test

# BlueZ test tools & Shared Transport user space mgr
PRODUCT_PACKAGES += \
	hciconfig \
	hcitool

# Live Wallpapers
PRODUCT_PACKAGES += \
        LiveWallpapers \
        LiveWallpapersPicker \
        MagicSmokeWallpapers \
        VisualizationWallpapers \
        librs_jni

# SMC components for secure services like crypto, secure storage
PRODUCT_PACKAGES += \
        smc_pa.ift \
        smc_normal_world_android_cfg.ini \
        libsmapi.so \
        libtf_crypto_sst.so \
        libtfsw_jce_provider.so \
        tfsw_jce_provider.jar \
        tfctrl

PRODUCT_PACKAGES += \
	tinymix \
	tinyplay \
	tinycap

$(call inherit-product, frameworks/base/build/tablet-dalvik-heap.mk)
$(call inherit-product, hardware/ti/omap4xxx/omap4.mk)
$(call inherit-product-if-exists, hardware/ti/wpan/ti-wpan-products.mk)
$(call inherit-product-if-exists, vendor/ti/omap5sevm/device-vendor.mk)
$(call inherit-product-if-exists, device/ti/proprietary-open/wl12xx/wlan/wl12xx-wlan-fw-products.mk)
