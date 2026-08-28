## =========================================
## Homebrew (macOS) / Linuxbrew (Linux)
## =========================================
## Installs Homebrew if missing, then puts it on PATH. Everything else in this
## file is installed through it, so this block must run first.
if [[ "$OSTYPE" == darwin* ]]; then
	BREW_BIN="/opt/homebrew/bin/brew"
else
	BREW_BIN="/home/linuxbrew/.linuxbrew/bin/brew"
fi

if [[ ! -x "$BREW_BIN" ]]; then
	echo "[zshrc] installing homebrew..."
	if [[ "$OSTYPE" != darwin* ]]; then
		for dep in curl git gcc; do
			command -v "$dep" &>/dev/null || echo "[zshrc] linuxbrew needs '$dep' — install it first (apt: build-essential curl git)"
		done
	fi
	NONINTERACTIVE=1 /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi

[[ -x "$BREW_BIN" ]] && eval "$("$BREW_BIN" shellenv zsh)"

## =========================================
## Tools this file depends on
## =========================================
## "command:formula" — the command we check for, and the brew formula that
## provides it. Only calls brew when something is actually missing, so on a
## normal shell start this costs a handful of `command -v` lookups.
ZSHRC_TOOLS=(
	starship:starship # prompt
	eza:eza           # ls
	bat:bat           # cat
	zoxide:zoxide     # cd
	fzf:fzf           # fuzzy finder
	delta:git-delta   # git pager (.gitconfig)
	git-lfs:git-lfs   # git lfs filter (.gitconfig)
	jq:jq             # DOCKER_HOST below
	gh:gh             # github cli
	stow:stow         # dotfiles
	cloc:cloc         # count lines of code
	k6:k6             # load testing
	buf:buf           # protobuf tooling
)

