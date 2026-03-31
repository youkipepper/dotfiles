#!/bin/bash
set -euo pipefail

echo "🔤 Nerd Font Installer (multi-font support)"

# ----------------------------
# Check required tools
# ----------------------------
for cmd in curl unzip fc-cache; do
	if ! command -v "$cmd" >/dev/null 2>&1; then
		echo "❌ $cmd is required"
		exit 1
	fi
done

# ----------------------------
# Font list (name => URL)
# ----------------------------
declare -A FONTS=(
	["MapleMono"]="https://gh-proxy.org/https://github.com/subframe7536/maple-font/releases/download/v7.1/MapleMono-NF-CN.zip"
	# ["FiraCode"]="https://gh-proxy.org/https://github.com/ryanoasis/nerd-fonts/releases/download/v2.3.3/FiraCode.zip"
	["JetBrainsMono"]="https://gh-proxy.org/https://github.com/ryanoasis/nerd-fonts/releases/download/v2.3.3/JetBrainsMono.zip"
	["SourceHanSansCN"]="https://gh-proxy.org/https://github.com/adobe-fonts/source-han-sans/archive/refs/tags/2.005R.zip"
)

# ----------------------------
# Install font function
# ----------------------------
install_font() {
	local font_name="$1"
	local font_url="$2"
	local FONT_DIR="$HOME/.local/share/fonts"

	if fc-list | grep -qi "$font_name"; then
		echo "✔ $font_name already installed"
		return
	fi

	echo "📦 Installing $font_name..."

	mkdir -p "$FONT_DIR"
	cd "$FONT_DIR"

	local zip_file="${font_name}.zip"

	curl -L -o "$zip_file" "$font_url"
	unzip -o "$zip_file" >/dev/null
	rm "$zip_file"

	fc-cache -fv >/dev/null 2>&1 || true

	echo "✅ $font_name installed"
}

# ----------------------------
# Install all fonts
# ----------------------------
for font in "${!FONTS[@]}"; do
	install_font "$font" "${FONTS[$font]}"
done

echo "🎉 All selected fonts setup complete!"