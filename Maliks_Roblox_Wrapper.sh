#!/bin/bash

#################################################################################
########################      FULL_SETUP    #####################################
#################################################################################

full_setup () {

# install "lib32-gnutls" if missing.
if [ $distro_guess = "Arch" ] && ! $distro_check lib32-gnutls > /dev/null ;
then
  	 sudo $distro_install lib32-gnutls;
fi

# install "xdg-utils" if missing.
if ! $distro_check xdg-utils > /dev/null ;
then
  sudo $distro_install xdg-utils;
fi

# install "git" if missing.
if ! $distro_check git > /dev/null ;
then
  sudo $distro_install git;
fi

# install "wine" if missing.
if ! $distro_check wine > /dev/null ;
then
  sudo $distro_install wine;
fi

# install "wget" if missing.
if ! $distro_check wget > /dev/null ;
then
  sudo $distro_install wget;
fi

# install "curl" if missing.
if ! $distro_check curl > /dev/null ;
then
  sudo $distro_install curl;
fi

# remove any other roblox launchers.
if [ -f ~/.config/mimeapps.list ];
then
	sed -i '/roblox/d' ~/.config/mimeapps.list
fi

# add my roblox launcher to xdg list.
xdg-mime default "roblox-malik.desktop" x-scheme-handler/roblox-player

# make custom directory if missing
if [ ! -d ~/.wine-roblox-malik ];
then
	cd ~/
	mkdir .wine-roblox-malik
fi

# set custom directory as default for wine to use
export WINEPREFIX=~/.wine-roblox-malik
export WINEDEBUG=-all

# download and extract custom wine if missing.
if [ ! -d ~/.wine-roblox-malik/$WINE_NAME ];
then
	for i in {1..5}
	do

		if [ $i == 5 ];
		then 
			echo "error: failed to download $WINE_NAME.tar.xz"
			exit
		fi

		cd ~/.wine-roblox-malik
		if [ ! -f ~/.wine-roblox-malik/$WINE_NAME.tar.xz ];
		then
			wget --no-check-certificate $WINE_URL -O $WINE_NAME.tar.xz
		fi
	
		if md5sum ~/.wine-roblox-malik/$WINE_NAME.tar.xz | grep -i $WINE_MD5 > /dev/null;
		then 
			tar -xf ~/.wine-roblox-malik/$WINE_NAME.tar.xz
			break
		else 
			rm ~/.wine-roblox-malik/$WINE_NAME.tar.xz
		fi
	done
fi

# Download and Install Roblox if missing.
if [ ! -f ~/.wine-roblox-malik/RobloxPlayerLauncher.exe ];
then
	wget -O ~/.wine-roblox-malik/RobloxPlayerLauncher.exe https://setup.rbxcdn.com/RobloxPlayerLauncher.exe
	~/.wine-roblox-malik/$WINE_NAME/bin/wine64 ~/.wine-roblox-malik/RobloxPlayerLauncher.exe
	read -p "Complete Roblox installer then press Return key to continue . . ."
fi

#Install Roblox FPS Unlocker
if [ ! -f ~/.wine-roblox-malik/rbxfpsunlocker.tar.xz ];
then
read -p "Do you want to install FPS Unlocker (y/n)?"
	if [[ $REPLY =~ ^[Yy]$ ]]
	then
	for i in {1..5}
	do

		if [ $i == 5 ];
		then 
			echo "error: failed to download rbxfpsunlocker.tar.xz"
			exit
		fi
			cd ~/.wine-roblox-malik
			if [ ! -f ~/.wine-roblox-malik/rbxfpsunlocker.tar.xz ];
			then
			wget --no-check-certificate "https://onedrive.live.com/download?cid=CFF1642CDA1859A3&resid=CFF1642CDA1859A3%21641&authkey=AAAqCn1NU4TVVB8" -O ~/.wine-roblox-malik/rbxfpsunlocker.tar.xz
			fi

			if md5sum ~/.wine-roblox-malik/rbxfpsunlocker.tar.xz | grep -i 577198b1dfb541799ab2f7641dc080d0 > /dev/null;
		then 
			tar -xf ~/.wine-roblox-malik/rbxfpsunlocker.tar.xz
			break
		else 
			rm ~/.wine-roblox-malik/rbxfpsunlocker.tar.xz
		fi
	done
	fi
fi
if [ -f ~/.wine-roblox-malik/rbxfpsunlocker.exe ];
then
FPS="&& if ! pgrep rbxfpsunlocker > /dev/null; then \"~/.wine-roblox-malik/$WINE_NAME/bin/wine\" \"~/.wine-roblox-malik/rbxfpsunlocker.exe\"; fi"
fi



# make desktop entry for roblox launcher.
echo -e "[Desktop Entry]\nVersion=1.0\nName=roblox-malik\nExec=bash -c \"export WINEPREFIX=~/.wine-roblox-malik && export WINEESYNC=1 && export WINEFSYNC=1 && \"~/.wine-roblox-malik/$WINE_NAME/bin/wine\" \\\"\$(find ~/'.wine-roblox-malik/drive_c/users/'$USER -name 'RobloxPlayerLauncher.exe' -not -path '*/Temp/*')\\\" %U $FPS\"\nIcon=A67C_RobloxStudioLauncherBeta.0\nMimeType=x-scheme-handler/roblox-player;\nIcon=utilities-terminal\nType=Application\nTerminal=false\n" > ~/.local/share/applications/roblox-malik.desktop

#set and update fflag settings
PS3="Please select Graphics API (Vulkan Recommended):"
APIs=("Vulkan" "OpenGL" "DirectX11" "DirectX9")
select fav in "${APIs[@]}"; do
    case $fav in
"Vulkan")
api="{\"FFlagDebugGraphicsPreferVulkan\": true, \"DFFlagClientVisualEffectRemote\": false}"
break
;;
"OpenGL")
api="{\"FFlagDebugGraphicsPreferOpenGL\": true, \"DFFlagClientVisualEffectRemote\": false}"
break
;;
"DirectX11")
api="{\"FFlagDebugGraphicsPreferVulkan\": true, \"DFFlagClientVisualEffectRemote\": false}"
break
;;
"DirectX9")
api="{\"FFlagDebugGraphicsPreferD3D9\": true, \"DFFlagClientVisualEffectRemote\": false}"
break
;;
*) echo "Invalid selection $REPLY. Valid selections are 1, 2, 3 and 4.";;
esac
done

