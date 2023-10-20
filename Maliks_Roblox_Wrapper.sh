#!/bin/bash

#text colours
Green='\033[1;32m'
Red='\033[1;31m'
Yellow='\033[1;33m'
Blue='\033[1;34m'
Reset='\033[m'

# check if cpu supports avx
if ! lscpu | grep avx > /dev/null;
then 
	echo -e "${Red} Warning: Your CPU does not support AVX it may not work with Roblox. Press return to continue.${Reset}"
read -p " "
fi

# check glibc is 2.31 or newer
if ldd --version | grep "2\\.30]\|2\\.2" > /dev/null;
then
	echo -e "${Red} Error: Your system is unsupported. Please update to glibc 2.31 or greater. Press return to continue.${Reset}"
	read -p " "
	exit
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
				echo "error: failed to download $DL_NAME now aboting"
				exit
			fi
	
			if [ ! -f $DL_PATH ];
			then
				wget --no-check-certificate $DL_URL -O $DL_PATH
			fi
		
			if md5sum $DL_PATH | grep -i $DL_MD5 > /dev/null;
			then 
				cd 
				tar -xf $DL_PATH -C "$HOME/.wine-roblox-malik"
				break
			else 
				rm $DL_PATH
			fi
		done
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

# install "unzip" if missing.
if ! $distro_check unzip > /dev/null ;
then
  sudo $distro_install unzip;
fi

# install "unzip" if missing.
if ! $distro_check zenity > /dev/null ;
then
  sudo $distro_install zenity;
fi

# remove any other roblox launchers.
if [ -f "$HOME/.config/mimeapps.list" ];
then
	sed -i '/roblox/d' "$HOME/.config/mimeapps.list"
fi

# remove any other roblox launchers for flatpaks. and install.
if [ -f "$HOME/.local/share/applications/mimeinfo.cache" ];
then
	chmod 777 "$HOME/.local/share/applications/mimeinfo.cache"
	sed -i '/roblox/d' "$HOME/.local/share/applications/mimeinfo.cache"
	echo -e "x-scheme-handler/roblox-player=roblox-malik.desktop" >> "$HOME/.local/share/applications/mimeinfo.cache"
else
	echo -e "[MIME Cache]\nx-scheme-handler/roblox-player=roblox-malik.desktop" > "$HOME/.local/share/applications/mimeinfo.cache"
fi

#make the file read only
chmod 444 "$HOME/.local/share/applications/mimeinfo.cache"

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

# download and extract custom wine if needed.

	if [ ! -d "$HOME/.wine-roblox-malik/$WINE_NAME" ];
	then
		
		downloader $WINE_NAME "$HOME/.wine-roblox-malik/$WINE_NAME.tar.xz" $WINE_URL $WINE_MD5
	fi


# Download and Install Roblox if missing.
if [ ! -f "$HOME/.wine-roblox-malik/RobloxPlayerLauncher.exe" ];
then

	#first lets block edge webview2 install
	mkdir -p "$HOME/.wine-roblox-malik/drive_c/Program Files (x86)/Microsoft"
	chmod 000 "$HOME/.wine-roblox-malik/drive_c/Program Files (x86)/Microsoft"
	#download and install roblox player
	wget -O "$HOME/.wine-roblox-malik/RobloxPlayerLauncher.exe" https://setup.rbxcdn.com/RobloxPlayerLauncher.exe

	$WINE_RUN "$HOME/.wine-roblox-malik/RobloxPlayerLauncher.exe"

	clear
	echo -e "${Yellow}When setup has completed, press return to key to continue.${Reset}"
	read -p " "
	if [ ! -d  "$HOME/.wine-roblox-malik/drive_c/Program Files (x86)/Roblox" ];
		then
		clear
		echo -e "${Red}Error setup failed to install Roblox please uninstall and install again!${Reset}"
		main_menu
	fi
	find $(xdg-user-dir DESKTOP) -name "*Roblox*" -not -name "*Malik*" -name "*.lnk" -delete
	wget https://i.postimg.cc/63pLwnmf/Roblox-Player-Launcher.png -O "$HOME/.wine-roblox-malik/Roblox-Player-Launcher.png"
	wget https://i.postimg.cc/d1NR0DMP/Roblox-Studio-Beta.png -O "$HOME/.wine-roblox-malik/Roblox-Studio-Beta.png"
	echo " "
fi

