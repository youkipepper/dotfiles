#!/bin/bash
set -euo pipefail

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

if [ -d "$HOME/.config" ]; then
	for item in "$HOME/.config/"*; do
		[ -e "$item" ] || continue

		target="$HOME/.config/$(basename "$item")"
		link_item "$item" "$target"
	done
fi

echo "✅ Dotfiles setup complete!"
echo "⚠️ Skipped existing files that are not symlinks. Delete or backup those files and rerun the script to link them."

