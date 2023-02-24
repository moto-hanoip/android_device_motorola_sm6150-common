# Copyright 2014 The Android Open Source Project
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

TARGET_ARCH_VARIANT := armv8-a
TARGET_2ND_ARCH_VARIANT := armv8-a

BOARD_KERNEL_BASE        := 0x00000000
BOARD_KERNEL_PAGESIZE    := 4096
BOARD_RAMDISK_OFFSET     := 0x01000000
BOARD_DTB_OFFSET         := 0x01f00000
BOARD_MKBOOTIMG_ARGS += --dtb_offset $(BOARD_DTB_OFFSET)

TARGET_RECOVERY_FSTAB ?= $(PLATFORM_COMMON_PATH)/rootdir/vendor/etc/fstab.qcom

# Kernel
BOARD_KERNEL_CMDLINE += androidboot.usbcontroller=a600000.dwc3
BOARD_KERNEL_IMAGE_NAME := Image.gz

# SELinux
BOARD_USE_ENFORCING_SELINUX := true
TARGET_SEPOLICY_DIR := msmsteppe
BOARD_VENDOR_SEPOLICY_DIRS += $(PLATFORM_COMMON_PATH)/sepolicy_platform

# DTBO
BOARD_DTBOIMG_PARTITION_SIZE ?= 8388608

# Boot Image
BOARD_BOOTIMAGE_PARTITION_SIZE ?= 67108864
BOARD_BOOT_HEADER_VERSION ?= 2
BOARD_INCLUDE_DTB_IN_BOOTIMG := true

# Build a separate vendor.img
TARGET_COPY_OUT_VENDOR := vendor
BOARD_VENDORIMAGE_FILE_SYSTEM_TYPE := ext4

ifneq ($(TARGET_USES_LEGACY_AB),true)
# Build product image
TARGET_COPY_OUT_PRODUCT := product
BOARD_PRODUCTIMAGE_FILE_SYSTEM_TYPE := ext4
endif

# This platform has a metadata partition: declare this
# to create a mount point for it
BOARD_USES_METADATA_PARTITION := true

BOARD_AVB_ENABLE := true
BOARD_AVB_MAKE_VBMETA_IMAGE_ARGS += --flags 3
TARGET_HAS_VBMETA_SYSTEM ?= true
ifneq ($(TARGET_USES_LEGACY_AB),true)
ifeq ($(TARGET_HAS_VBMETA_SYSTEM),true)
BOARD_AVB_VBMETA_SYSTEM := system
BOARD_AVB_VBMETA_SYSTEM_KEY_PATH ?= external/avb/test/data/testkey_rsa2048.pem
BOARD_AVB_VBMETA_SYSTEM_ALGORITHM ?= SHA256_RSA2048
BOARD_AVB_VBMETA_SYSTEM_ROLLBACK_INDEX := $(PLATFORM_SECURITY_PATCH_TIMESTAMP)
BOARD_AVB_VBMETA_SYSTEM_ROLLBACK_INDEX_LOCATION := 1
endif
endif

# DTBO Recovery
BOARD_INCLUDE_RECOVERY_DTBO := true

# USB
SOONG_CONFIG_MOTO_COMMON_USB_USB_CONTROLLER_NAME := a600000

# Power
SOONG_CONFIG_MOTO_COMMON_POWER_FB_IDLE_PATH ?= /sys/devices/platform/soc/ae00000.qcom,mdss_mdp/idle_state

include device/motorola/common/CommonConfig.mk
