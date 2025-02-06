sudo dnf copr enable jerrycasiano/FontManager
sudo dnf install font-manager

fnm install v23.7.0
#npm install -g pnpm npm yarn

sudo dnf -y install dnf-plugins-core
sudo dnf-3 config-manager --add-repo https://download.docker.com/linux/fedora/docker-ce.repo
sudo dnf install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
sudo systemctl enable --now docker

if [ ! -f "docker-desktop-x86_64.rpm" ]; then
	wget https://desktop.docker.com/linux/main/amd64/docker-desktop-x86_64.rpm
fi
if [ -f "docker-desktop-x86_64.rpm" ]; then
	sudo dnf install ./docker-desktop-x86_64.rpm
	rm ./docker-desktop-x86_64.rpm
fi
