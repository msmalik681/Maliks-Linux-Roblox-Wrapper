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
				#wget --load-cookies /tmp/cookies.txt "https://docs.google.com/uc?export=download&confirm=$(wget --quiet --save-cookies /tmp/cookies.txt --keep-session-cookies --no-check-certificate $DL_URL -O- | sed -rn 's/.*confirm=([0-9A-Za-z_]+).*/\1\n/p')&id=FILEID" -O $DL_PATH && rm -rf /tmp/cookies.txt
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
export DL_PATH="$HOMEDIR/roblox-malik.tar.gz"
if [ ! -f $DL_PATH ];
then
	for i in {1..5}
	do
		if [ $i == 5 ]; # tried 5 times now give up!
		then 
		echo -e "${RED} error: failed to download roblox-malik.tar.gz now aboting ${RESET}"
		exit
		fi
		echo -e "${RED} Downloading program files around 4GB so this could take some time please wait. ${RESET}"
		wget --header="Host: drive.usercontent.google.com" --header="User-Agent: Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/126.0.0.0 Safari/537.36" --header="Accept: text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.7" --header="Accept-Language: en-GB,en-US;q=0.9,en;q=0.8" --header="Cookie: AEC=AVYB7cr1IoqzWl4_jGHS2-mRLVmyVPMquvZumXkeqKKKa-Qu3fbjpnZ6VtU; SOCS=CAESHAgCEhJnd3NfMjAyNDA3MTAtMF9SQzEaAmVuIAEaBgiAzdG0Bg; NID=516=FAWJXEZY8I8avOllbjCZEa6lEzPx0oeDhEWO_G3q0VRZF_-sW4cU9IPTLUUryejA-6WXblzCXxMPxdjt5Y1BWlzpGAoT0dkLVmjKbgkpRd3oN66W7_jHDMY86LilHBAIeWcR3MgXHb1de0Y5EJyD7bHk3rmNimyXegHBRgDoosbmweBKR0OBKSCvDN8Gx3d_IegxbVbcavZt5tNG5tlTebl1EwuCGOU3CduyvMKewHnRplKfeEk-7ci9KTi7Qtat_PksGOCZhPf1Erg3KoT6xkJ3LACzxpv_4yzyY9CBwdFLNtPL3aWjkaiGSYOcW3iT0UlfKwqjbLQcwncP1DscilDvIEPSUBgoc-oIkMoJ3twFhiPXEZbVbdwWBd0POxM7EZJOoK-PJjbEmrZDXHyW59pEuZq0o2BCFvGm-3w8v4K-uRSutdqstSF0M4FS8YI-IlOQAI1FUPMqNfs9ffWAtWf_ZVe5qIXCc61h6_3tGacpB1OVf27pRcUEb7dTfAtVH_r2AtRzXMlTrgEOTUpGjr2JyzE2gcEex-1KJtn539jCdgjJKvnhY4iD67eXgnN7pcw3aptSXfPYrr_nNCgefM5p90MDyZ6D-cmb1htxGnvW33Qlv_l7IGv9jejvJmHYKiiEO-x_4j0lly_DMM8mswN8gB-VypnGliV5muv4FEyIQ3ZN-PU47X5K8-Y; SID=g.a000mghSN3ZIVxLNGMK9HUj80mIK9d4iZk20hs9UknswnkI9JuPWzhdm5rFfHB_-gpPI_3cnrQACgYKAY0SARUSFQHGX2MinzAybseuweJP09m4qPmdYhoVAUF8yKpnG3hXIEBVoHxK8ZxbxYBh0076; __Secure-1PSID=g.a000mghSN3ZIVxLNGMK9HUj80mIK9d4iZk20hs9UknswnkI9JuPWG0ZRPCbhz7i0fVEryltWewACgYKAYwSARUSFQHGX2Miy-gPu3EaqJJXAqKlW1QV5hoVAUF8yKrGBkCitCER3OToa9rZLxfM0076; __Secure-3PSID=g.a000mghSN3ZIVxLNGMK9HUj80mIK9d4iZk20hs9UknswnkI9JuPWgISg4snPrpD06dQullAiKAACgYKAdISARUSFQHGX2MiQmwk00f0A_tNNos2r0OJpxoVAUF8yKqW_3ZLYbm3hHM3nFzzQrdN0076; HSID=AE1JFxiBPvybMyE8o; SSID=AeWdqXpzIJEURiWNG; APISID=ibCd_h9vp04Q5iSw/A4hTCWqyEmmOib2K2; SAPISID=3b7_WXoa0KG2rYbH/ATZ-hghCpTASd-DPu; __Secure-1PAPISID=3b7_WXoa0KG2rYbH/ATZ-hghCpTASd-DPu; __Secure-3PAPISID=3b7_WXoa0KG2rYbH/ATZ-hghCpTASd-DPu; __Secure-ENID=21.SE=ZMT256RXaOJcmupf5wuuf4IQOd8HgKQtm7wSRoA60-GO3o3jmxQZyRIIrSNPfbScFtNpsUJbVdf4liI1-IUuxPhVYmfC5M-Ye6OSCs3-7iBeh5oWF8qZV19lAHV7hJZrWWa95xwQ7cqSYcAlA_P5XczZISIq6WazAGig-_hit9tr3V90Qfn7zX1yHdaMNHmfd4Vdyu5dk2SO2M9PTQ5HUOHF8AoeIzb6o0bFvcKv5OiVxIfZif7ddx1YNJcDobHOto6hQbeCejmQ8uCKgRp1gNR33nSJcqEObxZ77A; __Secure-1PSIDTS=sidts-CjIB4E2dkQhMZduK9hNtFIuP6vqtjpuIml2OLqGA7reQSxu00u1Bk8xKbbXBSE7XX609VBAA; __Secure-3PSIDTS=sidts-CjIB4E2dkQhMZduK9hNtFIuP6vqtjpuIml2OLqGA7reQSxu00u1Bk8xKbbXBSE7XX609VBAA; SIDCC=AKEyXzWayW1PUF2Dxt6VbKsnq0pPBIzsvGa082mXuompQ1xltExGdbWKcM4c3iTbFNtx48Qj; __Secure-1PSIDCC=AKEyXzUhH6IJTQns1Qv0h5ErHibV3ZWWQ7sRKFZCKW2t1k38gtTWwpHLohYPvGkR0t7kUihYmA; __Secure-3PSIDCC=AKEyXzUBvYi8vvCIvDf-vYXiibAXW02MqHyznj__otHvdPehJc8WIAuNwCe_3WAZBt1fZm_exw" --header="Connection: keep-alive" "https://drive.usercontent.google.com/download?id=1a4nnEF4_FZ8NQ9gSWs1ktnqKMRtKe6_N&export=download&authuser=0&confirm=t&uuid=9074540c-57a2-49f0-b0bb-b62a7b57da46&at=APZUnTVe9cpkDTnzlC32rRIz33ld:1722764657275" -c -O $DL_PATH
		if md5sum $DL_PATH | grep -i "e92496d4aa5d5c92f0ebace1cde26b6e" > /dev/null;
		then 
			echo -e "${GREEN} Downloading complete, now extracting please wait. ${RESET}"
			tar -xf $DL_PATH -C $HOMEDIR
			break
		else 
			rm $DL_PATH
		fi
	done
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

