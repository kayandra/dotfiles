#!/usr/bin/env bash

flatpak_packages=(
	"com.brave.Browser"
	"org.mozilla.firefox"
	"com.bitwarden.desktop"
	"com.obsproject.Studio"
	"com.getpostman.Postman"
	"com.raggesilver.BlackBox"
	"com.spotify.Client"
	"com.slack.Slack"
	"com.discordapp.Discord"
	"io.mpv.Mpv"
	"org.gnome.Geary"
	"md.obsidian.Obsidian"
	"org.freedownloadmanager.Manager"
	"com.github.johnfactotum.Foliate"
	"dev.geopjr.Calligraphy"
	"com.redis.RedisInsight"
	"com.ticktick.TickTick"
	"io.defn.Franz" # kafka
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
