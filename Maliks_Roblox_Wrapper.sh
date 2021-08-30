#!/bin/bash

full_setup () {

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
		if [ ! -f ~/.wine-roblox-malik/dxvk-1.9.1.tar.gz ];
			then
		cd ~/.wine-roblox-malik
		wget --no-check-certificate "https://github.com/doitsujin/dxvk/releases/download/v1.9.1/dxvk-1.9.1.tar.gz" -O dxvk-1.9.1.tar.gz
	 fi
	 if [ ! -d ~/.wine-roblox-malik/dxvk-1.9.1 ];
	 then
		tar -xf dxvk-1.9.1.tar.gz
	 fi
	 bash ~/.wine-roblox-malik/dxvk-1.9.1/setup_dxvk.sh uninstall
	else
	 echo "Skipping DXVK!"
	fi
else
	read -p "Do you want to install DXVK (y/n)?"
	if [[ $REPLY =~ ^[Yy]$ ]]
	then
		if [ ! -f ~/.wine-roblox-malik/dxvk-1.9.1.tar.gz ];
			then
		cd ~/.wine-roblox-malik
		wget --no-check-certificate $1 -O dxvk-1.9.1.tar.gz
	 fi
	 if [ ! -d ~/.wine-roblox-malik/dxvk-1.9.1 ];
	 then
		tar -xf dxvk-1.9.1.tar.gz
	 fi
	 bash ~/.wine-roblox-malik/dxvk-1.9.1/setup_dxvk.sh install
	else
	 echo "Skipping DXVK!"
	fi
fi

# download and extract custom wine if missing.
if [ ! -d ~/.wine-roblox-malik/wine-tkg-staging-fsync-git-6.15.r0.g4b6879f3 ];
then
	if [ ! -f ~/.wine-roblox-malik/wine-tkg-staging-fsync-git-6.15.r0.g4b6879f3.tar.xz ];
	then
		cd ~/.wine-roblox-malik
		wget --no-check-certificate $1 -O wine-tkg-staging-fsync-git-6.15.r0.g4b6879f3.tar.xz
		
	fi
	tar -xf ~/.wine-roblox-malik/wine-tkg-staging-fsync-git-6.15.r0.g4b6879f3.tar.xz
fi

# download Roblox if missing.
if [ ! -f ~/.wine-roblox-malik/RobloxPlayerLauncher.exe ];
then
	wget -O ~/.wine-roblox-malik/RobloxPlayerLauncher.exe https://setup.rbxcdn.com/RobloxPlayerLauncher.exe
fi

# add my roblox launcher to xdg list.
xdg-mime default "roblox-malik.desktop" x-scheme-handler/roblox-player

# make desktop entry for roblox launcher.
echo -e "[Desktop Entry]\nVersion=1.0\nName=roblox-malik\nExec=bash -c \"WINEPREFIX=~/.wine-roblox-malik WINEFSYNC=1 ~/.wine-roblox-malik/wine-tkg-staging-fsync-git-6.15.r0.g4b6879f3/bin/wine \\\"\$(find ~/.wine-roblox-malik/drive_c/users -name 'RobloxPlayerLauncher.exe' -not -path '*/Temp/*')\\\" %U\"\nMimeType=x-scheme-handler/roblox-player;\nIcon=utilities-terminal\nType=Application\nTerminal=false\n" > ~/.local/share/applications/roblox-malik.desktop

# Install Roblox through wine if missing.
if [[ $(find ~/.wine-roblox-malik/drive_c/users -name 'RobloxPlayerLauncher.exe' -not -path '*/Temp/*') == *.exe ]];
then
echo "Roblox is installed!"
else
echo "Need to Install Roblox"
~/.wine-roblox-malik/wine-tkg-staging-fsync-git-6.15.r0.g4b6879f3/bin/wine ~/.wine-roblox-malik/RobloxPlayerLauncher.exe
fi

echo " " 
# let user know their system has just been pimped :)
read -p "Setup complete remember to reset settings on chrome if no option to open with roblox-malik . . ."


}








echo "********** YOUR SYSTEM INFORMATION ******************"
cat /etc/os-release
echo "*****************************************************"
echo ""
echo ""
echo ""
PS3='Choose your Distro: '
distros=("Debian" "Arch" "Studio")
select fav in "${distros[@]}"; do
    case $fav in

#################################################################################
########################      DEBIAN        #####################################
#################################################################################

        "Debian")

read -p "Roblox setup for Debian Linux. Close all web browsers then press any key to start . . ."
# install "xdg-utils" if missing.
if [ $(dpkg-query -W -f='${Status}' xdg-utils 2>/dev/null | grep -c "ok installed") -eq 0 ];
then
  sudo apt-get install xdg-utils;
fi

# install "git" if missing.
if [ $(dpkg-query -W -f='${Status}' git 2>/dev/null | grep -c "ok installed") -eq 0 ];
then
  sudo apt-get install git;
fi


full_setup "https://onedrive.live.com/download?cid=0D1B2C3D089F7FA0&resid=D1B2C3D089F7FA0%21106&authkey=AAsdS8XcgeXp-_c"

		exit
		;;

#################################################################################
########################      ARCH        #######################################
#################################################################################

        "Arch")

read -p "Roblox setup for Arch Linux. Close all web browsers then press any key to start . . ."	   
# install "xdg-utils" if missing.
if ! pacman -Qs xdg-utils > /dev/null ;
then
echo "xdg-utils missing installing now!"
sudo pacman -S xdg-utils
fi

# install "git" if missing.
if ! pacman -Qs git > /dev/null ;
then
echo "xdg-utils missing installing now!"
sudo pacman -S git
fi

full_setup "https://onedrive.live.com/download?cid=CFF1642CDA1859A3&resid=CFF1642CDA1859A3%21623&authkey=AMJmoWOgE04J65s"

		exit
		;;
	    
#################################################################################
########################      Studio        #####################################
#################################################################################
	    
	    "Studio")
	    
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


	
echo -e "[Desktop Entry]\nName=Roblox Studio Malik\nComment=msmalik681\nExec=bash -c \"WINEPREFIX=~/.wine-roblox-malik/studio-malik WINEFSYNC=1 ~/.wine-roblox-malik/wine-tkg-staging-fsync-git-6.15.r0.g4b6879f3/bin/wine \\\"\$(find ~/.wine-roblox-malik/drive_c/users -name 'RobloxStudioLauncherBeta.exe' -not -path '*/Temp/*' -print -quit)\\\"\"\nIcon=2052_RobloxStudioLauncherBeta.0\nTerminal=false\nType=Application\nCategories=Wine;" > ~/Desktop/'Roblox Studio Malik.desktop'
	chmod +x  ~/Desktop/'Roblox Studio Malik.desktop'
	
	read -p "Roblox Studio shotcut made on Desktop. Now Launching Studio press any key to start . . ."
		
		WINEPREFIX=~/.wine-roblox-malik/studio-malik WINEFSYNC=1 ~/.wine-roblox-malik/wine-tkg-staging-fsync-git-6.15.r0.g4b6879f3/bin/wine "$(find ~/.wine-roblox-malik/drive_c/users -name 'RobloxStudioLauncherBeta.exe' -not -path '*/Temp/*' -print -quit)"

fi
	    ;;
        *) echo "invalid option $REPLY";;
    esac
done
exit



