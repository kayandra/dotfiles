#!/usr/bin/env bash

flatpak_packages=(
	"app.zen_browser.zen"
	"com.brave.Browser"
	"com.discordapp.Discord"
	"com.getpostman.Postman"
	"com.obsproject.Studio"
	"com.redis.RedisInsight"
	"com.skype.Client"
	"com.slack.Slack"
	"com.spotify.Client"
	"dev.geopjr.Calligraphy"
	"io.beekeeperstudio.Studio"
	"io.mpv.Mpv"
	"io.podman_desktop.PodmanDesktop"
	"md.obsidian.Obsidian"
	"org.chromium.Chromium"
	"org.freedownloadmanager.Manager"
	# "org.gnome.Extensions"
	"org.telegram.desktop"
)

configure_flatpak() {
	echo -e "\nAdd flathub repository"
	flatpak remote-add --system --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo
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
