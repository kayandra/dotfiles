#!/usr/bin/env bash

apt_deps_to_install=(
	"curl"
	"grep"
	"wget"
	"git-lfs"
	"build-essential"
	"software-properties-common"
	"libnss3-tools" # mkcert
	"bind9-dnsutils"
	"lld"
)

apt_deps_to_remove=()

configure_apt() {
	echo -e "\nUpdate apt"
	sudo apt update # &>/dev/null
}

# Install required apt dependencies
install_apt_packages() {
	echo -e "\nInstall apt packages"
	for pkg in "${apt_deps_to_install[@]}"; do
		echo "=> configuring $pkg"
		if ! is_apt_installed $pkg; then
			sudo apt install -y $pkg
		fi
	done
}

# Remove junk binaries
cleanup_apt() {
	echo -e "\nRemove apt packages"
	for pkg in "${apt_deps_to_remove[@]}"; do
		echo "=> removing $pkg"
		if is_apt_installed $pkg; then
			sudo apt remove -y $pkg
		fi
	done
}
