#!/bin/bash
set -euo pipefail

echo "🚀 Setting up environment (stable China-friendly version)..."

# ----------------------------
# paths
# ----------------------------
DOTFILES_DIR="$(cd "$(dirname "$0")" && pwd)"

# ----------------------------
# check tools
# ----------------------------
for cmd in curl git zsh; do
	if ! command -v "$cmd" >/dev/null 2>&1; then
		echo "❌ $cmd is required"
		exit 1
	fi
done

# ----------------------------
# network layer (safe version)
# ----------------------------

GH_PROXY="https://ghproxy.com/"

is_github() {
	[[ "$1" == https://github.com/* || "$1" == https://raw.githubusercontent.com/* ]]
}

proxy_url() {
	local url="$1"
	if is_github "$url"; then
		echo "${GH_PROXY}${url}"
	else
		echo "$url"
	fi
}

curl_smart() {
	local url="$1"
	local out="${2:-}"

	url="$(proxy_url "$url")"

	if [ -n "$out" ]; then
		curl -fsSL --retry 3 --retry-delay 2 --connect-timeout 10 "$url" -o "$out"
	else
		curl -fsSL --retry 3 --retry-delay 2 --connect-timeout 10 "$url"
	fi
}

git_smart_clone() {
	local repo="$1"
	local dir="$2"

	local real_repo="$repo"

	if is_github "$repo"; then
		real_repo="${GH_PROXY}${repo}"
	fi

	if [ ! -d "$dir/.git" ]; then
		rm -rf "$dir"
		git clone "$real_repo" "$dir"
	else
		echo "✔ exists: $dir"
	fi
}

# ----------------------------
# dotfiles check
# ----------------------------
if [ ! -d "$HOME/dotfiles" ]; then
	echo "❌ ~/dotfiles not found"
	exit 1
fi

# ----------------------------
# symlink helper
# ----------------------------
link_item() {
	src="$1"
	dst="$2"

	if [ -e "$dst" ] && [ ! -L "$dst" ]; then
		echo "⚠️ skip $dst (exists)"
	elif [ -L "$dst" ]; then
		ln -sfn "$src" "$dst"
	else
		ln -s "$src" "$dst"
	fi
}

# ----------------------------
# config symlinks
# ----------------------------
echo "📁 Linking dotfiles..."

mkdir -p "$HOME/.config"

if [ -d "$DOTFILES_DIR/.config" ]; then
	for item in "$DOTFILES_DIR/.config/"*; do
		[ -e "$item" ] || continue
		target="$HOME/.config/$(basename "$item")"
		link_item "$item" "$target"
	done
fi

echo "✅ dotfiles done"

# ----------------------------
# zsh setup
# ----------------------------
echo "🚀 setting up zsh..."

if [ ! -d "$HOME/.oh-my-zsh" ]; then
	echo "📦 installing oh-my-zsh..."

	TMP_OMZ="/tmp/install_omz.sh"

	curl_smart \
		https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh \
		"$TMP_OMZ"

	chmod +x "$TMP_OMZ"

	sh "$TMP_OMZ" "" --unattended

	rm -f "$TMP_OMZ"
fi

ZSH_CUSTOM="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}"

git_smart_clone \
	https://github.com/zsh-users/zsh-autosuggestions \
	"$ZSH_CUSTOM/plugins/zsh-autosuggestions"

git_smart_clone \
	https://github.com/zsh-users/zsh-syntax-highlighting \
	"$ZSH_CUSTOM/plugins/zsh-syntax-highlighting"

# ----------------------------
# zshrc
# ----------------------------
echo "🔗 linking zshrc..."

rm -f "$HOME/.zshrc"
link_item "$DOTFILES_DIR/zsh/.zshrc" "$HOME/.zshrc"

# ----------------------------
# bash configs
# ----------------------------
link_item "$DOTFILES_DIR/bash/.bashrc" "$HOME/.bashrc"
link_item "$DOTFILES_DIR/bash/.bash_profile" "$HOME/.bash_profile"

# ----------------------------
# ssh config
# ----------------------------
echo "🔐 ssh config..."

mkdir -p "$HOME/.ssh"

SSH_SRC="$DOTFILES_DIR/.ssh/config"
SSH_DST="$HOME/.ssh/config"

if [ -f "$SSH_SRC" ]; then
	if [ -e "$SSH_DST" ] && [ ! -L "$SSH_DST" ]; then
		echo "⚠️ ssh config exists"
	elif [ -L "$SSH_DST" ]; then
		ln -sfn "$SSH_SRC" "$SSH_DST"
	else
		ln -s "$SSH_SRC" "$SSH_DST"
	fi
fi

echo "🎉 DONE. restart terminal."