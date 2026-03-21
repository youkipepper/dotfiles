#!/bin/bash
set -euo pipefail

echo "🚀 Installing latest Neovim..."

OS="$(uname -s)"
ARCH="$(uname -m)"

NVIM_URL=""

# ----------------------------
# detect architecture
# ----------------------------
case "$ARCH" in
x86_64)
	NVIM_URL="https://github.com/neovim/neovim/releases/latest/download/nvim-linux64.tar.gz"
	;;
aarch64 | arm64)
	NVIM_URL="https://github.com/neovim/neovim/releases/latest/download/nvim-linux-arm64.tar.gz"
	;;
*)
	echo "❌ Unsupported architecture: $ARCH"
	exit 1
	;;
esac

# ----------------------------
# install dependencies (Linux)
# ----------------------------
install_linux_deps() {
	echo "🐧 Installing dependencies..."
	sudo apt update
	sudo apt install -y curl git xz-utils tar
}

# ----------------------------
# macOS install
# ----------------------------
install_macos() {
	echo "🍎 Detected macOS"

	if command -v brew >/dev/null 2>&1; then
		brew install neovim || brew upgrade neovim
	else
		echo "❌ Homebrew not found"
		exit 1
	fi

	exit 0
}

# ----------------------------
# main install logic
# ----------------------------
if [ "$OS" = "Darwin" ]; then
	install_macos
fi

install_linux_deps

TMP_DIR="$(mktemp -d)"
cd "$TMP_DIR"

echo "⬇️ Downloading Neovim from:"
echo "$NVIM_URL"

curl -L --fail -o nvim.tar.gz "$NVIM_URL"

# ----------------------------
# validate download
# ----------------------------
if [ ! -s nvim.tar.gz ]; then
	echo "❌ Download failed (empty file)"
	exit 1
fi

echo "📦 Extracting..."
tar xzf nvim.tar.gz

echo "📂 Installing..."
sudo rm -rf /opt/nvim
sudo mv nvim-linux* /opt/nvim

# ----------------------------
# symlink
# ----------------------------
sudo ln -sf /opt/nvim/bin/nvim /usr/local/bin/nvim

# ----------------------------
# cleanup
# ----------------------------
rm -rf "$TMP_DIR"

echo "✅ Neovim installed successfully!"
echo "👉 Version:"
nvim --version | head -n 1
