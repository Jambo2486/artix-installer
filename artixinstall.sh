#!/bin/bash

# TODO: partition section of readme needs updating to fit artix method

# Check if root
[ "$EUID" != 0 ] || echo "artix" | exec sudo "$0" "$@"

# Install whiptail
pacman --noconfirm --needed -Sy libnewt

# Set dialogue box size
box_size=
for i in $(stty size)
do
	box_size="$box_size $(($i/3*2))"
done

# Set keyboard layout
whiptail --infobox "Setting keyboard layout..." $box_size
loadkeys en
sed -i -e "s/keymap=\".*\"/keymap=\"uk\"/g" /etc/conf.d/keymaps

# Set locale
whiptail --infobox "Setting language..." $box_size
locale-gen
echo -e "export LANG=\"en_UK.UTF-8\"\nexport LC_COLLATE=\"C\"" >> /etc/locale.conf

# Install base system
whiptail --infobox "Installing base system and utilities..." $box_size
basestrap /mnt base base-devel openrc elogind-openrc > /dev/null 2>&1

# Install Linux kernel
whiptail --infobox "Installing Linux kernel..." $box_size
basestrap /mnt linux linux-firmware > /dev/null 2>&1
fstabgen -U /mnt >> /mnt/etc/fstab
artix-chroot /mnt

# Set timezone
whiptail --infobox "Setting timezone..." $box_size
ln -sf /usr/share/zoneinfo/Europe/London /etc/localtime
hwclock --systohc

# Install bootloader
pacman -S grub os-prober efibootmgr
if [ -d /sys/firmware/efi ]
then
	pacman -S grub os-prober efibootmgr
else
	grub-install --recheck /dev/sda
fi
grub-mkconfig -o /boot/grub/grub.cfg

inputpassword() {
	# Prompt the user for a password
	while true; do
		password=$(whiptail --nocancel --passwordbox "${1:"Enter a password."}" $box_size)
		if [ password==$(whiptail --nocancel --passwordbox "Re-enter the password." $box_size) ]
		then
			break
		else
			whiptail --infobox "The passwords you entered don't match." $box_size
		fi
	done
}

# Get root password and user cridentials
rootpass=$(inputpassword "Enter a password for the root (admin) user.")
username=$(whiptail --nocancel --inputbox "Enter a normal user account name." $box_size)
userpass=$(inputpassword "Enter a password for \"${username}\".")

# Add users
# echo -e "${rootpass}/${rootpass}" | passwd