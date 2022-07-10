#!/bin/bash

#################################################################################
########################    Install Roblox FPS Unlocker    ######################
#################################################################################

fps_unlocker()
{

RFPSU="rbxfpsunlocker_v4.4.2.tar.xz"
if [ ! -f "$HOME/.wine-roblox-malik/$RFPSU" ];
then
read -p "Do you want to install FPS Unlocker (y/n)?"
	if [[ $REPLY =~ ^[Yy]$ ]]
	then
	
	for i in {1..5}
	do
		
		if [ $i == 5 ];
		then 
			echo "error: failed to download $RFPSU"
			exit
		fi
			cd "$HOME/.wine-roblox-malik"
			if [ ! -f "$HOME/.wine-roblox-malik/$RFPSU" ];
			then
			wget --no-check-certificate "https://onedrive.live.com/download?cid=CFF1642CDA1859A3&resid=CFF1642CDA1859A3%21657&authkey=AESf097-NBSK_bE" -O "$HOME/.wine-roblox-malik/$RFPSU"
			fi

			if md5sum "$HOME/.wine-roblox-malik/$RFPSU" | grep -i d7d7c8d3a6754c4d3434620fbe052160 > /dev/null;
		then 
			tar -xf "$HOME/.wine-roblox-malik/$RFPSU"
			break
		else 
			rm "$HOME/.wine-roblox-malik/$RFPSU"
		fi
	done
	fi
fi
if [ -f "$HOME/.wine-roblox-malik/rbxfpsunlocker.exe" ];
then
FPS="&& if ! pgrep rbxfpsunlocker > /dev/null; then \\\"$HOME/.wine-roblox-malik/$WINE_NAME/bin/wine\\\" \\\"$HOME/.wine-roblox-malik/rbxfpsunlocker.exe\\\"; fi"
fi

}

#################################################################################
########################      FULL_SETUP    #####################################
#################################################################################

