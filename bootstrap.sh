#!/usr/bin/env bash

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
install_apt_packages
cleanup_apt

configure_homebrew
install_homebrew_packages
cleanup_homebrew

configure_flatpak
install_flatpak_packages
cleanup_flatpak

echo -e "\nSource brew installed binaries"
eval "$($brewbin shellenv)"

# echo -e "\nInstall dnf packages"
# source $(dirname $0)/installers/dnf.sh

echo -e "\nStow dotfiles"
stow .

echo -e "\nModify .ssh folder"
chmod 600 ~/.ssh/*

echo -e "\nUse zsh as default shell"
if [ "$SHELL" != "$(which zsh)" ]; then
	grep -qxF "$(which zsh)" "/etc/shells" || sudo bash -c "echo $(which zsh) >> /etc/shells"
	chsh -s "$(which zsh)" "$(whoami)"
fi
