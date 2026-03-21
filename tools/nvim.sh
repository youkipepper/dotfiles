#!/bin/bash
set -euo pipefail

echo "🚀 Installing latest Neovim..."

OS="$(uname)"

install_linux() {
	echo "🐧 Detected Linux"

	# 依赖
	sudo apt update
	sudo apt install -y curl git xz-utils

	TMP_DIR=$(mktemp -d)
	cd "$TMP_DIR"

	echo "⬇️ Downloading latest Neovim..."
	curl -LO https://github.com/neovim/neovim/releases/latest/download/nvim-linux64.tar.gz

	echo "📦 Extracting..."
	tar xzf nvim-linux64.tar.gz

	echo "📂 Installing to /opt/nvim..."
	sudo rm -rf /opt/nvim
	sudo mv nvim-linux64 /opt/nvim

	echo "🔗 Linking binary..."
	sudo ln -sf /opt/nvim/bin/nvim /usr/local/bin/nvim

	echo "🧹 Cleanup..."
	rm -rf "$TMP_DIR"
}

install_macos() {
	echo "🍎 Detected macOS"

	if command -v brew >/dev/null 2>&1; then
		echo "📦 Installing via Homebrew..."
		brew install neovim || brew upgrade neovim
	else
		echo "❌ Homebrew not found"
		echo "👉 Install it first: https://brew.sh"
		exit 1
	fi
}

case "$OS" in
Linux)
	install_linux
	;;
Darwin)
	install_macos
	;;
*)
	echo "❌ Unsupported OS: $OS"
	exit 1
	;;
esac

echo "✅ Neovim installed!"
echo "👉 Version:"
nvim --version | head -n 1
