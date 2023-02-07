#!/usr/bin/env bash

set -eo pipefail

# Set oneself as sudoers
(su root -c "echo -e '$(whoami)\tALL=(ALL:ALL) ALL' >> /etc/sudoers")

sudo echo 'Installing GNS3...'

# Install GNS3
# source: https://computingforgeeks.com/how-to-install-gns3-on-debian/

sudo apt update
sudo apt install -y python3-pip python3-pyqt5 python3-pyqt5.qtsvg \
  python3-pyqt5.qtwebsockets xterm \
  qemu qemu-kvm qemu-utils libvirt-clients libvirt-daemon-system virtinst \
  wireshark xtightvncviewer apt-transport-https \
  ca-certificates curl gnupg2 software-properties-common

sudo pip3 install gns3-server
sudo pip3 install gns3-gui

## Install ubridge

sudo apt install -y git build-essential pcaputils libpcap-dev
git clone https://github.com/GNS3/ubridge.git
(
  cd ubridge;
  make;
  sudo make install
)
rm -rf ubridge

## Install dynamips

sudo apt install -y libelf-dev libpcap-dev cmake
git clone https://github.com/GNS3/dynamips.git
(
  cd dynamips;
  mkdir build;
  cd build;
  cmake ..;
  sudo make install;
)
rm -rf dynamips

# Install docker
curl -fsSL https://get.docker.com | VERSION=v20.10.22 bash
sudo usermod -aG docker $(whoami)

# Enable wireshark for all users
sudo chmod 755 /usr/bin/dumpcap

echo "Please restart your shell"
