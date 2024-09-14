#!/usr/bin/env bash

declare -A brew_packages_to_package_tap

required_apt_deps=(
	"build-essential"
	"software-properties-common"
	"gnome-shell-extensions"
	"gnome-tweaks"
	"cosmic-store"
)

brew_packages_to_install=(
	"zsh"
	"grep"
	"wget"
	"stow"
	"git"
	"git-lfs"
	"gcc"
	"cmake"
	"pkg-config"
	"ffmpeg"
	"starship"
	"cloc"
	"ssh-copy-id"
	"tree"
	"bat"
	"eza"
	"zoxide"
	"fzf"
	"delta"
	"flyctl"
	"trivy"

	# Programming languages
	"go"
	"fnm"
	"rust"
	"zig"
)

# Brew kegs to tap
brew_packages_to_package_tap["bun"]="oven-sh/bun"

# junk apt binaries to uninstall
junk_deps_to_remove=(
	"pop-shop"
)

###########################################################
## Scripting starts here
###########################################################

# Ensure we are in the dotfiles directory
cd ~/dotfiles

# Defer brew cleanup
HOMEBREW_NO_INSTALL_CLEANUP=true

# brew binary fullpath
linuxbrew="/home/linuxbrew/.linuxbrew/bin/brew"

# Helper functions
is_apt_installed() {
	[ $(dpkg-query -W -f='${Status}' $1 2>/dev/null | grep -c "ok installed") -eq 1 ]
}

is_brew_installed() {
	$brew list $1 &>/dev/null && true
}

is_command_installed() {
	command -v $1 &>/dev/null && true
}

liner() {
	echo ">>> $1"
}

# Install homebrew
liner "configuring homebrew"
if [ ! -f "$linuxbrew" ]; then
	/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi

# Temporary brew alias
if ! is_command_installed brew; then brew="$linuxbrew"; else brew="$(which brew)"; fi

# Install appimagelauncher
liner "configuring appimagelauncher"
if ! is_apt_installed appimagelauncher; then
	sudo add-apt-repository -yes ppa:appimagelauncher-team/stable
	sudo apt update
	sudo apt install -yes appimagelauncher
fi

# Install font-manager
liner "configuring font-manager"
if ! is_apt_installed font-manager; then
	sudo add-apt-repository -yes ppa:font-manager/staging
	sudo apt update
	sudo apt install -yes font-manager
fi

# Install required apt dependencies
for pkg in "${required_apt_deps[@]}"; do
	liner "configuring $pkg"
	if ! is_apt_installed $pkg; then
		sudo apt install -yes $pkg
	fi
done

# Install brew casks
for pkg in "${brew_packages_to_install[@]}"; do
	liner "configuring $pkg"
	if ! is_brew_installed $pkg; then
		$brew install --force $pkg
	fi
done

# Install brew casks
for key in ${!brew_packages_to_package_tap[@]}; do
	liner "configuring $key"
	if ! is_brew_installed $key; then
		$brew tap ${arr[${key}]}
		$brew install --force $key
	fi
done

# Remove junk binaries
for pkg in "${junk_deps_to_remove[@]}"; do
	liner "removing bloatware $pkg"
	if is_apt_installed $pkg; then
		sudo apt remove -yes $pkg
	fi
done

# Source brew binaries
eval "$($brew shellenv)"

# Symlink dotfiles
stow .

# Use zsh as default shell
if [ "$SHELL" != "$(which zsh)" ]; then
	grep -qxF "$(which zsh)" "/etc/shells" || sudo bash -c "echo $(which zsh) >> /etc/shells"
	chsh -s "$(which zsh)" "$(whoami)"
fi

# Remove outdated versions from the cellar.
$brew cleanup
