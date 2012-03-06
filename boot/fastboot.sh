#!/bin/bash

export FASTBOOT=${FASTBOOT-"./../../../../out/host/linux-x86/bin/fastboot"}
export PRODUCT_OUT=${PRODUCT_OUT-"./"}

usage ()
{
	echo "Usage: %fastboot.sh ";
	exit 1;
}

#no args case
if [ "$1" = "--help" ] ; then
	usage
fi

# =============================================================================
# pre-run
# =============================================================================

# Verify fastboot program is available
# Verify user permission to run fastboot
# Verify fastboot detects a device, otherwise exit
if [ -f ${FASTBOOT} ]; then
	fastboot_status=`${FASTBOOT} devices 2>&1`
	if [ `echo $fastboot_status | grep -wc "no permissions"` -gt 0 ]; then
		cat <<-EOF >&2
		-------------------------------------------
		 Fastboot requires administrator permissions
		 Please run the script as root or create a
		 fastboot udev rule, e.g:

		 % cat /etc/udev/rules.d/99_android.rules
		   SUBSYSTEM=="usb",
		   SYSFS{idVendor}=="0451"
		   OWNER="<username>"
		   GROUP="adm"
		-------------------------------------------
		EOF
		exit 1
	elif [ "X$fastboot_status" = "X" ]; then
		echo "No device detected. Please ensure that" \
			 "fastboot is running on the target device"
                exit -1;
	else
		device=`echo $fastboot_status | awk '{print$1}'`
		echo -e "\nFastboot - device detected: $device\n"
	fi
else
	echo "Error: fastboot is not available at ${FASTBOOT}"
        exit -1;
fi

# poll the board to find out its configuration
product=`${FASTBOOT} getvar product 2>&1 | grep product | awk '{print$2}'`
cputype=`${FASTBOOT} getvar secure 2>&1  | grep secure  | awk '{print$2}'`
cpurev=`${FASTBOOT} getvar cpurev 2>&1   | grep cpurev  | awk '{print$2}'`

# Panda board can not be flashed using fastboot
if [ "${product}" = "PANDA" ]; then
        errormsg "Panda board can not be flashed using fastboot"
fi

# Backwards compatibility for older bootloader versions
if [ "${product}" = "SDP4" ]; then
        product="Blaze"
fi


# Create the filename
bootimg="${PRODUCT_OUT}boot.img"
xloader="${PRODUCT_OUT}${product}_${cputype}_${cpurev}_MLO"
uboot="${PRODUCT_OUT}u-boot.img"
systemimg="${PRODUCT_OUT}system.img"
userdataimg="${PRODUCT_OUT}userdata.img"
cacheimg="${PRODUCT_OUT}cache.img"
efsimg="${PRODUCT_OUT}efs.img"
recoveryimg="${PRODUCT_OUT}recovery.img"


# Verify that all the files required for the fastboot flash
# process are available

if [ ! -e "${bootimg}" ] ; then
  echo "Missing ${bootimg}"
  exit -1;
fi
if [ ! -e "$xloader" ] ; then
  echo "Missing ${xloader}"
  exit -1;
fi
if [ ! -e "${uboot}" ] ; then
  echo "Missing ${uboot}"
  exit -1;
fi
if [ ! -e "${systemimg}" ] ; then
  echo "Missing ${systemimg}"
  exit -1;
fi
if [ ! -e "${userdataimg}" ] ; then
  echo "Missing ${userdataimg}"
  exit -1;
fi
if [ ! -e "${cacheimg}" ] ; then
  echo "Missing ${cacheimg}"
  #exit -1;
fi
if [ ! -e "${recoveryimg}" ] ; then
  echo "Missing ${recoveryimg}"
#  exit -1;
fi

echo "Flashing bootloader....."
echo "   xloader: ${xloader}"
${FASTBOOT} flash xloader 	${xloader}
${FASTBOOT} flash bootloader 	${uboot}

sleep 5

echo "Create GPT partition table"
${FASTBOOT} oem format

echo "Flash android partitions"
${FASTBOOT} flash boot 		${bootimg}
#${FASTBOOT} flash recovery	${recoveryimg}
${FASTBOOT} flash system 	${systemimg}
${FASTBOOT} flash userdata ${userdataimg}

if [ "$1" != "--noefs" ] ; then
	if [ ! -f ${efsimg} ] ; then
	  echo "Creating efs.img as 16M ext4 img..."
	  test -d ./efs/ || mkdir efs
	  ./make_ext4fs -s -l 16M -a efs efs.img efs/
	else
          echo "Using previously created efs.img..."
	fi

	${FASTBOOT} flash efs ${efsimg}
else
  echo "efs partition is untouched"
fi

#Create cache.img
if [ ! -f ${cacheimg} ]
then
	echo "Creating cache.img as empty ext4 img...."
	rm -rf /tmp/fastboot-cache
	mkdir /tmp/fastboot-cache
	./../../../../out/host/linux-x86/bin/make_ext4fs -s -l 256M -a cache ${cacheimg} /tmp/fastboot-cache/
	rm -rf /tmp/fastboot-cache
fi

#flash cache.img
${FASTBOOT} flash cache 		${cacheimg}

## Fastboot reboot not supported yet
#reboot now
#${FASTBOOT} reboot

if [ $resizefail -eq 1 ]; then
	echo "--------------------------------------------------"
	echo "Attempt was made to resize the userdata partition image"
	echo "to the size available on your SOM. But it failed either"
	echo "because it failed to remove existing ./data folder or because"
	echo "you are not running this script with superuser privileges"
	echo "Don't panic! The script just loaded the original userdata.img"
	echo "so, things should just work as expected. Just that the size"
	echo "of /data will be smaller on target."
	echo ""
	echo "If you really want to resize userdata.img, remove any existing"
	echo "./data folder and run \"sudo ./fastboot.sh\""
	echo "For now, we are defaulting to original userdata.img"
	echo "--------------------------------------------------"
fi