zshrc_install_missing() {
	command -v brew &>/dev/null || return

	local missing=() entry cmd formula
	for entry in "${ZSHRC_TOOLS[@]}"; do
		cmd="${entry%%:*}"
		formula="${entry##*:}"
		command -v "$cmd" &>/dev/null || missing+=("$formula")
	done
	if (( ${#missing[@]} )); then
		echo "[zshrc] installing: ${missing[*]}"
		brew install "${missing[@]}"
	fi
}
zshrc_install_missing

## =========================================
## Load dependencies
## =========================================
## fnm: official installer into ~/.local/share/fnm; --skip-shell so it does
## not append to this file.
export PATH="$HOME/.local/share/fnm:$PATH"
if ! command -v fnm &>/dev/null; then
	echo "[zshrc] installing fnm..."
	curl -fsSL https://fnm.vercel.app/install | bash -s -- --skip-shell --force-no-brew --install-dir "$HOME/.local/share/fnm"
fi

command -v starship &>/dev/null && eval "$(starship init zsh)"
command -v fnm &>/dev/null && eval "$(fnm env --use-on-cd)"

## =========================================
## Language toolchains
## =========================================
## Rust: the official installer, into ~/.cargo/bin.
## brew's rustup formula keeps cargo in its own prefix instead, so not that.
## Stable is the global default; a project that needs nightly says so in its
## own rust-toolchain.toml and cargo picks it up from there.
if [[ ! -x "$HOME/.cargo/bin/cargo" ]]; then
	echo "[zshrc] installing rust (stable)..."
	curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y --no-modify-path --default-toolchain stable
fi
export PATH="$HOME/.cargo/bin:$PATH"

## Rust developer CLIs. "command:crate" — install only when the command is
## missing; --locked uses the dependency versions tested by each release.
ZSHRC_CARGO_GLOBALS=(
	just:just
	bacon:bacon
	cargo-deny:cargo-deny
	cargo-machete:cargo-machete
	cargo-nextest:cargo-nextest
	cargo-llvm-cov:cargo-llvm-cov
	cargo-expand:cargo-expand
	cargo-bloat:cargo-bloat
	cargo-binstall:cargo-binstall
	taplo:taplo-cli
)

if command -v cargo &>/dev/null; then
	for _cargo_entry in "${ZSHRC_CARGO_GLOBALS[@]}"; do
		_cargo_cmd="${_cargo_entry%%:*}"
		_cargo_crate="${_cargo_entry##*:}"
		if ! command -v "$_cargo_cmd" &>/dev/null; then
			echo "[zshrc] installing rust CLI: $_cargo_crate"
			cargo install --locked "$_cargo_crate"
		fi
	done
	unset _cargo_entry _cargo_cmd _cargo_crate
fi

## Go: the official tarball from go.dev, into ~/.local/go instead of the
## documented /usr/local/go so no sudo is needed. Latest version from go.dev.
export GOROOT="$HOME/.local/go"
export PATH="$GOROOT/bin:$HOME/go/bin:$PATH"
if [[ ! -x "$GOROOT/bin/go" ]]; then
	_go_ver=$(curl -fsSL 'https://go.dev/VERSION?m=text' | head -1)
	_go_arch=$(uname -m); [[ "$_go_arch" == x86_64 ]] && _go_arch=amd64; [[ "$_go_arch" == aarch64 ]] && _go_arch=arm64
	_go_os=$([[ "$OSTYPE" == darwin* ]] && echo darwin || echo linux)
	if [[ -n "$_go_ver" ]]; then
		echo "[zshrc] installing $_go_ver ($_go_os/$_go_arch)..."
		mkdir -p "$HOME/.local" \
			&& curl -fsSL "https://go.dev/dl/${_go_ver}.${_go_os}-${_go_arch}.tar.gz" | tar -C "$HOME/.local" -xzf -
	fi
	unset _go_ver _go_arch _go_os
fi

## Bun: official installer into ~/.bun.
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"
if ! command -v bun &>/dev/null; then
	echo "[zshrc] installing bun..."
	curl -fsSL https://bun.sh/install | bash
fi

## uv: official installer into ~/.local/bin.
export PATH="$HOME/.local/bin:$PATH"
if ! command -v uv &>/dev/null; then
	echo "[zshrc] installing uv..."
	curl -LsSf https://astral.sh/uv/install.sh | sh
fi

## Node: latest release via fnm, then keep the package managers current.
if command -v fnm &>/dev/null; then
	if ! command -v node &>/dev/null; then
		echo "[zshrc] installing latest node..."
		fnm install --latest && fnm default latest && fnm use latest
	fi
	if ! command -v pnpm &>/dev/null; then
		echo "[zshrc] ensuring npm, yarn, and pnpm are latest..."
		npm install --global --no-audit --no-fund npm@latest yarn@latest pnpm@latest
	fi
fi

## AI CLIs: native installers, into ~/.local/bin.
if ! command -v claude &>/dev/null; then
	echo "[zshrc] installing claude..."
	curl -fsSL https://claude.ai/install.sh | bash
fi
if ! command -v codex &>/dev/null; then
	echo "[zshrc] installing codex..."
	# Install only: suppress prompts such as "Start Codex now? [y/N]".
	curl -fsSL https://chatgpt.com/codex/install.sh | CODEX_NON_INTERACTIVE=1 sh
fi

## =========================================
## Setup zsh
## =========================================

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

# Loading Oh My Zsh through Zinit can leave these tag helpers wrapped in an
# extra `autoload -X` function frame. Zsh's comptags module tracks tags by call
# depth, so restore them as native autoloads before initializing completion.
unfunction _tags _requested _next_label _all_labels 2>/dev/null
autoload -Uz _tags _requested _next_label _all_labels

# After the plugins, so zsh-completions is on fpath when compinit runs
autoload -Uz compinit && compinit

## =========================================
## User Config
## =========================================

# Prefer en_US.UTF-8
export LANG=en_US.UTF-8
export LC_ALL=en_US.UTF-8

## source .profile
if [ -f "$HOME/.profile" ]; then
	source "$HOME/.profile"
fi

export EDITOR="code --wait" # Preferred editor for local and remote sessions
export MANPAGER="less -X"   # Don’t clear the screen after quitting a manual page.

## =========================================
## Aliases
## =========================================

alias ls="eza"  # exa is a fancy ls alternative
alias cat="bat" # fancy cat alternative
alias zrc="$EDITOR ~/.zshrc"

alias c="claude"
alias cr="claude --resume"
alias cw="claude --worktree"

alias cx="codex"

## =========================================
## Custom stuffs
## =========================================

## fzf
if command -v fzf &>/dev/null; then
	source <(fzf --zsh)
	export FZF_DEFAULT_OPTS="--layout reverse --inline-info"
fi

## =========================================
### Deferred
## =========================================
alias lt="$FNM_MULTISHELL_PATH/bin/lt" ## this is necessary to override exa's `lt` alias

# bun completions
[ -s "$HOME/.bun/_bun" ] && source "$HOME/.bun/_bun"

# pkg-config
export PKG_CONFIG_PATH=/usr/lib/x86_64-linux-gnu/pkgconfig:$PKG_CONFIG_PATH
export PKG_CONFIG_PATH=/opt/homebrew/opt/icu4c/lib/pkgconfig:$PKG_CONFIG_PATH

# Always set docker host (only when docker is present and answers)
if command -v docker &>/dev/null; then
	_docker_host=$(docker context inspect 2>/dev/null | jq -r '.[0].Endpoints.docker.Host' 2>/dev/null)
	[ -n "$_docker_host" ] && [ "$_docker_host" != "null" ] && export DOCKER_HOST="$_docker_host"
	unset _docker_host
fi

# Go setup for Github private repos
export GOPRIVATE=github.com/bitnob/*,github.com/BaytaCo/*

# Disable turborepo telemetry
export TURBO_TELEMETRY_DISABLED=1

## =========================================
## # zoxide (must be at end of .zshrc)
## =========================================
command -v zoxide &>/dev/null && eval "$(zoxide init --cmd cd zsh)"
