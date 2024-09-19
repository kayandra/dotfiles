#!/usr/bin/env bash

# todo: install vscode. can't use flatpak due to isolation affecting apc extension
# todo: set blackbox as default terminal
# todo: switch back to kitty, and add installation steps for it
# todo: docker-desktop https://medium.com/@selvamraju007/how-to-install-docker-desktop-on-ubuntu-22-04-1ebe4b2f8a14
# todo: tableplus
# todo: tunneling with warp, dns with nextdns, vpn with surfshark

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

echo -e "\nModify .ssh folder"
chmod 600 ~/.ssh/*

echo -e "\nUse zsh as default shell"
if [ "$SHELL" != "$(which zsh)" ]; then
	grep -qxF "$(which zsh)" "/etc/shells" || sudo bash -c "echo $(which zsh) >> /etc/shells"
	chsh -s "$(which zsh)" "$(whoami)"
fi
