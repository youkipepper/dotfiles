#!/bin/bash
set -euo pipefail

echo "🔤 Installing Maple Mono Nerd Font..."

# ----------------------------
# check tools
# ----------------------------
for cmd in curl unzip fc-cache; do
	if ! command -v "$cmd" >/dev/null 2>&1; then
		echo "❌ $cmd is required"
		exit 1
	fi
done

# ----------------------------
# install Maple Mono Nerd Font
# ----------------------------
install_font() {
	FONT_DIR="$HOME/.local/share/fonts"

	if fc-list | grep -qi "MapleMono"; then
		echo "✔ Maple Mono already installed"
		return
	fi

	echo "📦 Installing Maple Mono Nerd Font..."

	mkdir -p "$FONT_DIR"
	cd "$FONT_DIR"

	curl -L -o maple.zip \
	https://gh-proxy.org/https://github.com/subframe7536/maple-font/releases/download/v7.1/MapleMono-NF-CN.zip

	unzip -o maple.zip >/dev/null
	rm maple.zip

	fc-cache -fv >/dev/null 2>&1 || true

	echo "✅ Font installed"
}

# ----------------------------
# run
# ----------------------------
install_font

echo "🎉 Maple Mono setup complete!"