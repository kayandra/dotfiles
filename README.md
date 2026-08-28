# Dotfiles

This directory contains the dotfiles for my system. `.zshrc` installs
everything it needs the first time it runs.

## Requirements

On linux, brew needs a compiler before it can install itself:

```bash
sudo apt install -y build-essential curl git
```

Then on both:

```bash
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
eval "$($(ls /opt/homebrew/bin/brew /home/linuxbrew/.linuxbrew/bin/brew 2>/dev/null | head -1) shellenv)"
brew install zsh stow
```

## SSH key

The repo is cloned over SSH and commits are signed with the same key, so
this comes first:

```bash
ssh-keygen -t ed25519
echo "5002506+kayandra@users.noreply.github.com namespaces=\"git\" $(cat ~/.ssh/id_ed25519.pub)" > ~/.ssh/allowed_signers
```

Add the public key to GitHub twice, once as an authentication key and once as
a signing key. They are separate lists.

## Installation

Check out the repo in your $HOME directory, stow it and make zsh the default
shell:

```bash
git clone git@github.com:kayandra/dotfiles.git ~/dotfiles
cd ~/dotfiles && stow .
chsh -s "$(which zsh)"
```

Open a new terminal. The first one takes a few minutes while the tools and
the zsh plugins install.

## Adding tools

Add a `command:formula` line to `ZSHRC_TOOLS` in `.zshrc`. It gets installed
the next time you open a shell.
