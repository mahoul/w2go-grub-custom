# w2go-grub-custom

## Description

Simple script to install custom.cfg and dependecies to boot a _Windows To Go_
USB drive.

## Installation

Lazy and ugly method

```sh
$ sudo bash ./install-w2go-custom.sh
++ get_grub2_cfgfile
+++ lsb_release -s -i
++ local dist_id=Fedora
++ case $dist_id in
++ grub2_bios_file=/etc/grub2.cfg
++ grub2_efi_file=/etc/grub2-efi.cfg
++ '[' -e /etc/grub2.cfg ']'
++ '[' -e /etc/grub2-efi.cfg ']'
++ readlink -f /etc/grub2-efi.cfg
+ GRUB2_CFG_FILE=/boot/efi/EFI/fedora/grub.cfg
++ dirname /boot/efi/EFI/fedora/grub.cfg
+ GRUB2_CFG_PATH=/boot/efi/EFI/fedora
+ install_required_pkgs
+ echo /boot/efi/EFI/fedora/grub.cfg
+ grep -q efi
+ GRUB2_MODULES_RPM=grub2-efi-x64-modules
+ rpm -q grub2-efi-x64-modules
grub2-efi-x64-modules-2.02-38.fc28.noarch
+ echo /boot/efi/EFI/fedora/grub.cfg
+ grep -q efi
+ GRUB2_ARCH=x86_64-efi
+ grep -q '/boot .*' /etc/mtab
+ echo x86_64-efi
+ grep -q efi
+ grep -q '/boot/efi .*' /etc/mtab
+ '[' '!' -d /boot/efi/EFI/fedora/x86_64-efi ']'
+ cp -f /usr/lib/grub/x86_64-efi/ntfs.mod /boot/efi/EFI/fedora/x86_64-efi/
+ cp -f custom.cfg /boot/efi/EFI/fedora/
```

## Requirements

- __GRUB2__
- Running __install-w2go-custom.sh__ script as __root__.

## TO-DO

Only tested on Fedora, may require minor changes to work on other distros.
