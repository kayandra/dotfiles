#!/usr/bin/env bash

homebrew_packages=(
	"zsh"
	"curl"
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
	"graphviz"
	"tmux"
	"k6"

	# Programming languages
	"go"
	"golines"
	"gofumpt"
	"fnm"
	"rust"
	"rustfmt"
	"zig"
)

declare -A homebrew_packages_taps
homebrew_packages_taps+=(
	["bun"]="oven-sh/bun"
)

# Defer brew cleanup
HOMEBREW_NO_INSTALL_CLEANUP=true

# brew binary fullpath
linuxbrew="/home/linuxbrew/.linuxbrew/bin/brew"

configure_homebrew() {
	# Temporary brew alias
	if ! is_command_installed brew; then
		brewbin="$linuxbrew"
	else
		brewbin="$(which brew)"
	fi

	# Install or update
	if [ ! -f "$linuxbrew" ]; then
		echo -e "\nInstall homebrew"
		/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
	else
		echo -e "\nUpdate homebrew"
		$brewbin update
	fi
}

install_homebrew_packages() {
	echo -e "\nInstall homebrew packages"
	for pkg in "${homebrew_packages[@]}"; do
		echo "=> configuring $pkg"
		if ! is_brew_installed $pkg; then
			$brewbin install --force $pkg
		fi
	done

	# Install brew casks
	for key in ${!homebrew_packages_taps[@]}; do
		echo "=> configuring $key"
		if ! is_brew_installed $key; then
			$brewbin tap ${homebrew_packages_taps[${key}]}
			$brewbin install --force $key
		fi
	done
}

cleanup_homebrew() {
	echo -e "\nUpgrade homebrew packages"
	$brewbin upgrade

	echo -e "\nCleanup homebrew packages"
	$brewbin cleanup
}