# make desktop entry for roblox player.
desktop="$HOME/.local/share/applications/roblox-malik.desktop"
echo -e "[Desktop Entry]\nVersion=1.0\nName=roblox-player-malik\nExec=bash -c \" find \\\"$(xdg-user-dir DESKTOP)\\\" -name \\\"*Roblox*\\\" -not -name \\\"*Malik*\\\" -name \\\"*.desktop\\\" -name \\\"*.lnk\\\" -delete  && cp -r \\\"$HOME/.wine-roblox-malik/ClientSettings\\\" \\\"\$(find \\\"$HOME/.wine-roblox-malik/drive_c\\\" -name 'RobloxPlayerLauncher.exe' -not -path '*/Temp/*' -exec dirname {} ';' )\\\" && export MESA_GL_VERSION_OVERRIDE=\\\"4.4\\\" && export WINEPREFIX=\\\"$HOME/.wine-roblox-malik\\\" && export WINEESYNC=1 && export WINEFSYNC=1 && \\\"$WINE_RUN\\\" \\\"\$(find \\\"$HOME/.wine-roblox-malik/drive_c\\\" -name 'RobloxPlayerLauncher.exe' -not -path '*/Temp/*')\\\" %U\"\nType=Application\nIcon=$HOME/.wine-roblox-malik/Roblox-Player-Launcher.png\nTerminal=false\n" > "$desktop"
chmod +x "$desktop"

# make desktop app loader for users who cant load games through the website.
echo -e "[Desktop Entry]\nVersion=1.0\nName=Roblox App Malik\nExec=bash -c \" find \\\"$(xdg-user-dir DESKTOP)\\\" -name \\\"*Roblox*\\\" -not -name \\\"*Malik*\\\" -name \\\"*.desktop\\\" -name \\\"*.lnk\\\" -delete  && cp -r \\\"$HOME/.wine-roblox-malik/ClientSettings\\\" \\\"\$(find \\\"$HOME/.wine-roblox-malik/drive_c\\\" -name 'RobloxPlayerLauncher.exe' -not -path '*/Temp/*' -exec dirname {} ';' )\\\" && export MESA_GL_VERSION_OVERRIDE=\\\"4.4\\\" && export WINEPREFIX=\\\"$HOME/.wine-roblox-malik\\\" && export WINEESYNC=1 && export WINEFSYNC=1 && \\\"$WINE_RUN\\\" \\\"\$(find \\\"$HOME/.wine-roblox-malik/drive_c\\\" -name 'RobloxPlayerLauncher.exe' -not -path '*/Temp/*')\\\" -app\"\nType=Application\nIcon=$HOME/.wine-roblox-malik/Roblox-Player-Launcher.png\nTerminal=false\n" > "$(xdg-user-dir DESKTOP)/Roblox App Malik.desktop"
chmod +x "$(xdg-user-dir DESKTOP)/Roblox App Malik.desktop"

#set and update fflag settings
PS3="Please select Graphics API (OpenGL Recommended):"
APIs=("Vulkan" "OpenGL" "DirectX11")
select fav in "${APIs[@]}"; do
    case $fav in
"Vulkan")
api="{\"FFlagDebugGraphicsPreferVulkan\": true"
break
;;
"OpenGL")
api="{\"FFlagDebugGraphicsPreferOpenGL\": true"
break
;;
"DirectX11")
api="{\"FFlagDebugGraphicsPreferD3D11\": true"
break
;;
*) echo -e "${Red}Invalid selection $REPLY. Valid selections are 1, 2 and 3.${Reset}";;
esac
done

echo ""

read -p "Do you want boost FPS (y/n)?"
if [[ $REPLY =~ ^[Yy]$ ]]
then
	api="$api, \"FFlagGraphicsGLTextureReduction\": true"
fi

echo ""

read -p "Do you want to unlock FPS (y/n)?"
if [[ $REPLY =~ ^[Yy]$ ]]
then
	api="$api, \"DFIntTaskSchedulerTargetFps\": 300"
fi


if [ ! -d "$HOME/.wine-roblox-malik/ClientSettings" ]; then mkdir "$HOME/.wine-roblox-malik/ClientSettings"; fi

echo -e "$api}" > "$HOME/.wine-roblox-malik/ClientSettings/ClientAppSettings.json"

wineserver -k

# Install or uninstall DXVK
if [ $REPLY == "3" ] || [ $REPLY == "4" ];
then

