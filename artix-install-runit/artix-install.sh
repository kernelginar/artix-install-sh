#!/bin/sh
clear

# edit /etc/pacman.conf file
nano /etc/pacman.conf

clear

# disk configuration
lsblk
echo ' '
read -p 'Select disk (Example: vda, sda, nvme0n1): ' disk_selection
cfdisk /dev/$disk_selection

clear
lsblk
echo ' '

# format disk label
read -p 'Root partition (Example: vda1, sda1, nvme0n1p1): ' root_partition
mkfs.ext4 /dev/$root_partition
mount /dev/$root_partition /mnt

read -p 'Boot partition (Example: vda1, sda1, nvme0n1p1): ' boot_partition
mkfs.fat -F32 /dev/$boot_partition
mkdir -p /mnt/boot/efi

clear

# install base packages
basestrap -i /mnt base base-devel linux linux-headers linux-firmware runit git nano

# create fstab file
fstabgen -U /mnt > /mnt/etc/fstab
mount /dev/$boot_partition /mnt/boot/efi

cp $(pwd)/chroot.sh /mnt
artix-chroot /mnt /bin/bash
rm -rf /mnt/chroot.sh
