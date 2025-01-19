## =========================================
## Setup zsh
## =========================================

autoload -Uz compinit && compinit

ZINIT_HOME="${XDG_DATA_HOME:-${HOME}/.local/share}/zinit/zinit.git"
# Download Zinit, if it's not there yet
if [ ! -d "$ZINIT_HOME" ]; then
	mkdir -p "$(dirname $ZINIT_HOME)"
	git clone https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME"
fi

source "${ZINIT_HOME}/zinit.zsh"

zinit light ohmyzsh/ohmyzsh
zinit ice depth=1
zinit snippet OMZP::aliases
zinit snippet OMZP::alias-finder
zinit snippet OMZP::bun
zinit snippet OMZP::command-not-found
zinit snippet OMZP::common-aliases
zinit snippet OMZP::git
zinit snippet OMZP::golang
zinit snippet OMZP::yarn
zinit snippet OMZP::docker
zinit snippet OMZP::docker-compose

zinit light ntnyq/omz-plugin-bun
zinit light ntnyq/omz-plugin-pnpm
zinit light zsh-users/zsh-completions
zinit light zsh-users/zsh-autosuggestions
zinit light zsh-users/zsh-syntax-highlighting

## =========================================
## User Config
## =========================================

# Prefer NG English and use UTF-8.
export LANG=en_NG.UTF-8
export LC_ALL=en_NG.UTF-8

## Add .local/bin to path
if [ -d "$HOME/.local/bin" ]; then
	export PATH="$HOME/.local/bin:$PATH"
fi

## Add rust cargo's to path
if [ -d "$HOME/.cargo/bin" ]; then
	export PATH="$HOME/.cargo/bin:$PATH"
fi

## Add go pkg's to path
if [ -d "$HOME/go/bin" ]; then
	export PATH="$HOME/go/bin:$PATH"
fi

# todo(kayandra): research this
# export NODE_COMPILE_CACHE=~/.cache/nodejs-compile-cache

# Preferred editor for local and remote sessions
export EDITOR="code"

# Don’t clear the screen after quitting a manual page.
export MANPAGER="less -X"

## kitty
export TERM=xterm-256color

## =========================================
## Aliases
## =========================================

alias ls="eza"  # exa is a fancy ls alternative
alias cat="bat" # fancy cat alternative
alias zrc="$EDITOR ~/.zshrc"

## =========================================
## Custom stuffs
## =========================================

## Homebrew
eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"

## Starship prompt
eval "$(starship init zsh)"

## zoxide
eval "$(zoxide init --cmd cd zsh)"

## fzf
source <(fzf --zsh)
export FZF_DEFAULT_OPTS="--layout reverse --inline-info"

## fnm
eval "$(fnm env --use-on-cd)"

## =========================================
### Deferred
## =========================================
alias lt="$FNM_MULTISHELL_PATH/bin/lt" ## this is necessary to override exa's `lt` alias

# bun completions
[ -s "$HOME/.bun/_bun" ] && source "$HOME/.bun/_bun"

export PKG_CONFIG_PATH=/usr/lib/x86_64-linux-gnu/pkgconfig:$PKG_CONFIG_PATH

# Always set docker host
export DOCKER_HOST=$(docker context inspect | jq -r '.[0].Endpoints.docker.Host')
