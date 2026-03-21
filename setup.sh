#!/bin/bash
set -euo pipefail

echo "🚀 Setting up environment..."

# ----------------------------
# resolve dotfiles path
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
# check dotfiles
# ----------------------------
if [ ! -d "$HOME/dotfiles" ]; then
	echo "❌ ~/dotfiles not found"
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
# install oh-my-zsh
# ----------------------------
echo "🚀 Setting up zsh environment..."

if [ ! -d "$HOME/.oh-my-zsh" ]; then
	echo "📦 Installing Oh My Zsh..."
	sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
fi

ZSH_CUSTOM=${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}

git_clone_if_missing() {
	local repo="$1"
	local dir="$2"

	if [ ! -d "$dir/.git" ]; then
		rm -rf "$dir"
		git clone "$repo" "$dir"
	fi
}

git_clone_if_missing \
	https://github.com/zsh-users/zsh-autosuggestions \
	"$ZSH_CUSTOM/plugins/zsh-autosuggestions"

git_clone_if_missing \
	https://github.com/zsh-users/zsh-syntax-highlighting \
	"$ZSH_CUSTOM/plugins/zsh-syntax-highlighting"

# ----------------------------
# zsh config
# ----------------------------
echo "🔗 Replacing ~/.zshrc with dotfiles version..."

if [ -e "$HOME/.zshrc" ] || [ -L "$HOME/.zshrc" ]; then
	echo "🧹 Removing existing ~/.zshrc"
	rm -f "$HOME/.zshrc"
fi
link_item "$DOTFILES_DIR/.zshrc" "$HOME/.zshrc"
# link_item "$DOTFILES_DIR/.zprofile" "$HOME/.zprofile"

echo "If zsh is not your default shell, you can change it with:"
echo "chsh -s $(which zsh)"
echo "✅ Setup complete! Please restart your terminal."
