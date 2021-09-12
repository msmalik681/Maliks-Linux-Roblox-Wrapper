#!/bin/bash

#################################################################################
########################      FULL_SETUP    #####################################
#################################################################################

full_setup () {

# install "lib32-gnutls" if missing.
if ! $distro_check lib32-gnutls > /dev/null ;
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

# make custom directory if missing
if [ ! -d ~/.wine-roblox-malik ];
then
	cd ~/
	mkdir .wine-roblox-malik
fi

# set custom directory as default for wine to use
export WINEPREFIX=~/.wine-roblox-malik
WINEPREFIX=~/.wine-roblox-malik wineboot -u -i

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
			wget --no-check-certificate "https://onedrive.live.com/download?cid=CFF1642CDA1859A3&resid=CFF1642CDA1859A3%21628&authkey=AP2ynol00vhp_Oc" -O wine-tkg-staging-fsync-git-6.16.r0.g931daeff.tar.xz
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

# add my roblox launcher to xdg list.
xdg-mime default "roblox-malik.desktop" x-scheme-handler/roblox-player

# make desktop entry for roblox launcher.
echo -e "[Desktop Entry]\nVersion=1.0\nName=roblox-malik\nExec=bash -c \"WINEPREFIX=~/.wine-roblox-malik WINEESYNC=1 WINEFSYNC=1 ~/.wine-roblox-malik/wine-tkg-staging-fsync-git-6.16.r0.g931daeff/bin/wine \\\"\$(find ~/.wine-roblox-malik/drive_c/users -name 'RobloxPlayerLauncher.exe' -not -path '*/Temp/*')\\\" %U\"\nMimeType=x-scheme-handler/roblox-player;\nIcon=utilities-terminal\nType=Application\nTerminal=false\n" > ~/.local/share/applications/roblox-malik.desktop

# Install Roblox through wine if missing.
if [[ $(find ~/.wine-roblox-malik/drive_c/users -name 'RobloxPlayerLauncher.exe' -not -path '*/Temp/*') == *.exe ]];
then
echo "Roblox is installed!"
else
echo "Need to Install Roblox!"
~/.wine-roblox-malik/wine-tkg-staging-fsync-git-6.16.r0.g931daeff/bin/wine ~/.wine-roblox-malik/RobloxPlayerLauncher.exe
fi

echo " " 
# let user know their system has just been pimped :)
read -p "Setup complete remember to reset settings on chrome if no option to open with roblox-malik . . ."

}


#################################################################################
########################      SETUP        ######################################
#################################################################################


if cat /etc/os-release | grep -io "fedora" > /dev/null;
then
distro_guess="Fedora"
elif cat /etc/os-release | grep -io "debian" > /dev/null || cat /etc/os-release | grep -io "ubuntu" > /dev/null;
then
distro_guess="Debian"
elif cat /etc/os-release | grep -io "arch" > /dev/null;
then
distro_guess="Arch"
fi

if ! test -z $distro_guess;
then
distro_guess="Your Distro looks like $distro_guess. "
#echo "$distro_guess"
fi

PS3=$distro_guess"Choose your Distro:"
distros=("Debian" "Arch" "Fedora" "Roblox_Studio" "Exit")
select fav in "${distros[@]}"; do
    case $fav in

#################################################################################
########################      DEBIAN        #####################################
#################################################################################

        "Debian")

read -p "Roblox setup for Debian Linux. Close all web browsers then press any key to start . . ."

distro_check="dpkg -l"
distro_install="apt install"

full_setup

		exit
		;;

#################################################################################
########################      ARCH        #######################################
#################################################################################

        "Arch")

read -p "Roblox setup for Arch Linux. Close all web browsers then press any key to start . . ."	   

distro_check="pacman -Qs"
distro_install="pacman -S"

full_setup

		exit
		;;

#################################################################################
########################      FEDORA        #####################################
#################################################################################

        "Fedora")

read -p "Roblox setup for Fedora Linux. Close all web browsers then press any key to start . . ."

distro_check="rpm -q"
distro_install="yum install"

full_setup

		exit
		;;
	    
#################################################################################
########################      Roblox_Studio        ##############################
#################################################################################
	    
	    "Roblox_Studio")
	    
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


	
echo -e "[Desktop Entry]\nName=Roblox Studio Malik\nComment=msmalik681\nExec=bash -c \"WINEPREFIX=~/.wine-roblox-malik/studio-malik WINEESYNC=1 WINEFSYNC=1 ~/.wine-roblox-malik/wine-tkg-staging-fsync-git-6.16.r0.g931daeff/bin/wine \\\"\$(find ~/.wine-roblox-malik/drive_c/users -name 'RobloxStudioLauncherBeta.exe' -not -path '*/Temp/*' -print -quit)\\\"\"\nIcon=2052_RobloxStudioLauncherBeta.0\nTerminal=false\nType=Application\nCategories=Wine;" > ~/Desktop/'Roblox Studio Malik.desktop'
	chmod +x  ~/Desktop/'Roblox Studio Malik.desktop'
	
	read -p "Roblox Studio shotcut made on Desktop. Now Launching Studio press any key to start . . ."
		
		WINEPREFIX=~/.wine-roblox-malik/studio-malik WINEESYNC=1 WINEFSYNC=1 ~/.wine-roblox-malik/wine-tkg-staging-fsync-git-6.16.r0.g931daeff/bin/wine "$(find ~/.wine-roblox-malik/drive_c/users -name 'RobloxStudioLauncherBeta.exe' -not -path '*/Temp/*' -print -quit)"

fi
	    ;;


	"Exit")
	exit
	    ;;
        *) echo "Invalid option $REPLY. Valid options are 1,2,3,4 and 5.";;
    esac
done
exit









