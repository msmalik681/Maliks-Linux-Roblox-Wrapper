#!/bin/bash

#clear any older versions
if [[ ! $(find ~/".wine-roblox-malik/drive_c/Program Files (x86)/Roblox/Versions" -name 'RobloxPlayerLauncher.exe' -not -path '*/Temp/*') == *.exe ]];
then
rm -rf ~/.wine-roblox-malik
fi

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

# remove any other roblox launchers.
if [ ! -f ~/.config/mimeapps.list ];
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
WINEPREFIX=~/.wine-roblox-malik wineboot -i

# Install or uninstall DXVK
wineserver -k
if [ -f ~/.wine-roblox-malik/dosdevices/c:/windows/syswow64/d3d11.dll.old ];
then
	read -p "Do you want to uninstall DXVK (y/n)?"
	if [[ $REPLY =~ ^[Yy]$ ]]
	then
	
	for i in {1..5}
	do

		if [ $i == 5 ];
		then 
			echo "error: failed to download dxvk-1.9.1.tar.gz"
			exit
		fi

		cd ~/.wine-roblox-malik
		if [ ! -f ~/.wine-roblox-malik/dxvk-1.9.1.tar.gz ];
		then
			wget --no-check-certificate "https://github.com/doitsujin/dxvk/releases/download/v1.9.1/dxvk-1.9.1.tar.gz" -O dxvk-1.9.1.tar.gz
		fi
	
		if md5sum ~/.wine-roblox-malik/dxvk-1.9.1.tar.gz | grep -i 09058abcd44d72a7555fac0a2254351a > /dev/null;
		then 
			tar -xf ~/.wine-roblox-malik/dxvk-1.9.1.tar.gz
			break
		else 
			rm ~/.wine-roblox-malik/dxvk-1.9.1.tar.gz
		fi
	done
	
	 bash ~/.wine-roblox-malik/dxvk-1.9.1/setup_dxvk.sh uninstall
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
			echo "error: failed to download dxvk-1.9.1.tar.gz"
			exit
		fi

		cd ~/.wine-roblox-malik
		if [ ! -f ~/.wine-roblox-malik/dxvk-1.9.1.tar.gz ];
		then
			wget --no-check-certificate "https://github.com/doitsujin/dxvk/releases/download/v1.9.1/dxvk-1.9.1.tar.gz" -O dxvk-1.9.1.tar.gz
		fi
	
		if md5sum ~/.wine-roblox-malik/dxvk-1.9.1.tar.gz | grep -i 09058abcd44d72a7555fac0a2254351a > /dev/null;
		then 
			tar -xf ~/.wine-roblox-malik/dxvk-1.9.1.tar.gz
			break
		else 
			rm ~/.wine-roblox-malik/dxvk-1.9.1.tar.gz
		fi
	done
	 bash ~/.wine-roblox-malik/dxvk-1.9.1/setup_dxvk.sh install
	else
	 echo "Skipping DXVK!"
	fi
fi

# download and extract custom wine if missing.
if [ ! -d ~/.wine-roblox-malik/wine-tkg-staging-fsync-git-6.16.r0.g931daeff ];
then
	for i in {1..5}
	do

		if [ $i == 5 ];
		then 
			echo "error: failed to download wine-tkg-staging-fsync-git-6.16.r0.g931daeff.tar.xz"
			exit
		fi

		cd ~/.wine-roblox-malik
		if [ ! -f ~/.wine-roblox-malik/wine-tkg-staging-fsync-git-6.16.r0.g931daeff.tar.xz ];
		then
			wget --no-check-certificate "https://onedrive.live.com/download?cid=CFF1642CDA1859A3&resid=CFF1642CDA1859A3%21628&authkey=AN73mkW13cgxtL8" -O wine-tkg-staging-fsync-git-6.16.r0.g931daeff.tar.xz
		fi
	
		if md5sum ~/.wine-roblox-malik/wine-tkg-staging-fsync-git-6.16.r0.g931daeff.tar.xz | grep -i 9f3096fa1928a5b189430df14b34f601 > /dev/null;
		then 
			tar -xf ~/.wine-roblox-malik/wine-tkg-staging-fsync-git-6.16.r0.g931daeff.tar.xz
			break
		else 
			rm ~/.wine-roblox-malik/wine-tkg-staging-fsync-git-6.16.r0.g931daeff.tar.xz
		fi
	done
fi

# download Roblox if missing.
if [ ! -f ~/.wine-roblox-malik/RobloxPlayerLauncher.exe ];
then
	wget -O ~/.wine-roblox-malik/RobloxPlayerLauncher.exe https://setup.rbxcdn.com/RobloxPlayerLauncher.exe