if [ ! -d ~/.wine-roblox-malik/ClientSettings ]; then mkdir ~/.wine-roblox-malik/ClientSettings; fi

echo -e "$api" > ~/.wine-roblox-malik/ClientSettings/ClientAppSettings.json

cp -r ~/.wine-roblox-malik/ClientSettings "$(find ~/'.wine-roblox-malik/drive_c/users/'$USER -name 'RobloxPlayerLauncher.exe' -not -path '*/Temp/*' -exec dirname {} \;)"
exit

echo " " 
# let user know their system has just been pimped :)
echo "Setup complete remember to reset browser settings to default if no option to open with roblox-malik . . ."

}


#################################################################################
########################      SETUP        ######################################
#################################################################################

which apt >/dev/null 2>&1
if [ $? -eq 0 ]
then
distro_guess="Debian"
distro_check="dpkg -l"
distro_install="apt install"
fi

which yum >/dev/null 2>&1
if [ $? -eq 0 ]
then
distro_guess="Fedora"
distro_check="rpm -q"
distro_install="yum install"
fi

which pacman >/dev/null 2>&1
if [ $? -eq 0 ]
then
distro_guess="Arch"
distro_check="pacman -Qs"
distro_install="pacman -S"
fi

which zypper >/dev/null 2>&1
if [ $? -eq 0 ]
then
distro_guess="OpenSUSE"
distro_check="zypper search -i"
distro_install="zypper install"
fi

if test -z $distro_guess;
then
echo "This Linux distro is not supported sorry. Now aborting."
exit
fi

#confirm system wine
if ldd --version | grep "2.27" > /dev/null ||  ldd --version | grep "2.28" > /dev/null ||  ldd --version | grep "2.29" > /dev/null;
then
echo "Older version of glibc found using unstable version of wine!";
WINE_NAME="wine-6.16-roblox-amd64"
WINE_URL="https://onedrive.live.com/download?cid=CFF1642CDA1859A3&resid=CFF1642CDA1859A3%21643&authkey=AOc5rRwJnmud8Hw"
WINE_MD5="ab1ee10d71c94ec7c1d5fb9d2952051b"
else
WINE_NAME="wine-tkg-staging-fsync-git-6.16.r0.g931daeff"
WINE_URL="https://onedrive.live.com/download?cid=CFF1642CDA1859A3&resid=CFF1642CDA1859A3%21628&authkey=AN73mkW13cgxtL8"
WINE_MD5="9f3096fa1928a5b189430df14b34f601"
fi

PS3="Please make a selection:"
distros=("Install Roblox" "Install Roblox Studio" "Uninstall Roblox" "Exit")
select fav in "${distros[@]}"; do
    case $fav in

#################################################################################
########################      Install Roblox        #############################
#################################################################################

        "Install Roblox")

read -p "Roblox setup for $distro_guess Linux. Close all web browsers then press Return key to start . . ."

full_setup

		exit
		;;


#################################################################################
########################      Install Roblox Studio        ######################
#################################################################################
	    
	    "Install Roblox Studio")
	    
#check if Roblox installed  
if [ ! -f ~/".wine-roblox-malik/drive_c/users/$USER/AppData/Local/Roblox/Versions/RobloxStudioLauncherBeta.exe" ];
then
	echo "Roblox installation missing install Roblox first!"
	exit
fi

