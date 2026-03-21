#!/bin/bash
set -euo pipefail

echo "🚀 Installing JetBrains & Maple Mono Font..."

# ----------------------------
# check tools
# ----------------------------
for cmd in curl unzip; do
	if ! command -v "$cmd" >/dev/null 2>&1; then
		echo "❌ $cmd is required"
		exit 1
	fi
done

# ----------------------------
# install JetBrains Toolbox
# ----------------------------
install_jetbrains() {
	if command -v jetbrains-toolbox >/dev/null 2>&1; then
		echo "✔ JetBrains Toolbox already installed"
		return
	fi

	echo "📦 Installing JetBrains Toolbox..."

	TMP_DIR=$(mktemp -d)
	cd "$TMP_DIR"

	curl -L -o toolbox.tar.gz \
	https://download.jetbrains.com/toolbox/jetbrains-toolbox-2.3.1.31116.tar.gz

	tar -xzf toolbox.tar.gz
	cd jetbrains-toolbox-*

	./jetbrains-toolbox &

	echo "✅ JetBrains Toolbox launched (finish install in GUI)"

	cd ~
	rm -rf "$TMP_DIR"
}

# ----------------------------
# install Maple Mono Nerd Font
# ----------------------------
install_font() {
	FONT_NAME="MapleMono NF CN"
	FONT_DIR="$HOME/.local/share/fonts"

	if fc-list | grep -qi "MapleMono"; then
		echo "✔ Maple Mono already installed"
		return
	fi

	echo "🔤 Installing Maple Mono Nerd Font..."

	mkdir -p "$FONT_DIR"
	cd "$FONT_DIR"

	curl -L -o maple.zip \
	https://github.com/subframe7536/maple-font/releases/download/v7.1/MapleMono-NF-CN.zip

	unzip -o maple.zip >/dev/null
	rm maple.zip

	fc-cache -fv >/dev/null 2>&1 || true

	echo "✅ Font installed"
}

# ----------------------------
# run
# ----------------------------
install_jetbrains
install_font

echo "🎉 All done!"