#!/usr/bin/env bash
set -e

DOT="$HOME/dotfiles/gnome"
LIST="$DOT/extensions.list"
CONF="$DOT/extensions.conf"

echo "🚀 Restoring GNOME extensions..."

# ----------------------------
# install installer
# ----------------------------
INSTALLER="/tmp/gnome-shell-extension-installer"

if [ ! -f "$INSTALLER" ]; then
	echo "📦 downloading installer..."
	curl -sL https://raw.githubusercontent.com/brunelli/gnome-shell-extension-installer/master/gnome-shell-extension-installer \
		-o "$INSTALLER"
	chmod +x "$INSTALLER"
fi

# ----------------------------
# install extensions
# ----------------------------
echo "📦 installing extensions..."

while read -r ext; do
	[ -z "$ext" ] && continue

	name="${ext%@*}"
	echo "👉 $ext"

	"$INSTALLER" "$name" || true
	gnome-extensions enable "$ext" || true

done <"$LIST"

# ----------------------------
# restore config
# ----------------------------
echo "⚙️ restoring config..."
dconf load /org/gnome/shell/extensions/ <"$CONF" || true

echo "✅ Done!"
echo "⚠️ Press Alt+F2 → r to restart GNOME (or relogin)"
