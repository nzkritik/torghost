# Edited by KP
#!/bin/bash

clear
echo "******* Torghost installer for Arch Linux ********"
echo -e "\033[31mTorghost made by Technical Dada\033[0m"
echo -e "\033[31mUpdated for Arch by nzKritiK\033[0m"
echo

# Install dependencies for Arch Linux
echo -e "\033[32m=====> Installing dependencies using pacman \033[0m"
sudo pacman -S --noconfirm tor python-pip

sudo pip3 install stem

echo -e "\033[32m=====> Installing TorGhost \033[0m"
sudo cp torghost /usr/local/bin/torghost
sudo chmod +x /usr/local/bin/torghost

echo -e "\033[32m=====> Done \033[0m"
echo "=====> Open terminal and type 'torghost' for usage"
