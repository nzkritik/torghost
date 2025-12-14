# Edited by KP
#!/bin/bash

# Pretty-print helpers (use gum when available, otherwise fall back to echo)
gum_available() {
	command -v gum >/dev/null 2>&1
}

pretty_title() {
	if gum_available; then
		gum style --foreground=212 --bold "$*"
	else
		echo "$*"
	fi
}

pretty_info() {
	if gum_available; then
		gum style --foreground=green "$*"
	else
		echo "$*"
	fi
}

pretty_success() {
	if gum_available; then
		gum style --foreground=teal "$*"
	else
		echo "$*"
	fi
}

pretty_warn() {
	if gum_available; then
		gum style --foreground=yellow "$*"
	else
		echo "$*"
	fi
}

pretty_error() {
	if gum_available; then
		gum style --foreground=red --bold "$*"
	else
		echo "$*"
	fi
}

# Check if running as sudo
if [ "$EUID" -ne 0 ]; then
	pretty_warn "=====> This script requires sudo privileges"
	sudo "$0" "$@"
	exit $?
fi

# Detect OS and ensure it's Arch or Arch-based
if [ -f /etc/os-release ]; then
	# shellcheck disable=SC1091
	. /etc/os-release
	OS_CHECK="$(echo "${ID:-} ${ID_LIKE:-}" | tr '[:upper:]' '[:lower:]')"
	if echo "$OS_CHECK" | grep -qw "arch"; then
		pretty_success "=====> Detected Arch-based distro: ${NAME:-$ID}"
	else
		pretty_error "=====> Unsupported distro: ${NAME:-$ID}. This installer supports Arch Linux or Arch-based distros only."
		exit 1
	fi
else
	pretty_error "=====> Cannot detect OS. /etc/os-release not found."
	exit 1
fi

# Ensure gum is installed
if ! command -v gum &>/dev/null; then
    pretty_info "gum not found. Installing gum..."
    sudo pacman -S --noconfirm --needed gum || {
        pretty_error "Failed to install gum. Please install it manually."
        exit 1
    }
fi

# Banner (regular text)
cat <<'BANNER'
▄▄▄▄▄▄▄▄▄           ▄▄▄▄▄▄▄  ▄▄                      
▀▀▀███▀▀▀          ███▀▀▀▀▀  ██                 ██   
   ███ ▄███▄ ████▄ ███       ████▄ ▄███▄ ▄█▀▀▀ ▀██▀▀ 
   ███ ██ ██ ██ ▀▀ ███  ███▀ ██ ██ ██ ██ ▀███▄  ██   
   ███ ▀███▀ ██    ▀██████▀  ██ ██ ▀███▀ ▄▄▄█▀  ██   
                                                     
                                                     
BANNER

clear
pretty_title "******* Torghost installer for Arch Linux ********"
pretty_info "Torghost made by Technical Dada"
pretty_info "Updated for Arch by nzKritiK"
printf "\n"

# Check and manage virtual environment
VENV_PATH="$HOME/.venv"
if [ -d "$VENV_PATH" ]; then
	pretty_info "=====> Activating existing virtual environment"
	source "$VENV_PATH/bin/activate"
else
	pretty_info "=====> Creating virtual environment"
	python -m venv "$VENV_PATH"
	source "$VENV_PATH/bin/activate"
fi

# Install dependencies for Arch Linux
pretty_info "=====> Installing dependencies using pacman"
sudo pacman -S --noconfirm tor python-pip

pip install stem

pretty_info "=====> Installing TorGhost"
sudo cp torghost /usr/local/bin/torghost
sudo chmod +x /usr/local/bin/torghost

pretty_success "=====> Done"
pretty_info "=====> Open terminal and type 'torghost' for usage"