full_setup ()
{

# install "lib32-gnutls" if missing.
if [ $distro_guess = "Arch" ] && ! $distro_check lib32-gnutls > /dev/null ;
then
  	 sudo $distro_install lib32-gnutls;
fi

# install "lib32-alsa-plugins" if missing.
if [ $distro_guess = "Arch" ] && ! $distro_check lib32-alsa-plugins > /dev/null ;
then
  	 sudo $distro_install lib32-alsa-plugins;
fi

# install "lib32-libpulse" if missing.
if [ $distro_guess = "Arch" ] && ! $distro_check lib32-libpulse > /dev/null ;
then
  	 sudo $distro_install lib32-libpulse;
fi

# install "lib32-openal" if missing.
if [ $distro_guess = "Arch" ] && ! $distro_check lib32-openal > /dev/null ;
then
  	 sudo $distro_install lib32-openal;
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
if [ -f "$HOME/.config/mimeapps.list" ];
then
	sed -i '/roblox/d' "$HOME/.config/mimeapps.list"
fi

# add my roblox launcher to xdg list.
xdg-mime default "roblox-malik.desktop" x-scheme-handler/roblox-player

# make custom directory if missing
if [ ! -d "$HOME/.wine-roblox-malik" ];
then
	cd "$HOME/"
	mkdir .wine-roblox-malik
fi

# set custom directory as default for wine to use
export WINEPREFIX="$HOME/.wine-roblox-malik"
export WINEDEBUG=-all

# download and extract custom wine if missing.
if [ ! -d "$HOME/.wine-roblox-malik/$WINE_NAME" ];
then
	for i in {1..5}
	do

		if [ $i == 5 ];
		then 
			echo "error: failed to download $WINE_NAME.tar.xz"
			exit
		fi

		cd "$HOME/.wine-roblox-malik"
		if [ ! -f "$HOME/.wine-roblox-malik/$WINE_NAME.tar.xz" ];
		then
			wget --no-check-certificate $WINE_URL -O $WINE_NAME.tar.xz
		fi
	
		if md5sum "$HOME/.wine-roblox-malik/$WINE_NAME.tar.xz" | grep -i $WINE_MD5 > /dev/null;
		then 
			tar -xf "$HOME/.wine-roblox-malik/$WINE_NAME.tar.xz"
			break
		else 
			rm "$HOME/.wine-roblox-malik/$WINE_NAME.tar.xz"
		fi
	done
fi

# Download and Install Roblox if missing.
if [ ! -f "$HOME/.wine-roblox-malik/RobloxPlayerLauncher.exe" ];
then
	wget -O "$HOME/.wine-roblox-malik/RobloxPlayerLauncher.exe" https://setup.rbxcdn.com/RobloxPlayerLauncher.exe
	"$HOME/.wine-roblox-malik/$WINE_NAME/bin/wine" "$HOME/.wine-roblox-malik/RobloxPlayerLauncher.exe"
fi

#Install Roblox FPS Unlocker
fps_unlocker

# make desktop entry for roblox launcher.
echo -e "[Desktop Entry]\nVersion=1.0\nName=roblox-malik\nExec=bash -c \"\$(if [ -f \\\"$HOME/.wine-roblox-malik/drive_c/users/$USER/AppData/Local/Roblox/GlobalBasicSettings_13.xml\\\" ]; then sed -i 's/\\\\\\\"Fullscreen\\\\\\\">true</\\\\\\\"Fullscreen\\\\\\\">false</g' \\\"$HOME/.wine-roblox-malik/drive_c/users/$USER/AppData/Local/Roblox/GlobalBasicSettings_13.xml\\\"; fi) && cp -r \\\"$HOME/.wine-roblox-malik/ClientSettings\\\" \\\"\$(find \\\"$HOME/.wine-roblox-malik/drive_c/users/$USER\\\" -name 'RobloxPlayerLauncher.exe' -not -path '*/Temp/*' -exec dirname {} ';' )\\\" && export MESA_GL_VERSION_OVERRIDE=\\\"4.4\\\" && export WINEPREFIX=\\\"$HOME/.wine-roblox-malik\\\" && export WINEESYNC=1 && export WINEFSYNC=1 && \\\"$HOME/.wine-roblox-malik/$WINE_NAME/bin/wine\\\" \\\"\$(find \\\"$HOME/.wine-roblox-malik/drive_c/users/$USER\\\" -name 'RobloxPlayerLauncher.exe' -not -path '*/Temp/*')\\\" %U $FPS\"\nIcon=A67C_RobloxStudioLauncherBeta.0\nMimeType=x-scheme-handler/roblox-player;\nIcon=utilities-terminal\nType=Application\nTerminal=false\n" > "$HOME/.local/share/applications/roblox-malik.desktop"

#set and update fflag settings
PS3="Please select Graphics API (Vulkan Recommended):"
APIs=("Vulkan" "OpenGL" "DirectX11" "DirectX9")
select fav in "${APIs[@]}"; do
    case $fav in
"Vulkan")
api="{\"FFlagDebugGraphicsPreferVulkan\": true }"
break
;;
"OpenGL")
api="{\"FFlagDebugGraphicsPreferOpenGL\": true, \"FFlagGraphicsGLUseDefaultVAO\": true }"
break
;;
"DirectX11")
api="{\"FFlagDebugGraphicsPreferD3D11\": true }"
break
;;
"DirectX9")
api="{\"FFlagDebugGraphicsPreferD3D9\": true }"
break
;;
*) echo "Invalid selection $REPLY. Valid selections are 1, 2, 3 and 4.";;
esac
done

if [ ! -d "$HOME/.wine-roblox-malik/ClientSettings" ]; then mkdir "$HOME/.wine-roblox-malik/ClientSettings"; fi

echo -e "$api" > "$HOME/.wine-roblox-malik/ClientSettings/ClientAppSettings.json"


