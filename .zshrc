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
## User Config
## =========================================

# Prefer NG English and use UTF-8.
export LANG=en_NG.UTF-8
export LC_ALL=en_NG.UTF-8

## Add .local/bin to path
export PATH="$HOME/.local/bin:$PATH"

# Preferred editor for local and remote sessions
export EDITOR="code"

# Don’t clear the screen after quitting a manual page.
export MANPAGER="less -X"

## kitty
export TERM=xterm-256color

## =========================================
## Aliases
## =========================================

alias ls="exa"     # fancy ls alternative
alias cat="batcat" # fancy cat alternative
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
