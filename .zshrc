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

## Extra rustup components: rust-analyzer for the rust-analyzer-lsp claude
## plugin, rust-src so it can see into std, llvm-tools for cargo-llvm-cov.
## ~/.cargo/bin has proxies whether or not a component is installed, so ask
## rustup rather than checking for a command.
ZSHRC_RUSTUP_COMPONENTS=(
	rust-analyzer
	rust-src
	llvm-tools
)
if command -v rustup &>/dev/null; then
	_rust_installed=$(rustup component list --installed 2>/dev/null)
	_rust_missing=()
	for _c in "${ZSHRC_RUSTUP_COMPONENTS[@]}"; do
		grep -q "^$_c" <<<"$_rust_installed" || _rust_missing+=("$_c")
	done
	if (( ${#_rust_missing[@]} )); then
		echo "[zshrc] installing rustup components: ${_rust_missing[*]}"
		rustup component add "${_rust_missing[@]}"
	fi
	unset _rust_installed _rust_missing _c
fi

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
	## Language servers for the typescript-lsp and pyright-lsp claude plugins.
	if command -v npm &>/dev/null && { ! command -v typescript-language-server &>/dev/null || ! command -v pyright &>/dev/null; }; then
		echo "[zshrc] installing typescript and python language servers..."
		npm install --global --no-audit --no-fund typescript typescript-language-server pyright
	fi
fi

## Claude writes its plugin cache, sessions and transcripts to ~/.claude. If
## stow folded that directory into a symlink (it does when ~/.claude did not
## exist before `stow .`), all of it lands inside the dotfiles repo. Unfold:
## make ~/.claude a real directory, move everything except skills out of the
## repo, and link skills back the way stow would.
zshrc_unfold_claude_dir() {
	[[ -L "$HOME/.claude" ]] || return 0
	local target entry
	target=$(cd "$HOME/.claude" 2>/dev/null && pwd -P) || return 0
	echo "[zshrc] ~/.claude is a symlink into $target — unfolding so claude state stays out of the repo"
	unlink "$HOME/.claude" && mkdir -p "$HOME/.claude" || return 1
	# (N): a pattern with no matches expands to nothing instead of aborting
	# the loop, which zsh does by default and bash does not.
	for entry in "$target"/*(N) "$target"/.[!.]*(N); do
		[[ "${entry:t}" == skills ]] && continue
		mv "$entry" "$HOME/.claude/"
	done
	if [[ -d "$target/skills" ]]; then
		if [[ "${target:h:h}" == "$HOME" ]]; then
			ln -s "../${target:h:t}/.claude/skills" "$HOME/.claude/skills" # relative, as stow makes it
		else
			ln -s "$target/skills" "$HOME/.claude/skills"
		fi
	fi
}
zshrc_unfold_claude_dir

## AI CLIs: native installers.
if ! command -v claude &>/dev/null; then
	echo "[zshrc] installing claude..."
	curl -fsSL https://claude.ai/install.sh | bash
fi
if ! command -v codex &>/dev/null; then
	echo "[zshrc] installing codex..."
	# Install only: suppress prompts such as "Start Codex now? [y/N]".
	curl -fsSL https://chatgpt.com/codex/install.sh | CODEX_NON_INTERACTIVE=1 sh
fi
export PATH="$HOME/.strix/bin:$PATH"
if ! command -v strix &>/dev/null; then
	echo "[zshrc] installing strix..."
	curl -sSL https://strix.ai/install | bash
fi

## Claude plugins from the official marketplace, user scope. Installed
## plugins live in ~/.claude/plugins (not in the dotfiles), so install any
## that are missing. Auth for the MCP-backed ones is a one-time /mcp login.
ZSHRC_CLAUDE_PLUGINS=(
	slack
	linear
	chrome-devtools-mcp
	gopls-lsp
	clangd-lsp
	rust-analyzer-lsp
	typescript-lsp
	pyright-lsp
)
if command -v claude &>/dev/null; then
	_plugins_missing=()
	for _plugin in "${ZSHRC_CLAUDE_PLUGINS[@]}"; do
		[[ -d "$HOME/.claude/plugins/cache/claude-plugins-official/$_plugin" ]] || _plugins_missing+=("$_plugin")
	done
	if (( ${#_plugins_missing[@]} )); then
		# A fresh machine has no marketplaces at all, so add the official one;
		# an existing copy may be stale and not know newer plugins, so update it.
		if claude plugin marketplace list 2>/dev/null | grep -q 'claude-plugins-official'; then
			echo "[zshrc] updating claude plugin marketplace..."
			claude plugin marketplace update claude-plugins-official
		else
			echo "[zshrc] adding claude plugin marketplace..."
			claude plugin marketplace add anthropics/claude-plugins-official
		fi
		for _plugin in "${_plugins_missing[@]}"; do
			echo "[zshrc] installing claude plugin: $_plugin"
			claude plugin install -y -s user "$_plugin@claude-plugins-official"
		done
	fi
	unset _plugin _plugins_missing
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