# Install or uninstall DXVK
if [ $REPLY == "3" ] || [ $REPLY == "4" ];
then
DXVK="dxvk-1.9.4.tar.gz"
DXVK_FOLDER="dxvk-1.9.4"
	wineserver -k
	if [ -f "$HOME/.wine-roblox-malik/dosdevices/c:/windows/syswow64/d3d11.dll.old" ];
	then
		read -p "Do you want to uninstall DXVK (y/n)?"
		if [[ $REPLY =~ ^[Yy]$ ]]
		then
		
		for i in {1..5}
		do
	
			if [ $i == 5 ];
			then 
				echo "error: failed to download $DXVK"
				exit
			fi
	
			cd "$HOME/.wine-roblox-malik"
			if [ ! -f "$HOME/.wine-roblox-malik/$DXVK" ];
			then
				wget --no-check-certificate "https://github.com/doitsujin/dxvk/releases/download/v1.9.4/dxvk-1.9.4.tar.gz" -O $DXVK
			fi
		
			if md5sum "$HOME/.wine-roblox-malik/$DXVK" | grep -i fcac4bcce02f8fc1e2d93a3f0b788757 > /dev/null;
			then 
				tar -xf "$HOME/.wine-roblox-malik/$DXVK"
				break
			else 
				rm "$HOME/.wine-roblox-malik/$DXVK"
			fi
		done
		
		 bash "$HOME/.wine-roblox-malik/$DXVK_FOLDER/setup_dxvk.sh" uninstall
		else
		 echo "Skipping DXVK!"
		fi
	else
		read -p "Do you want to install DXVK (y/n)?"
		if [[ $REPLY =~ ^[Yy]$ ]]
		then
		for i in {1..5}
		do
	
			if [ $i == 5 ];
			then 
				echo "error: failed to download $DXVK"
				exit
			fi
	
			cd "$HOME/.wine-roblox-malik"
			if [ ! -f "$HOME/.wine-roblox-malik/$DXVK" ];
			then
				wget --no-check-certificate "https://github.com/doitsujin/dxvk/releases/download/v1.9.4/dxvk-1.9.4.tar.gz" -O $DXVK
			fi
		
			if md5sum "$HOME/.wine-roblox-malik/$DXVK" | grep -i fcac4bcce02f8fc1e2d93a3f0b788757 > /dev/null;
			then 
				tar -xf "$HOME/.wine-roblox-malik/$DXVK"
				break
			else 
				rm "$HOME/.wine-roblox-malik/$DXVK"
			fi
		done
		 bash "$HOME/.wine-roblox-malik/$DXVK_FOLDER/setup_dxvk.sh" install
		else
		 echo "Skipping DXVK!"
		fi
	fi
fi

echo " " 
# let user know their system has just been pimped :)
echo "Setup complete remember to reset browser settings to default settings if there is no option to open with roblox-malik . . ."
exit

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

which zypper >/dev/null 2>&1
if [ $? -eq 0 ]
then
distro_guess="OpenSUSE"
distro_check="zypper search -i"
distro_install="zypper install"
fi

which pacman >/dev/null 2>&1
if [ $? -eq 0 ]
then
distro_guess="Arch"
distro_check="pacman -Qs"
distro_install="pacman -S"
fi

if test -z $distro_guess;
then
echo "This Linux distro is not supported sorry. Now aborting."
exit
fi

#confirm system glibc version then download corresponding wine
if ldd --version | grep "2.27" > /dev/null ||  ldd --version | grep "2.28" > /dev/null ||  ldd --version | grep "2.29" > /dev/null ||  ldd --version | grep "2.30" > /dev/null;
then
echo "Older version of glibc found using unstable version of wine!";
WINE_NAME="wine-6.16-roblox-amd64"
WINE_URL="https://onedrive.live.com/download?cid=CFF1642CDA1859A3&resid=CFF1642CDA1859A3%21643&authkey=AOc5rRwJnmud8Hw"
WINE_MD5="ab1ee10d71c94ec7c1d5fb9d2952051b"
else
WINE_NAME="wine-tkg-staging-fsync-git-7.1.r0.gf5ca8f5a"
WINE_URL="https://onedrive.live.com/download?cid=CFF1642CDA1859A3&resid=CFF1642CDA1859A3%21649&authkey=AKEUgV25AUczKDw"
WINE_MD5="dcabd1e95bbb84e19afe7636165524c7"
fi

PS3="Please make a selection:"
distros=("Install Roblox" "Install Roblox Studio" "Uninstall Roblox" "Exit")
select fav in "${distros[@]}"; do
    case $fav in

#################################################################################
########################      Install Roblox        #############################
#################################################################################

        "Install Roblox")

full_setup

		exit
		;;


#################################################################################
########################      Install Roblox Studio        ######################
#################################################################################
	    
	    "Install Roblox Studio")
	    
