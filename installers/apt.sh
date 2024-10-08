#!/usr/bin/env bash

apt_deps_to_install=(
	"build-essential"
	"software-properties-common"
	"gnome-shell-extensions"
	"gnome-tweaks"
	"cosmic-store"
	"flatpak"
	"libmpv1"       # mpv video pplayer
	"libnss3-tools" # mkcert
)

apt_deps_to_remove=(
	"pop-shop"
)

configure_apt() {
	echo -e "\nUpdate apt"
	sudo apt update # &>/dev/null
}

# Install appimagelauncher
install_appimagelauncher() {
	echo "=> configuring appimagelauncher"
	if ! is_apt_installed appimagelauncher; then
		sudo add-apt-repository -yes ppa:appimagelauncher-team/stable
		sudo apt update
		sudo apt install -yes appimagelauncher
	fi
}

# Install font-manager
install_font_manager() {
	echo "=> configuring font-manager"
	if ! is_apt_installed font-manager; then
		sudo add-apt-repository -yes ppa:font-manager/staging
		sudo apt update
		sudo apt install -yes font-manager
	fi
}

# Install required apt dependencies
install_apt_packages() {
	echo -e "\nInstall apt packages"
	for pkg in "${apt_deps_to_install[@]}"; do
		echo "=> configuring $pkg"
		if ! is_apt_installed $pkg; then
			sudo apt install -yes $pkg
		fi
	done

	install_appimagelauncher
	install_font_manager
}

# Remove junk binaries
cleanup_apt() {
	echo -e "\nRemove apt packages"
	for pkg in "${apt_deps_to_remove[@]}"; do
		echo "=> removing $pkg"
		if is_apt_installed $pkg; then
			sudo apt remove -yes $pkg
		fi
	done
}
