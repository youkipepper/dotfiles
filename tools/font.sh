#!/bin/bash
set -euo pipefail

echo "🔤 Nerd Font Installer (multi-font support)"

# ----------------------------
# Options
# ----------------------------
GITHUB_PROXY=""

while [ "$#" -gt 0 ]; do
	case "$1" in
	--proxy)
		GITHUB_PROXY="https://gh-proxy.org/"
		;;
	-h | --help)
		echo "Usage: bash tools/font.sh [--proxy]"
		exit 0
		;;
	*)
		echo "❌ Unknown option: $1"
		echo "Usage: bash tools/font.sh [--proxy]"
		exit 1
		;;
	esac
	shift
done

# ----------------------------
# Check required tools
# ----------------------------
for cmd in curl unzip; do
	if ! command -v "$cmd" >/dev/null 2>&1; then
		echo "❌ $cmd is required"
		exit 1
	fi
done

if [ "$(uname -s)" = "Darwin" ]; then
	FONT_DIR="$HOME/Library/Fonts"
else
	FONT_DIR="$HOME/.local/share/fonts"
	if ! command -v fc-cache >/dev/null 2>&1; then
		echo "❌ fc-cache is required"
		exit 1
	fi
fi

# ----------------------------
# Font list
# ----------------------------
FONT_NAMES=(
	"MapleMono"
	"JetBrainsMono"
)

FONT_URLS=(
	"${GITHUB_PROXY}https://github.com/subframe7536/maple-font/releases/download/v7.1/MapleMono-NF-CN.zip"
	"${GITHUB_PROXY}https://github.com/ryanoasis/nerd-fonts/releases/download/v2.3.3/JetBrainsMono.zip"
)

# ----------------------------
# Install font function
# ----------------------------
install_font() {
	local font_name="$1"
	local font_url="$2"

	if command -v fc-list >/dev/null 2>&1 && fc-list | grep -qi "$font_name"; then
		echo "✔ $font_name already installed"
		return
	fi

	echo "📦 Installing $font_name..."

	mkdir -p "$FONT_DIR"
	cd "$FONT_DIR"

	local zip_file="${font_name}.zip"

	curl -L --fail -o "$zip_file" "$font_url"
	unzip -o "$zip_file" >/dev/null
	rm "$zip_file"

	if command -v fc-cache >/dev/null 2>&1; then
		fc-cache -fv >/dev/null 2>&1 || true
	fi

	echo "✅ $font_name installed"
}

# ----------------------------
# Install all fonts
# ----------------------------
for index in "${!FONT_NAMES[@]}"; do
	install_font "${FONT_NAMES[$index]}" "${FONT_URLS[$index]}"
done

echo "🎉 All selected fonts setup complete!"