#check if Roblox installed  
if [ ! -f "$HOME/.wine-roblox-malik/drive_c/users/$USER/AppData/Local/Roblox/Versions/RobloxStudioLauncherBeta.exe" ];
then
	echo "Roblox installation missing install Roblox first!"
	exit
fi

#Install Roblox FPS Unlocker
fps_unlocker

# add my roblox studio launcher to xdg list.
xdg-mime default "roblox-studio-malik.desktop" x-scheme-handler/roblox-studio
xdg-mime default "roblox-studio-malik.desktop" application/x-roblox-rbxl
xdg-mime default "roblox-studio-malik.desktop" application/x-roblox-rbxlx

#create desktop entry for studio
echo -e "[Desktop Entry]\nName=Roblox-Studio-Malik\nExec=xdg-open https://www.roblox.com/login/return-to-studio\nIcon=A67C_RobloxStudioLauncherBeta.0\nTerminal=false\nType=Application\nName[en_GB]=Roblox-Studio-Malik" > "$HOME/Desktop/Roblox Studio Malik.desktop"

chmod +x "$HOME/Desktop/Roblox Studio Malik.desktop"

#create studio desktop file for xdg-open
echo -e "[Desktop Entry]\nVersion=1.0\nName=roblox-studio-malik\nExec=bash -c \"export WINEPREFIX=\\\"$HOME/.wine-roblox-malik/studio-malik\\\" && export WINEESYNC=1 && export WINEFSYNC=1 && \\\"$HOME/.wine-roblox-malik/$WINE_NAME/bin/wine\\\" \\\"\$(find \\\"$HOME/.wine-roblox-malik/studio-malik/drive_c/users/$USER/AppData/Local/Roblox/Versions\\\" -name 'RobloxStudioLauncherBeta.exe' -not -path '*/Temp/*')\\\" %U $FPS\"\nIcon=A67C_RobloxStudioLauncherBeta.0\nMimeType=x-scheme-handler/roblox-studio;application/x-roblox-rbxl;application/x-roblox-rbxlx\nIcon=utilities-terminal\nType=Application\nTerminal=false\n" > "$HOME/.local/share/applications/roblox-studio-malik.desktop"

#install studio
WINEPREFIX="$HOME/.wine-roblox-malik/studio-malik" WINEDEBUG=-all WINEESYNC=1 WINEFSYNC=1 "$HOME/.wine-roblox-malik/$WINE_NAME/bin/wine" "$HOME/.wine-roblox-malik/drive_c/users/$USER/AppData/Local/Roblox/Versions/RobloxStudioLauncherBeta.exe"

sleep 10

read -p "$(echo -e "\\nComplete Roblox Studio installer when complete let Studio open then close it and press Return key to continue . . . \\n \\n ")"

#update api to vulkan	
sed -i 's/"FFlagDebugGraphicsPreferVulkan":false/"FFlagDebugGraphicsPreferVulkan":true/g' "$HOME/.wine-roblox-malik/studio-malik/drive_c/users/$USER/AppData/Local/Roblox/ClientSettings/StudioAppSettings.json"

#open studio login page with default web browser
xdg-open https://www.roblox.com/login/return-to-studio

	exit
	    ;;

#################################################################################
########################      Uninstall Roblox        ###########################
#################################################################################

        "Uninstall Roblox")
        
if [ -d "$HOME/.wine-roblox-malik" ];
then
	rm -rf "$HOME/.wine-roblox-malik"
fi

if [ -f "$HOME/.local/share/applications/roblox-malik.desktop" ];
then
	rm "$HOME/.local/share/applications/roblox-malik.desktop"
fi

if [ -f "$HOME/.local/share/applications/roblox-studio-malik.desktop" ];
then
	rm "$HOME/.local/share/applications/roblox-studio-malik.desktop"
fi

if [ -f "$HOME/Desktop/Roblox Studio Malik.desktop" ];
then
	rm "$HOME/Desktop/Roblox Studio Malik.desktop"
fi

if [ -f "$HOME/.config/mimeapps.list" ];
then
	sed -i '/roblox/d' "$HOME/.config/mimeapps.list"
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










