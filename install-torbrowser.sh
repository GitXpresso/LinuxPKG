#!/usr/bin/bash

if grep -qi "Fedora" /etc/*release; then
if [ -f /usr/bin/tor-browser ]; then 
  while true; do
      read -p "Tor was installed using flatpak would you like to run tor? (yes/no/y/n): " yesorno2
        if [[ "$yesorno2" == "yes" || "$yesorno2" == "y" ]]; then
	   echo "running tor browser using flatpak..."
           tor-browser
	   exit 1
	   break
        elif [[ "$yesorno2" == "no" || "$yesorno2" == "n" ]]; then
           echo "not running tor-browser, exiting..."
           exit 1
	   break
        else
	   echo "Invalid input, try again..."
	   sleep 0.2
	   clear
	fi
    done
elif [[ -f /tmp/tor-browser-tar-install.tmp ]]; then
while true; do    
  read -p "Tor was installed, using tar, would you like to run tor browser? (yes/no/y/n): " yesorno3
     if [[ "$yesorno3" == "yes" || "$yesorno3" == "y" ]]; then
       /usr/bin/tor-browser
       exit 1
       break
     elif [[ "$yesorno3" == "no" || "$yesorno3" == "n" ]]; then
       echo "not running tor browser, exiting..."
       exit 1
       break
     else
        echo "Invalid option, try again..."
        sleep 0.2
	clear
     fi
  done
elif [[ -f /usr/bin/torbrowser-launcher ]]; then
while true; do
  read -p "Tor was installed, using dnf, would you like to run tor browser? (yes/no/y/n): " yesorno4
     if [[ "$yesorno4" == "yes" || "$yesorno4" == "y" ]]; then
       /usr/bin/torbrowser-launcher
       exit 1
       break
     elif [[ "$yesorno4" == "no" || "$yesorno4" == "n" ]]; then
       echo "not running tor browser, exiting..."
       exit 1
       break
     else
        echo "Invalid option, try again..."
        sleep 0.2
        clear
     fi
  done
fi
check_if_in_container=$(systemd-detect-virt --container)
if [ "$check_if_in_container" == "docker" ]; then
echo "Pick how you want to install tor browser:
1. Tar Install
2. Dnf install
3. Flatpak install ( You are in a container which flatpak will not work in a containerized environment, picking this option will cause the script to exit. )
"
else
   echo "Pick how you want to install tor browser:
1. Tar Install
2. Dnf install
3. Flatpak install [ You are in a container which flatpak will not work in a containerized environment ]
"
fi
while true; do
 read -p "Pick an option [1-3]: " torbrowser_installation_option
  if [[ "$torbrowser_installation_option" == "1." || "$torbrowser_installation_option" == "1" ]]; then
    # If file is found then it will not install the package
    echo "Checking if tar and wget is installed..."
    if [ -f /usr/bin/wget ]; then
      echo "wget is installed, not installing wget."
    else
      echo "wget is not installed, installing wget..."
      sudo dnf install -y wget
      sleep 0.2
      clear
      echo "Finished installing wget."
    fi
    if [ -f /usr/bin/tar ]; then
      echo "Tar is installed, not installing tar."
    else
      echo "Tar is not installed, installing tar..."
      sudo dnf install -y tar
      sleep 0.2
      clear
      echo "Finished installing Tar, downloading and extracting the tor browser tar file"
    fi
        wget --show-progress -q -P ~/ https://dist.torproject.org/torbrowser/14.5.6/tor-browser-linux-x86_64-14.5.6.tar.xz
        echo "Extracting tar file..."
        tar -xf tor-browser-linux-x86_64-14.5.6.tar.xz -C ~/
        echo "Removing tarfile..."
        rm -rf ~/tor-browser-linux-x86_64-14.5.6.tar.xz
        echo "creating symbolic link..."
        sudo ln -s ~/tor-browser/Browser/start-tor-browser /usr/bin/tor-browser
        echo "Done, creating symbolic link, creating desktop file..."
        sudo curl -fsSL https://bit.ly/TorBrowserDesktopFile -o /usr/share/applications/tor-browser.desktop
        echo "Done, installing tor browser"
	touch /tmp/tor-browser-tar-install.tmp
	break
  elif [[ "$torbrowser_installation_option" == "2." || "$torbrowser_installation_option" == "2" ]]; then
    echo "Installing Tor using dnf..."
    echo "adding tor repository using dnf..."
    sudo dnf config-manager --add-repo https://rpm.torproject.org/fedora/torproject.repo
    touch /tmp/tor_dnf_install.tmp
    sleep 0.2
    clear
    echo "Done, adding tor repository."
    echo "Adding tor gpg key..."
    sudo dnf install -y tor-project-keyring
    sleep 0.2
    clear
    echo "Done adding tor gpg key"
    echo "now installing tor..."
    sudo dnf install -y torbrowser-launcher
    echo "Done, running tor browser..."
    break
  elif [[ "$torbrowser_installation_option" == "3." || "$torbrowser_installation_option" == "3" ]]; then
    check_if_in_container=$(systemd-detect-virt --container)
  if [ "$check_if_in_container" == "docker" ]; then
    echo "Flatpak does not work in a containerizied environment, exiting..."
    exit 1
  else
      if ! command -v flatpak; then
	echo "flatpak is not installed, installing flatpak..."
        sudo dnf install flatpak -y
        clear
       	   sudo flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo
	   sudo flatpak install flathub org.torproject.torbrowser-launcher
	   if [ ! -f /usr/bin/tor-browser ]; then
             sudo touch /usr/bin/tor-browser; then
	     echo "flatpak run org.torproject.torbrowser-launcher" >> ~/tor-browser.tmp
	     sudo cp ~/tor-browser.tmp /usr/bin/tor-browser
	     sudo chmod +x /usr/bin/tor-browser
	     rm -f ~/tor-browser.tmp
             echo "You can run the tor browser flatpak package by doing \"tor-browser\" in the terminal"
             break
     else
	   echo "flatpak is already installed."
           sudo sudo flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo
           sudo flatpak install flathub org.torproject.torbrowser-launcher
           if [ ! -f /usr/bin/tor-browser ]; then
             sudo touch /usr/bin/tor-browser
	     echo "
	     #!/bin/bash
	     flatpak run org.torproject.torbrowser-launcher" >> ~/tor-browser.tmp
	     sudo cp ~/tor-browser.tmp /usr/bin/tor-browser
	     sudo chmod +x /usr/bin/tor-browser
	     rm -f ~/tor-browser.tmp
	   fi
	   echo "You can run the tor browser flatpak package by doing \"tor-browser\" in the terminal"
           break
      fi
  fi
  else
    echo "Invalid option, try again..."
    sleep 0.5
    clear
  fi
done

else 
   echo "This script supports fedora only, exiting..."
   exit 1
fi
