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

zinit light ntnyq/omz-plugin-bun
zinit light ntnyq/omz-plugin-pnpm
zinit light zsh-users/zsh-completions
zinit light zsh-users/zsh-autosuggestions
zinit light zsh-users/zsh-syntax-highlighting

## =========================================
## User configuration
## =========================================

# You may need to manually set your language environment
export LANG=en_NG.UTF-8
export LC_ALL=en_NG.UTF-8

## Add .local/bin to path
export PATH="$HOME/.local/bin:$PATH"

# Preferred editor for local and remote sessions
# if [[ -n $SSH_CONNECTION ]]; then
#   export EDITOR='vim'
# else
#   export EDITOR='mvim'
# fi

## Example aliases
alias ls="exa"
alias cat="batcat"
alias zrc="vim ~/.zshrc"

## Homebrew
eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"

## Starship prompt
eval "$(starship init zsh)"

## zoxide
eval "$(zoxide init --cmd cd zsh)"

## fzf
source <(fzf --zsh)
export FZF_DEFAULT_OPTS='--layout reverse --border top --inline-info'

## fnm
export PATH="$HOME/.local/share/fnm:$PATH"
eval "$(fnm env --use-on-cd)"

## Golang
export PATH=$PATH:/usr/local/go/bin
export PATH=$PATH:$HOME/go/bin

## Zig
export PATH=$PATH:/usr/local/zig

## bun completions
[ -s "$HOME/.bun/_bun" ] && source "$HOME/.bun/_bun"

## bun
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"

## Android
export ANDROID_HOME=$HOME/Android/Sdk
export PATH=$PATH:$ANDROID_HOME/tools
export PATH=$PATH:$ANDROID_HOME/platform-tools

## Rust
source "$HOME/.cargo/env"

## SUI
export PATH=$PATH:~/sui
alias sui-prover="docker-compose -f ~/workspace/prover/compose.yaml up"

## Fly.io
export FLYCTL_INSTALL="$HOME/.fly"
export PATH="$FLYCTL_INSTALL/bin:$PATH"

## kitty
export TERM=xterm-256color
