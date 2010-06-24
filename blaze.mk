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
	SdkSetup \
	LiveWallpapers \
	LiveWallpapersPicker \
	MagicSmokeWallpapers \
	VisualizationWallpapers

#PRODUCT_COPY_FILES += device/ti/blaze/apns.xml:system/etc/apns-conf.xml

# Pick up audio package
include frameworks/base/data/sounds/AudioPackage2.mk

