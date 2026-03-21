#!/bin/bash
set -euo pipefail

echo "🚀 Setting up environment..."

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
# config symlinks
# ----------------------------
echo "📁 Setting up dotfiles..."
mkdir -p "$HOME/.config"

if [ -d "$HOME/dotfiles/.config" ]; then
	for item in "$HOME/dotfiles/.config/"*; do
		[ -e "$item" ] || continue

		target="$HOME/.config/$(basename "$item")"

		if [ -e "$target" ] && [ ! -L "$target" ]; then
			echo "⚠️ skipping $target (exists and not symlink)"
		else
			ln -sfn "$item" "$target"
		fi
	done
fi

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
ln -sfn "$HOME/dotfiles/.zshrc" "$HOME/.zshrc"
ln -sfn "$HOME/dotfiles/.zprofile" "$HOME/.zprofile"

echo "If zsh is not your default shell, you can change it with:"
echo "chsh -s $(which zsh)"
echo "✅ Setup complete! Please restart your terminal."