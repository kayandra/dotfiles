#!/usr/bin/env bash

flatpak_packages=(
	"com.brave.Browser"
	"org.mozilla.firefox"
	"com.obsproject.Studio"
	"com.getpostman.Postman"
	"com.spotify.Client"
	"com.slack.Slack"
	"com.discordapp.Discord"
	"org.telegram.desktop"
	# "io.mpv.Mpv"
	"md.obsidian.Obsidian"
	"org.freedownloadmanager.Manager"
	"dev.geopjr.Calligraphy"
	"com.redis.RedisInsight"
	"io.podman_desktop.PodmanDesktop"
	"io.beekeeperstudio.Studio"
)

configure_flatpak() {
	echo -e "\nAdd flathub repository"
	flatpak remote-add --user --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo
}

install_flatpak_packages() {
	echo -e "\nInstall flatpak packages"
	for pkg in "${flatpak_packages[@]}"; do
		echo "=> configuring $pkg"
		if ! is_flatpak_installed $pkg; then
			flatpak install -y --noninteractive flathub $pkg
		fi
	done
}

cleanup_flatpak() {
	echo -e "\nUpdate flatpak packages"
	flatpak update -y
}
