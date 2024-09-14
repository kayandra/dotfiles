#!/usr/bin/env bash

# todo: install vscode
# todo: install docker-desktop
# todo: set blackbox as default terminal

set -e

# Ensure we are in the dotfiles directory
cd ~/dotfiles

# Import helpers
source $(dirname $0)/installers/common.sh

# Import installers
source $(dirname $0)/installers/apt.sh
source $(dirname $0)/installers/brew.sh
source $(dirname $0)/installers/flatpak.sh

###########################################################
## Scripting starts here
###########################################################

echo "[[Installing Dependencies]]"

configure_apt
configure_homebrew
configure_flatpak

install_apt_packages
install_homebrew_packages
install_flatpak_packages

cleanup_apt
cleanup_homebrew
cleanup_flatpak

echo -e "\nSource brew installed binaries"
eval "$($brewbin shellenv)"

echo -e "\nStow dotfiles"
stow .

echo -e "\nUse zsh as default shell"
if [ "$SHELL" != "$(which zsh)" ]; then
	grep -qxF "$(which zsh)" "/etc/shells" || sudo bash -c "echo $(which zsh) >> /etc/shells"
	chsh -s "$(which zsh)" "$(whoami)"
fi