#Install Roblox FPS Unlocker
if [ ! -f ~/.wine-roblox-malik/rbxfpsunlocker.tar.xz ];
then
read -p "Do you want to install FPS Unlocker (y/n)?"
	if [[ $REPLY =~ ^[Yy]$ ]]
	then
	for i in {1..5}
	do

		if [ $i == 5 ];
		then 
			echo "error: failed to download rbxfpsunlocker.tar.xz"
			exit
		fi
			cd ~/.wine-roblox-malik
			if [ ! -f ~/.wine-roblox-malik/rbxfpsunlocker.tar.xz ];
			then
			wget --no-check-certificate "https://onedrive.live.com/download?cid=CFF1642CDA1859A3&resid=CFF1642CDA1859A3%21641&authkey=AAAqCn1NU4TVVB8" -O ~/.wine-roblox-malik/rbxfpsunlocker.tar.xz
			fi

			if md5sum ~/.wine-roblox-malik/rbxfpsunlocker.tar.xz | grep -i 577198b1dfb541799ab2f7641dc080d0 > /dev/null;
		then 
			tar -xf ~/.wine-roblox-malik/rbxfpsunlocker.tar.xz
			break
		else 
			rm ~/.wine-roblox-malik/rbxfpsunlocker.tar.xz
		fi
	done
	fi
fi
if [ -f ~/.wine-roblox-malik/rbxfpsunlocker.exe ];
then
FPS="&& if ! pgrep rbxfpsunlocker > /dev/null; then \"~/.wine-roblox-malik/$WINE_NAME/bin/wine\" \"~/.wine-roblox-malik/rbxfpsunlocker.exe\"; fi"
fi

#remove other studio launchers
if [ -f ~/.config/mimeapps.list ];
then
	sed -i '/roblox-studio/d' ~/.config/mimeapps.list
fi

# add my roblox studio launcher to xdg list.
xdg-mime default "roblox-studio-malik.desktop" x-scheme-handler/roblox-studio
xdg-mime default "roblox-studio-malik.desktop" application/x-roblox-rbxl
xdg-mime default "roblox-studio-malik.desktop" application/x-roblox-rbxlx

#create desktop entry for studio
echo -e "[Desktop Entry]\nName=Roblox-Studio-Malik\nExec=xdg-open https://www.roblox.com/login/return-to-studio\nIcon=A67C_RobloxStudioLauncherBeta.0\nTerminal=false\nType=Application\nName[en_GB]=Roblox-Studio-Malik" > ~/Desktop/'Roblox Studio Malik.desktop'

#create studio desktop file for xdg-open
echo -e "[Desktop Entry]\nVersion=1.0\nName=roblox-studio-malik\nExec=bash -c \"export WINEPREFIX=~/.wine-roblox-malik/studio-malik && export WINEESYNC=1 && export WINEFSYNC=1 && \"~/.wine-roblox-malik/$WINE_NAME/bin/wine\" \\\"\$(find ~/'.wine-roblox-malik/studio-malik/drive_c/users/'$USER/AppData/Local/Roblox/Versions -name 'RobloxStudioLauncherBeta.exe' -not -path '*/Temp/*')\\\" %U $FPS\"\nIcon=A67C_RobloxStudioLauncherBeta.0\nMimeType=x-scheme-handler/roblox-studio;application/x-roblox-rbxl;application/x-roblox-rbxlx\nIcon=utilities-terminal\nType=Application\nTerminal=false\n" > ~/.local/share/applications/roblox-studio-malik.desktop

#install studio
WINEPREFIX=~/.wine-roblox-malik/studio-malik WINEDEBUG=-all WINEESYNC=1 WINEFSYNC=1 ~/".wine-roblox-malik/$WINE_NAME/bin/wine64" ~/".wine-roblox-malik/drive_c/users/$USER/AppData/Local/Roblox/Versions/RobloxStudioLauncherBeta.exe"

sleep 10

read -p "$(echo -e "\\nComplete Roblox Studio installer when complete let Studio open then close it and press Return key to continue . . . \\n \\n ")"

#update api to vulkan	
sed -i 's/"FFlagDebugGraphicsPreferVulkan":false/"FFlagDebugGraphicsPreferVulkan":true/g' ~/".wine-roblox-malik/studio-malik/drive_c/users/$USER/AppData/Local/Roblox/ClientSettings/StudioAppSettings.json"

#open studio login page with default web browser
xdg-open https://www.roblox.com/login/return-to-studio

	exit
	    ;;

#################################################################################
########################      Uninstall Roblox        #############################
#################################################################################

        "Uninstall Roblox")
        
if [ -d ~/.wine-roblox-malik ];
then
	rm -rf ~/.wine-roblox-malik
fi

if [ -f ~/.local/share/applications/roblox-malik.desktop ];
then
	rm ~/.local/share/applications/roblox-malik.desktop
fi

if [ -f ~/.local/share/applications/roblox-studio-malik.desktop ];
then
	rm ~/.local/share/applications/roblox-studio-malik.desktop
fi

if [ -f ~/Desktop/'Roblox Studio Malik.desktop' ];
then
	rm ~/Desktop/'Roblox Studio Malik.desktop'
fi

if [ -f ~/.config/mimeapps.list ];
then
	sed -i '/-malik/d' ~/.config/mimeapps.list
fi
echo "Uninstall Complete!"
	exit
	    ;;
	"Exit")
	exit
	    ;;
        *) echo "Invalid selection $REPLY. Valid selections are 1,2.3 and 4.";;
    esac
done
exit