DXVK="dxvk-1.10.3"

	if [ -f "$HOME/.wine-roblox-malik/dosdevices/c:/windows/syswow64/d3d11.dll.old" ];
	then
		read -p "Do you want to uninstall DXVK (y/n)?"
		if [[ $REPLY =~ ^[Yy]$ ]]
		then
		
		if [ ! -f "$HOME/.wine-roblox-malik/$DXVK/setup_dxvk.sh" ];
		then
		downloader $DXVK "$HOME/.wine-roblox-malik/$DXVK.tar.gz" "https://github.com/doitsujin/dxvk/releases/download/v1.10.3/dxvk-1.10.3.tar.gz" 1c07b9d70ecc5df6c3ba9d13efaa351e
		fi		
		bash "$HOME/.wine-roblox-malik/$DXVK/setup_dxvk.sh" uninstall
		else
		 echo "Skipping DXVK!"
		fi
	else
		read -p "Do you want to install DXVK (y/n)?"
		if [[ $REPLY =~ ^[Yy]$ ]]
		then
			if [ ! -f "$HOME/.wine-roblox-malik/$DXVK/setup_dxvk.sh" ];
			then
			downloader $DXVK "$HOME/.wine-roblox-malik/$DXVK.tar.gz" "https://github.com/doitsujin/dxvk/releases/download/v1.10.3/dxvk-1.10.3.tar.gz" 1c07b9d70ecc5df6c3ba9d13efaa351e
			fi	
			bash "$HOME/.wine-roblox-malik/$DXVK/setup_dxvk.sh" install
		else
			echo "Skipping DXVK!"
		fi
	fi
fi

clear
# let user know their system has just been pimped :)
echo -e "${Green}Setup complete. Launch a game from the website then you will be logged into the app.${Reset}"
main_menu

}


#################################################################################
########################      MAIN MENU    ######################################
#################################################################################


main_menu()
{

echo " "

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
echo "${Red}This Linux distro is not supported sorry. Now aborting.${Reset}"
exit
fi

		WINE_NAME="lutris-GE-Proton8-18-x86_64"
		WINE_URL="https://api.onedrive.com/v1.0/shares/s!AqNZGNosZPHPhmUjN1kGL3TXYATq/root/content"
		WINE_MD5="5d613c73e4aca1e4ec840818d37ea5f7"
		WINE_RUN="$HOME/.wine-roblox-malik/$STUDIO_WINE_NAME/bin/wine"

		STUDIO_WINE_NAME="lutris-GE-Proton8-18-x86_64"
		STUDIO_WINE_URL="https://api.onedrive.com/v1.0/shares/s!AqNZGNosZPHPhmUjN1kGL3TXYATq/root/content"
		STUDIO_WINE_MD5="5d613c73e4aca1e4ec840818d37ea5f7"
		STUDIO_WINE_RUN="$HOME/.wine-roblox-malik/$STUDIO_WINE_NAME/bin/wine"

PS3='Please make a selection:'
distros=( "$(tput bold setaf 4)Install Roblox$(tput sgr0)" "$(tput bold setaf 4)Install Roblox Studio$(tput sgr0)" "$(tput bold setaf 4)Uninstall Roblox$(tput sgr0)" "$(tput bold setaf 4)Exit$(tput sgr0)")

select fav in "${distros[@]}"; do
    case $fav in

#################################################################################
########################      Install Roblox        #############################
#################################################################################

        "$(tput bold setaf 4)Install Roblox$(tput sgr0)")

full_setup
clear
echo -e "${Green}Setup complete.${Reset}"
main_menu
		;;


#################################################################################
########################      Install Roblox Studio        ######################
#################################################################################
	    
	    "$(tput bold setaf 4)Install Roblox Studio$(tput sgr0)")
	    
#check if Roblox installed  
if [ ! -f "$HOME/.wine-roblox-malik/drive_c/Program Files (x86)/Roblox/Versions/RobloxStudioLauncherBeta.exe" ];
then
	clear
	echo -e "${Red}Roblox installation missing install Roblox first! ${Reset}"
	main_menu
fi

# download and extract custom wine if needed.

	if [ ! -d "$HOME/.wine-roblox-malik/$STUDIO_WINE_NAME" ];
	then
		
		downloader $STUDIO_WINE_NAME "$HOME/.wine-roblox-malik/$STUDIO_WINE_NAME.tar.xz" $STUDIO_WINE_URL $STUDIO_WINE_MD5
	fi

# add my roblox studio launcher to xdg list.
xdg-mime default "roblox-studio-malik.desktop" x-scheme-handler/roblox-studio
xdg-mime default "roblox-studio-auth-malik.desktop" x-scheme-handler/roblox-studio-auth
xdg-mime default "roblox-studio-malik.desktop" application/x-roblox-rbxl
xdg-mime default "roblox-studio-malik.desktop" application/x-roblox-rbxlx

