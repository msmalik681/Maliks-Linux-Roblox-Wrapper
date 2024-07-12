#!/bin/bash

#text colours
GREEN='\033[1;32m'
RED='\033[1;31m'
YELLOW='\033[1;33m'
BLUE='\033[1;34m'
RESET='\033[m'

#sudo apt install -y libepoxy-dev libdrm-dev libgbm-dev libx11-dev libvirglrenderer-dev libpulse-dev libsdl2-dev libgtk-3-dev qemu-utils

#check if user needs adding to groups
if ! grep '^kvm:.*$' /etc/group | cut -d: -f4 | grep $USER > /dev/null || ! grep '^libvirt:.*$' /etc/group | cut -d: -f4 | grep $USER > /dev/null || ! grep '^render:.*$' /etc/group | cut -d: -f4 | grep $USER > /dev/null;
then
echo -e "${YELLOW} updating group settings. ${RESET}"
sudo usermod -aG kvm,libvirt,render $USER
fi

#set custom home directory
HOMEDIR="$HOME/.local/share/roblox-malik"

# make custom directory if missing
if [ ! -d $HOMEDIR ];
then
	mkdir $HOMEDIR
fi


# function to try to download files
downloader()
{
	DL_NAME=$1
	DL_PATH=$2
	DL_URL=$3
	DL_MD5=$4

	for i in {1..5}
		do
	
			if [ $i == 5 ]; # tried 5 times now give up!
			then 
				echo -e "${RED} error: failed to download $DL_NAME now aboting ${RESET}"
				exit
			fi
	
			if [ ! -f $DL_PATH ];
			then
				wget --no-check-certificate $DL_URL -O $DL_PATH
			fi
		
			if md5sum $DL_PATH | grep -i $DL_MD5 > /dev/null;
			then 
				cd	$HOMEDIR
				tar -xf $DL_PATH -C $HOMEDIR
				break
			else 
				rm $DL_PATH
			fi
		done
}

#download program files if missing
if [ ! -f "$HOMEDIR/roblox-malik.tar.gz" ];
then
	echo -e "${RED} Downloading program files around 4GB so this could take some time please wait. ${RESET}"
	downloader "roblox-malik.tar.gz" "$HOMEDIR/roblox-malik.tar.gz" "https://api.onedrive.com/v1.0/shares/s!AqNZGNosZPHPhyBly7XkciBh1od_/root/content" e92496d4aa5d5c92f0ebace1cde26b6e
	echo -e "${GREEN} Downloading complete, now extracting please wait. ${RESET}"
fi


cd $HOMEDIR
#run qemu appimage
# qemu-img create -f qcow2 Bliss14.qcow2 20G
gamemoderun ./QEMU-x86_64.AppImage \
qemu-system-x86_64 \
-drive if=pflash,format=raw,readonly=on,file=OVMF_CODE_4M.fd \
-drive if=pflash,format=raw,file=OVMF_VARS_4M.fd \
-boot c \
-machine type=q35,accel=kvm \
-cpu host,topoext \
-smp $(nproc) \
-m 4096M \
-display sdl,gl=on -device virtio-vga-gl \
-device virtio-net,netdev=vmnic -netdev user,id=vmnic \
-usbdevice tablet \
-hda bliss.qcow2
#-cdrom ./Bliss-v16.9.6-x86_64-OFFICIAL-foss-20240603.iso \

