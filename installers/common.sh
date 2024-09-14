#!/usr/bin/env bash

declare brewbin

is_apt_installed() {
	[ $(dpkg-query -W -f='${Status}' $1 2>/dev/null | grep -c "ok installed") -eq 1 ]
}

is_brew_installed() {
	$brewbin list $1 &>/dev/null && true
}

is_command_installed() {
	command -v $1 &>/dev/null && true
}

is_flatpak_installed() {
	[ $(flatpak list --app | grep -c $1) -eq 1 ]
}