#create studio and studio auth desktop files for xdg-open
echo -e "[Desktop Entry]\nVersion=1.0\nName=roblox-studio-malik\nExec=bash -c \"find \\\"$(xdg-user-dir DESKTOP)\\\" -name \\\"*Roblox*\\\" -not -name \\\"*Malik*\\\" -delete && export WINEPREFIX=\\\"$HOME/.wine-roblox-malik\\\" && export WINEESYNC=1 && export WINEFSYNC=1 && \\\"$STUDIO_WINE_RUN\\\" \\\"\$(find \\\"$HOME/.wine-roblox-malik/drive_c\\\" -name 'RobloxStudioLauncherBeta.exe' -not -path '*/Temp/*')\\\" %U\"\nIcon=$HOME/.wine-roblox-malik/Roblox-Studio-Beta.png\nMimeType=x-scheme-handler/roblox-studio;application/x-roblox-rbxl;application/x-roblox-rbxlx\nType=Application\nTerminal=false\n" > "$HOME/.local/share/applications/roblox-studio-malik.desktop"
chmod +x "$HOME/.local/share/applications/roblox-studio-malik.desktop"
echo -e "[Desktop Entry]\nVersion=1.0\nName=roblox-studio-auth-malik\nExec=bash -c \"export WINEPREFIX=\\\"$HOME/.wine-roblox-malik\\\" && export WINEESYNC=1 && export WINEFSYNC=1 && \\\"$STUDIO_WINE_RUN\\\" \\\"\$(find \\\"$HOME/.wine-roblox-malik/drive_c\\\" -name 'RobloxStudioBeta.exe' -not -path '*/Temp/*')\\\" %U\"\nIcon=$HOME/.wine-roblox-malik/Roblox-Studio-Beta.png\nMimeType=x-scheme-handler/roblox-studio-auth;application/x-roblox-rbxl;application/x-roblox-rbxlx\nType=Application\nTerminal=false\n" > "$HOME/.local/share/applications/roblox-studio-auth-malik.desktop"
chmod +x "$HOME/.local/share/applications/roblox-studio-auth-malik.desktop"

#install studio
WINEPREFIX="$HOME/.wine-roblox-malik" WINEDEBUG=-all WINEESYNC=1 WINEFSYNC=1 $STUDIO_WINE_RUN "$HOME/.wine-roblox-malik/drive_c/Program Files (x86)/Roblox/Versions/RobloxStudioLauncherBeta.exe"
find $(xdg-user-dir DESKTOP) -name "*Roblox*" -not -name "*Malik*" -name "*.lnk" -delete

echo -e "[Desktop Entry]\nVersion=1.0\nName=Roblox Studio Malik\nExec=bash -c \" zenity --info --text=\\\"Login to Roblox Player App for Studio to work!\\\" && export WINEPREFIX=\\\"$HOME/.wine-roblox-malik\\\" && export WINEESYNC=1 && export WINEFSYNC=1 && \\\"$STUDIO_WINE_RUN\\\" \\\"\$(find \\\"$HOME/.wine-roblox-malik/drive_c\\\" -name 'RobloxStudioBeta.exe' -not -path '*/Temp/*') \\\" -ide \"\nIcon=$HOME/.wine-roblox-malik/Roblox-Studio-Beta.png\nMimeType=x-scheme-handler/roblox-studio;application/x-roblox-rbxl;application/x-roblox-rbxlx\nType=Application\n" > "$(xdg-user-dir DESKTOP)/Roblox Studio Malik.desktop"
chmod +x "$(xdg-user-dir DESKTOP)/Roblox Studio Malik.desktop"

clear
echo -e "${Green}Roblox Studio setup complete. Make sure the app in logged in before running Studio.${Reset}"
main_menu
	    ;;

#################################################################################
########################      Uninstall Roblox        ###########################
#################################################################################

        "$(tput bold setaf 4)Uninstall Roblox$(tput sgr0)")

find "$(xdg-user-dir DESKTOP)" -name "*Roblox*" -name "*.lnk" -name "*.desktop" -delete

if [ -f "$HOME/.local/share/applications/mimeinfo.cache" ];
then
	rm -rf "$HOME/.local/share/applications/mimeinfo.cache"
fi

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

if [ -f "$HOME/.local/share/applications/roblox-studio-auth-malik.desktop" ];
then
	rm "$HOME/.local/share/applications/roblox-studio-auth-malik.desktop"
fi

if [ -f "$HOME/Desktop/Roblox Studio Malik.desktop" ];
then
	rm "$HOME/Desktop/Roblox Studio Malik.desktop"
fi

if [ -f "$HOME/Desktop/Roblox App Malik.desktop" ];
then
	rm "$HOME/Desktop/Roblox App Malik.desktop"
fi

if [ -f "$HOME/.config/mimeapps.list" ];
then
	sed -i '/roblox/d' "$HOME/.config/mimeapps.list"
fi
clear
echo -e "${Green}Uninstall complete.${Reset}"
main_menu
#exit
	    ;;
	"$(tput bold setaf 4)Exit$(tput sgr0)")
	exit
	    ;;
        *) echo -e "${Red}Invalid selection $REPLY. Valid selections are 1,2.3 and 4.${Reset}";;
    esac
done
#exit

}

main_menu
