#!/bin/bash
waterfox_binary_install_deb(){
binary=("libasound2-dev" "libgtk-3-0" "libx11-xcb1")
dpkg -l | grep -qw ${binary_setup}
for binary_setup in "${binary[@]}"; do
if [ $? -eq 0 ]; then
    echo "Package ${binary_setup} is installed."
    sleep 0.2 && clear
else
    echo "Package ${binary_setup} is not installed."
    sudo apt install -y ${binary_setup}
    sleep 0.2
    clear
fi
if [ ! -f ~/waterfox-$waterfox_latest_version/usr/lib/waterfox/libgtk-3.so.0 ]; then
    sudo cp /usr/lib/x86_64-linux-gnu/libgtk-3.so.0 ~/waterfox-$waterfox_latest_version/usr/lib/waterfox && 
fi
if [ ! -f ~/waterfox-$waterfox_latest_version/usr/lib/waterfox/libasound.so ]; then
    sudo cp /usr/lib/x86_64-linux-gnu/libasound.so ~/waterfox-$waterfox_latest_version/usr/lib/waterfox
fi
if [ -f  ~/waterfox-$waterfox_latest_version/usr/lib/waterfox/libX11-xcb.so.1 ]; then
    sudo cp /usr/lib/x86_64-linux-gnu/libX11-xcb.so.1 ~/waterfox-$waterfox_latest_version/usr/lib/waterfox
fi
}
# Bash script install waterfox on Arch Linux, Fedora Linux, Debian and Debian based distros
waterfox_latest_version="6.6.3"
if [ -d /etc/apt ]; then
  wget -P ~/ --show-progress -q https://github.com/GitXpresso/LinuxPKG/releases/download/ITB/waterfox_deb_dir.tar
  cd ~/
  wget -P ~/ -q --show-progress https://github.com/gitxpresso/releases/download/Waterfox/waterfox_dir.tar
  tar -xvf  ~/waterfox_dir.tar -C ~/
  wget -P ~/ -q --show-progress https://cdn1.waterfox.net/waterfox/releases/$waterfox_latest_version/Linux_x86_64/waterfox-$waterfox_latest_version.tar.bz2
  tar -xvf ~/*.bz2 -C ~/waterfox-6.6.3/usr/lib/
  waterfox_binary_install_deb
  if [ ! $(dpkg -l | grep -qw dpkg-dev) ]; then
    echo "dpkg-deb not installed, installing..."
    sudo apt install dpkg-deb -y
    clear
  fi
  if [ ! $(dpkg -l | grep -qw build-essential) ]; then
      echo "build essential not installed, installing..."
      sudo apt install -y build-essential
      clear
  fi
  dpkg-deb -b ~/waterfox-6.6.3
  fi
  # Not finished

