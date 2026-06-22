#!/bin/bash
set -euo pipefail

echo "🚀 Setting up environment..."

# ----------------------------
# options
# ----------------------------
GITHUB_PROXY=""

while [ "$#" -gt 0 ]; do
	case "$1" in
	--proxy)
		GITHUB_PROXY="https://gh-proxy.org/"
		;;
	-h | --help)
		echo "Usage: bash setup.sh [--proxy]"
		exit 0
		;;
	*)
		echo "❌ Unknown option: $1"
		echo "Usage: bash setup.sh [--proxy]"
		exit 1
		;;
	esac
	shift
done

# ----------------------------
# resolve dotfiles path
# ----------------------------
DOTFILES_DIR="$(cd "$(dirname "$0")" && pwd)"

# ----------------------------
# check tools
# ----------------------------
for cmd in git zsh; do
	if ! command -v "$cmd" >/dev/null 2>&1; then
		echo "❌ $cmd is required"
		exit 1
	fi
done

if [ ! -d "$DOTFILES_DIR/zsh" ] || [ ! -d "$DOTFILES_DIR/.config" ]; then
	echo "❌ Invalid dotfiles directory: $DOTFILES_DIR"
	exit 1
fi

# ----------------------------
# helpers
# ----------------------------
link_item() {
	src="$1"
	dst="$2"

	if [ -e "$dst" ] && [ ! -L "$dst" ]; then
		echo "⚠️  skip $dst (exists and not symlink)"
	elif [ -L "$dst" ]; then
		echo "🔄 update symlink $dst"
		ln -sfn "$src" "$dst"
	else
		echo "🔗 link $dst -> $src"
		ln -s "$src" "$dst"
	fi
}

set_default_shell() {
	local zsh_path
	zsh_path="$(command -v zsh)"

	if [ "${SHELL:-}" = "$zsh_path" ]; then
		echo "✅ Zsh is already the default shell"
		return 0
	fi

	if ! grep -Fxq "$zsh_path" /etc/shells; then
		echo "🔧 Registering $zsh_path in /etc/shells..."
		printf '%s\n' "$zsh_path" | sudo tee -a /etc/shells >/dev/null
	fi

	echo "🐚 Setting Zsh as the default shell..."
	chsh -s "$zsh_path"
	echo "✅ Default shell changed to $zsh_path"
}

# ----------------------------
# config symlinks
# ----------------------------
echo "📁 Setting up dotfiles..."
mkdir -p "$HOME/.config"

if [ -d "$DOTFILES_DIR/.config" ]; then
	for item in "$DOTFILES_DIR/.config/"*; do
		[ -e "$item" ] || continue

		target="$HOME/.config/$(basename "$item")"
		link_item "$item" "$target"
	done
fi

echo "✅ Dotfiles setup complete!"
echo "⚠️ Skipped existing files that are not symlinks. Delete or backup those files and rerun the script to link them."

# ----------------------------
# zsh plugins
# ----------------------------
ZSH_PLUGINS="$HOME/.zsh/plugins"

mkdir -p "$ZSH_PLUGINS"

# ----------------------------
# helper
# ----------------------------
git_clone_if_missing() {
	local repo="$1"
	local dir="$2"

	if [ ! -d "$dir" ]; then
		echo "📦 Cloning $(basename "$repo")..."
		git clone "$repo" "$dir"
	else
		echo "✅ Exists: $(basename "$repo")"
	fi
}

# ----------------------------
# plugins
# ----------------------------

git_clone_if_missing \
	"${GITHUB_PROXY}https://github.com/zsh-users/zsh-autosuggestions" \
	"$ZSH_PLUGINS/zsh-autosuggestions"

git_clone_if_missing \
	"${GITHUB_PROXY}https://github.com/zsh-users/zsh-syntax-highlighting" \
	"$ZSH_PLUGINS/zsh-syntax-highlighting"

# ----------------------------
# zsh config
# ----------------------------
echo "🔗 Setting up ~/.zshrc..."
link_item "$DOTFILES_DIR/zsh/.zshrc" "$HOME/.zshrc"

set_default_shell
echo "✅ Setup complete! Please restart your terminal."

echo "Link other shell config..."
link_item "$DOTFILES_DIR/bash/.bashrc" "$HOME/.bashrc"
link_item "$DOTFILES_DIR/bash/.bash_profile" "$HOME/.bash_profile"
