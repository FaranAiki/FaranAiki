#!/bin/bash

# (C) Copyright 2022 Muhammad Faran Aiki
# No right reserved

# This script offers no warranty
# This script offers bloated softwares

# Can be executed in ../faran-setup.sh

# Do not use this file without precautions or knowledges
# This setup is for Arch Linux distribution that uses SystemD
# This script assumes that you have sudo installed

# First alias
alias yay="yay --removemake --cleanafter --norebuild"
alias pacman="pacman --noconfirm"

# Setting variables
__pacstrap_to=''

# Check programs needed
if ! [ -f /usr/bin/sudo ]
then
	printf "Error: No 'sudo' installed."
	
	printf "Checking if the terminal is already on root."
	if [ ~ = "/root" ]
	then 
		printf "The terminal is already on root."
		printf "Aliasing 'sudo' into ''."
		alias sudo=''
	else
		printf "The terminal is not on root; aborting."
		printf "Try 'su && ./faran-arch.sh' to run on root."
		exit1
	fi
	
fi

if ! [ -f /usr/bin/pacman ]
then
	printf "Error: No 'pacman' installed, checking pacstrap."
	
	if  [ -f /usr/bin/pacstrap ]
	then
		printf "Pacstrap exists, in which/what directory do you want the script to install?"
		read __pacstrap_to
		
		while ! [ -d $__pacstrap_to ]
		do
			printf "Try again, that directory does not exists."
			read __pacstrap_to
		done
		
		printf "Packages now will be installed in '$__pacstrap_to'."
		printf "Aliasing 'pacman' to 'pacstrap'."
		
		alias pacman='pacstrap --noconfirm'
	else
		exit
	fi
fi

# Do not assume safety
sudo chown root /

# Install installers
sudo pacman -S git wget curl pacman-contrib

# Install text editors
sudo pacman -S geany vim vi visudo sed grep awk

# Change the PacMan config
sudo sed "s/#[multilib]/[multilib]/mg" $__pacstrap_to/etc/pacman.conf
sudo sed "s/#Include = \/etc\/pacman.d\/mirrorlist/Include = \/etc\/pacman.d\/mirrorlist/mg" $__pacstrap_to/etc/pacman.conf
printf "File '/etc/pacman.conf' has been modified."

# Install advanced installers
pushd

# Check if home directory exists, root or not
if [ -f ~ ]
then
	mkdir ~/Downloads 2> /dev/null 
	cd ~/Downloads
	git clone https://aur.archlinux.org/yay.git
	cd yay
	makepkg -si
else
	git clone https://aur.archlinux.org/yay.git
	cd yay
	makepkg -si
fi

popd

# Install file systems
sudo pacman -S ntfs-3g

# Install basics
sudo pacman -S xorg wayland gnome gdm libgdm networkmanager iwd

# Install drivers
sudo pacman -S alsa pulseaudio jack jack2-dbus bluez bluez-libs bluez-utils bluez-qt hplip
yay -S CUPS
printf "Download the drivers for printer yourself."

# Install advanced drivers
yay -S b43-firmware

# Install applications
sudo pacman -S krita lmms kdenlive

# Install WINE Is wiNdows Emulator
sudo pacman -S wine wine-staging
sudo pacman -S $(pactree -l wine) $(pactree -l wine-staging)

# Install programming language
sudo pacman julia ghc

# Install side applications
sudo pacman thunar konsole

# Install xf86 videos
sudo pacman -S xf86-video-amdgpu xf86-video-ati xf86-video-intel xf86-video-vesa

# Install fonts
sudo pacman -S noto-fonts-cjk ttf-carlito ttf-dejavu ttf-hack

# Install advanced fonts
yay -S ttf-ubuntu-font-family ttf-ms-fonts ttf-inconsolata

# Install utilities
sudo pacman -S htop radeontop

# Install internet utilities
sudo pacman -S openvpn net-tools pacman wireless_tools gnu-netcat nmap

# Install browsers
yay -S firefox chromium brave

# Install virtual machineys
pacman -S qemu virt-manager virt-viewer dnsmasq vde2 bridge-utils openbsd-netcat libguestfs virtualbox

# Downloading environment resources

# Setting environment resources

# Making things easier
sudo cp $__pacstrap_to/etc/pacman.d/mirrorlist $__pacstrap_to/etc/pacman.d/mirrorlist.backup
sudo awk '/^## Country Name$/{f=1; next}f==0{next}/^$/{exit}{print substr($0, 1);}' $__pacstrap_to/etc/pacman.d/mirrorlist.backup
sudo sed -i 's/^#Server/Server/' $__pacstrap_to/etc/pacman.d/mirrorlist.backup
sudo rankmirrors -n 6 $__pacstrap_to/etc/pacman.d/mirrorlist.backup > $__pacstrap_to/etc/pacman.d/mirrorlist

# Setting WINE
winetricks settings fontsmooth=rgb

# Download 'hacking' tools
sudo pacman -S metasploit

# Download network tools
yay -S aircrack-ng

# Make things faster or more secure
sudo pacman -S thermald

# Remove conflicting SystemD units
sudo airmon-ng check kill

# Controller supports
sudo pacman -S linuxconsole
yay -S xboxdrv

# Systemd configuration
sudo systemctl enable gdm NetworkManager iwd thermald cups libvirtd
sudo systemctl start gdm NetworkManager iwd thermald libvirtd --now

# Modprobing
modprobe uinput vboxdrv

# Rebooting
printf "Script finishes.\n"
printf "You can either reboot or do what you want.\n"
