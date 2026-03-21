#!/bin/bash
set -euo pipefail

echo "🚀 Setting up environment..."

# ----------------------------
# check tools
# ----------------------------
for cmd in curl git; do
	if ! command -v "$cmd" >/dev/null 2>&1; then
		echo "❌ $cmd is required"
		exit 1
	fi
done

# ----------------------------
# install zsh if missing
# ----------------------------
if ! command -v zsh >/dev/null 2>&1; then
	echo "📦 zsh not found, installing..."

	if command -v apt >/dev/null 2>&1; then
		sudo apt update && sudo apt install -y zsh
	elif command -v dnf >/dev/null 2>&1; then
		sudo dnf install -y zsh
	elif command -v pacman >/dev/null 2>&1; then
		sudo pacman -S --noconfirm zsh
	elif command -v brew >/dev/null 2>&1; then
		brew install zsh
	else
		echo "❌ No supported package manager found"
		exit 1
	fi
fi

echo "✔ zsh: $(which zsh)"

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

# ----------------------------
# set zsh as default shell
# ----------------------------
ZSH_PATH="$(which zsh)"

if [ -n "$ZSH_PATH" ]; then
	if [ "$SHELL" != "$ZSH_PATH" ]; then
		echo "🔧 Setting zsh as default shell..."

		if grep -q "$ZSH_PATH" /etc/shells 2>/dev/null; then
			chsh -s "$ZSH_PATH" "$USER" || echo "⚠️ chsh failed (try manually)"
		else
			echo "⚠️ zsh not in /etc/shells, trying to add..."
			echo "$ZSH_PATH" | sudo tee -a /etc/shells >/dev/null || true
			chsh -s "$ZSH_PATH" "$USER" || echo "⚠️ chsh failed (try manually)"
		fi
	else
		echo "✔ zsh already default shell"
	fi
fi

echo "✅ Done. Please restart terminal or run: exec zsh"