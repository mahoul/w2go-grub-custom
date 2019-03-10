#!/bin/bash

LOG_FILE="/tmp/$(basename ${0%.sh}.log)"                                                                                                                                                      
                                                                                                                                                                                              
(                                                                                                                                                                                             
                                                                                                                                                                                              
set -x                                                                       

die(){
	echo -e "$1"
	exit $2
}

# Install required packages
#
install_required_pkgs(){
	if echo $GRUB2_CFG_FILE | grep -q efi; then
		GRUB2_MODULES_RPM=grub2-efi-x64-modules
	else
		GRUB2_MODULES_RPM=grub2-pc-modules
	fi 
	if ! rpm -q $GRUB2_MODULES_RPM; then
		yum install -y $GRUB2_MODULES_RPM
	fi
}

# Get GRUB2 config file from symlinks in /etc
#
get_grub2_cfgfile(){
	local dist_id=$(lsb_release -s -i)

	case $dist_id in
		Fedora)
			grub2_bios_file=/etc/grub2.cfg
			grub2_efi_file=/etc/grub2-efi.cfg
			;;
		*)
			;;
	esac

	if [ -e $grub2_bios_file ] ; then
		readlink -f $grub2_cfg_file
	elif [ -e $grub2_efi_file ]; then
		readlink -f $grub2_efi_file
	fi
}

GRUB2_CFG_FILE=$(get_grub2_cfgfile)
GRUB2_CFG_PATH=$(dirname $GRUB2_CFG_FILE)

# Check if required packages are installed and install them if not.
#
if ! install_required_pkgs; then
	die "Could not install required packages. Check $LOG_FILE" 1
fi

# Get GRUB2 arch from GRUB2 config file
#
if echo $GRUB2_CFG_FILE | grep -q efi; then
	GRUB2_ARCH=x86_64-efi
else
	GRUB2_ARCH=i386-pc
fi

# Check if /boot is mounted
#
if ! grep -q "/boot .*" /etc/mtab ; then
	die "/boot partition is not mounted. Quitting." 2
fi

# Check if /boot/efi is mounted
#
if echo $GRUB2_ARCH | grep -q efi; then
	if ! grep -q "/boot/efi .*" /etc/mtab ; then
		die "/boot/efi partition is not mounted. Quitting." 3
	fi
fi

# Check if modules dir exists and create it if not
#
if [ ! -d $GRUB2_CFG_PATH/$GRUB2_ARCH ]; then
       	mkdir $GRUB2_CFG_PATH/$GRUB2_ARCH
fi

# Copy ntfs GRUB2 module to $GRUB2_CFG_PATH/$GRUB2_ARCH
#
cp -f /usr/lib/grub/$GRUB2_ARCH/ntfs.mod $GRUB2_CFG_PATH/$GRUB2_ARCH/

# Copy custom.cfg to $GRUB2_CFG_PATH/
#
cp -f custom.cfg $GRUB2_CFG_PATH/

) 2>&1 | tee -a $LOG_FILE

