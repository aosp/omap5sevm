#
# Copyright (C) 2009 Texas Instruments
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

PRODUCT_PACKAGE_OVERLAYS := device/ti/blaze/overlay

$(call inherit-product, $(LOCAL_PATH)/omap_generic.mk)

# Overrides
PRODUCT_NAME := blaze
PRODUCT_MODEL := Blaze generic
PRODUCT_LOCALES := en_US

PRODUCT_PROPERTY_OVERRIDES += \
        ro.com.android.dateformat=MM-dd-yyyy \
        ro.com.android.dataroaming=true \
        ro.url.legal=http://www.google.com/intl/%s/mobile/android/basic/phone-legal.html \
        ro.url.legal.android_privacy=http://www.google.com/intl/%s/mobile/android/basic/privacy.html

PRODUCT_PACKAGES += \
        Quake \
        FieldTest \
        LiveWallpapers \
        LiveWallpapersPicker \
        MagicSmokeWallpapers \
        VisualizationWallpapers \
        CameraOMAP4 \
        libRS \
        librs_jni

PRODUCT_COPY_FILES += device/ti/blaze/apns.xml:system/etc/apns-conf.xml \
        frameworks/base/data/etc/android.hardware.camera.flash-autofocus.xml:system/etc/permissions/android.hardware.camera.flash-autofocus.xml \
        packages/wallpapers/LivePicker/android.software.live_wallpaper.xml:/system/etc/permissions/android.software.live_wallpaper.xml \
        frameworks/base/data/etc/android.hardware.wifi.xml:system/etc/permissions/android.hardware.wifi.xml \
        frameworks/base/data/etc/android.hardware.touchscreen.multitouch.distinct.xml:system/etc/permissions/android.hardware.touchscreen.multitouch.distinct.xml


# Pick up audio package
include frameworks/base/data/sounds/AudioPackage2.mk

