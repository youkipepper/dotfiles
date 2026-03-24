#!/usr/bin/env bash
set -e

echo "🚀 Arch Linux mirror optimizer"

# ----------------------------
# check root
# ----------------------------
if [ "$EUID" -ne 0 ]; then
    echo "❌ Please run as root: sudo bash $0"
    exit 1
fi

# ----------------------------
# backup mirrorlist
# ----------------------------
echo "📦 Backing up mirrorlist..."
cp /etc/pacman.d/mirrorlist /etc/pacman.d/mirrorlist.bak

# ----------------------------
# install reflector if needed
# ----------------------------
if ! command -v reflector >/dev/null 2>&1; then
    echo "📦 Installing reflector..."
    pacman -Sy --noconfirm reflector
fi

# ----------------------------
# select fastest mirrors
# ----------------------------
echo "⚡ Selecting fastest mirrors..."

reflector \
    --latest 20 \
    --protocol https \
    --sort rate \
    --save /etc/pacman.d/mirrorlist

# ----------------------------
# update system
# ----------------------------
echo "🔄 Updating system..."
pacman -Syu --noconfirm

# ----------------------------
# optional cleanup
# ----------------------------
echo "🧹 Cleaning package cache..."
paccache -r || true

echo ""
echo "✅ Done! Arch system optimized."