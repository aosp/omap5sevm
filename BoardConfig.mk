# OMAP Next Generation Board configuration
#
TARGET_BOARD_PLATFORM := omap4
TARGET_NO_BOOTLOADER := true
TARGET_CPU_ABI := armeabi
TARGET_ARCH_VARIANT := armv7-a
ARCH_ARM_HAVE_TLS_REGISTER := true

# Kernel/Bootloader machine name
#
TARGET_BOOTLOADER_BOARD_NAME := omap4sdp
TARGET_NO_KERNEL := true

# Modem
TARGET_NO_RADIOIMAGE := true

# Graphics
# TARGET_HARDWARE_3D := true

# Wifi
BOARD_WPA_SUPPLICANT_DRIVER := CUSTOM
BOARD_WLAN_DEVICE           := wl1283
WPA_SUPPLICANT_VERSION      := VER_0_6_X
WIFI_DRIVER_MODULE_PATH     := "/system/etc/wifi/tiwlan_drv.ko"
WIFI_DRIVER_MODULE_NAME     := "tiwlan_drv"
WIFI_FIRMWARE_LOADER        := "wlan_loader"

# Bluetooth
BOARD_HAVE_BLUETOOTH := true

# FM
#BUILD_FM_RADIO := true
#FM_CHR_DEV_ST := true
#BOARD_HAVE_FM_ROUTING := true

# MultiMedia defines
USE_CAMERA_STUB := true
BOARD_USES_GENERIC_AUDIO := true
#BOARD_USES_ALSA_AUDIO := true
#BUILD_WITH_ALSA_UTILS := true
#BOARD_USES_TI_CAMERA_HAL := true
#HARDWARE_OMX := true
#FW3A := true
#ICAP := true
#IMAGE_PROCESSING_PIPELINE := true 
ifdef HARDWARE_OMX
OMX_VENDOR := ti
OMX_VENDOR_INCLUDES := \
   hardware/ti/omx/system/src/openmax_il/omx_core/inc \
   hardware/ti/omx/image/src/openmax_il/jpeg_enc/inc
OMX_VENDOR_WRAPPER := TI_OMX_Wrapper
BOARD_OPENCORE_LIBRARIES := libOMX_Core
BOARD_OPENCORE_FLAGS := -DHARDWARE_OMX=1
endif

# This define enables the compilation of OpenCore's command line TestApps
#BUILD_PV_TEST_APPS :=1

