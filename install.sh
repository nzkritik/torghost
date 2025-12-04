# Edited by KP
#!/bin/bash

# Check if running as sudo
if [ "$EUID" -ne 0 ]; then
	echo -e "\033[33m=====> This script requires sudo privileges \033[0m"
	sudo "$0" "$@"
	exit $?
fi

clear
echo "******* Torghost installer for Arch Linux ********"
echo -e "\033[31mTorghost made by Technical Dada\033[0m"
echo -e "\033[31mUpdated for Arch by nzKritiK\033[0m"
echo

# Check and manage virtual environment
VENV_PATH="$HOME/.venv"
if [ -d "$VENV_PATH" ]; then
	echo -e "\033[32m=====> Activating existing virtual environment \033[0m"
	source "$VENV_PATH/bin/activate"
else
	echo -e "\033[32m=====> Creating virtual environment \033[0m"
	python -m venv "$VENV_PATH"
	source "$VENV_PATH/bin/activate"
fi

# Install dependencies for Arch Linux
echo -e "\033[32m=====> Installing dependencies using pacman \033[0m"
sudo pacman -S --noconfirm tor python-pip

pip install stem

echo -e "\033[32m=====> Installing TorGhost \033[0m"
sudo cp torghost /usr/local/bin/torghost
sudo chmod +x /usr/local/bin/torghost

echo -e "\033[32m=====> Done \033[0m"
echo "=====> Open terminal and type 'torghost' for usage"