fi

# make desktop entry for roblox launcher.
echo -e "[Desktop Entry]\nVersion=1.0\nName=roblox-malik\nExec=bash -c \"WINEPREFIX=~/.wine-roblox-malik WINEESYNC=1 WINEFSYNC=1 \"~/.wine-roblox-malik/wine-tkg-staging-fsync-git-6.16.r0.g931daeff/bin/wine\" \\\"\$(find ~/'.wine-roblox-malik/drive_c/Program Files (x86)/Roblox/Versions' -name 'RobloxPlayerLauncher.exe' -not -path '*/Temp/*')\\\" %U\"\nMimeType=x-scheme-handler/roblox-player;\nIcon=utilities-terminal\nType=Application\nTerminal=false\n" > ~/.local/share/applications/roblox-malik.desktop

# Install Roblox through wine if missing.
if [[ $(find ~/".wine-roblox-malik/drive_c/Program Files (x86)/Roblox/Versions" -name 'RobloxPlayerLauncher.exe' -not -path '*/Temp/*') == *.exe ]];
then
echo "Roblox is installed!"
else
echo "Need to Install Roblox!"
wine ~/.wine-roblox-malik/RobloxPlayerLauncher.exe
fi

echo " " 
# let user know their system has just been pimped :)
echo "Setup complete remember to reset settings on chrome if no option to open with roblox-malik . . ."

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

PS3="Please make a selection:"
distros=("Install Roblox" "Install Roblox Studio" "Exit")
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
	    
if [ ! -d ~/.wine-roblox-malik ];
then
	echo "Roblox installation missing install Roblox first!"
else

	# make studio and settings directory if missing
	if [ ! -d ~/.wine-roblox-malik/studio-malik ];
	then
		mkdir ~/.wine-roblox-malik/studio-malik ~/.wine-roblox-malik/studio-malik/drive_c ~/.wine-roblox-malik/studio-malik/drive_c/users ~/.wine-roblox-malik/studio-malik/drive_c/users/$USER ~/.wine-roblox-malik/studio-malik/drive_c/users/$USER/AppData ~/.wine-roblox-malik/studio-malik/drive_c/users/$USER/AppData/Local ~/.wine-roblox-malik/studio-malik/drive_c/users/$USER/AppData/Local/Roblox
	
	# make settings file with vulkan enabled
	echo -e "<roblox xmlns:xmime=\"http://www.w3.org/2005/05/xmlmime\" xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xsi:noNamespaceSchemaLocation=\"http://www.roblox.com/roblox.xsd\" version=\"4\">\n<External>null</External>\n<External>nil</External>\n<Item class=\"RenderSettings\" referent=\"RBXF1A996A230144B82B15B8A62D3CD03A1\">\n<Properties>\n<token name=\"GraphicsMode\">6</token>\n</Properties>\n</Item>\n</roblox>" > ~/.wine-roblox-malik/studio-malik/drive_c/users/$USER/AppData/Local/Roblox/GlobalSettings_13.xml
	fi


	
echo -e "[Desktop Entry]\nName=Roblox Studio Malik\nComment=msmalik681\nExec=bash -c \"WINEPREFIX=~/.wine-roblox-malik/studio-malik WINEESYNC=1 WINEFSYNC=1 ~/'.wine-roblox-malik/wine-tkg-staging-fsync-git-6.16.r0.g931daeff/bin/wine' ~/'.wine-roblox-malik/drive_c/Program Files (x86)/Roblox/Versions/RobloxStudioLauncherBeta.exe'\"\nIcon=2052_RobloxStudioLauncherBeta.0\nTerminal=false\nType=Application\nCategories=Wine;" > ~/Desktop/'Roblox Studio Malik.desktop'
	chmod +x  ~/Desktop/'Roblox Studio Malik.desktop'
	
	read -p "Roblox Studio shotcut made on Desktop. Now Launching Studio press Return key to start . . ."
		
		WINEPREFIX=~/.wine-roblox-malik/studio-malik WINEDEBUG=-all WINEESYNC=1 WINEFSYNC=1 ~/".wine-roblox-malik/wine-tkg-staging-fsync-git-6.16.r0.g931daeff/bin/wine" ~/".wine-roblox-malik/drive_c/Program Files (x86)/Roblox/Versions/RobloxStudioLauncherBeta.exe"

fi
	exit
	    ;;


	"Exit")
	exit
	    ;;
        *) echo "Invalid selection $REPLY. Valid selections are 1,2 and 3.";;
    esac
done
exit










