#!/usr/bin/env bash
set -e

# ----------------------------
# Detect system info (robust)
# ----------------------------

# Source /etc/os-release if available
if [ -f /etc/os-release ]; then
	. /etc/os-release
fi

# Use VERSION_CODENAME if present
CODENAME="${VERSION_CODENAME}"

# Fallback: use lsb_release
if [ -z "$CODENAME" ] && command -v lsb_release >/dev/null 2>&1; then
	CODENAME=$(lsb_release -cs)
fi

# Fallback: extract from VERSION string
if [ -z "$CODENAME" ] && [ -n "$VERSION" ]; then
	CODENAME=$(echo "$VERSION" | sed -n 's/.*(\(.*\)).*/\1/p')
fi

# Architecture
ARCH=$(dpkg --print-architecture)

# Final fallback
if [ -z "$CODENAME" ]; then
	echo "⚠️  Could not detect codename automatically."
	echo "👉 Defaulting to: bookworm"
	CODENAME="bookworm"
fi

echo "📦 Detected:"
echo "   ID: ${ID:-unknown}"
echo "   Codename: $CODENAME"
echo "   Arch: $ARCH"

# ----------------------------
# backup
# ----------------------------
echo "📁 Backing up old sources..."
sudo mkdir -p /etc/apt/backup
sudo cp -r /etc/apt/sources.list* /etc/apt/backup/ 2>/dev/null || true
sudo cp -r /etc/apt/sources.list.d /etc/apt/backup/ 2>/dev/null || true

# ----------------------------
# clean conflicting sources (safe)
# ----------------------------
echo "🧹 Cleaning conflicting Debian source files..."
sudo rm -f /etc/apt/sources.list.d/debian.sources || true

# ----------------------------
# main Debian repo (TUNA mirror)
# ----------------------------
echo "📝 Writing Debian sources.list..."

sudo tee /etc/apt/sources.list >/dev/null <<EOF
deb https://mirrors.tuna.tsinghua.edu.cn/debian/ $CODENAME main contrib non-free non-free-firmware
deb https://mirrors.tuna.tsinghua.edu.cn/debian/ $CODENAME-updates main contrib non-free non-free-firmware
deb https://mirrors.tuna.tsinghua.edu.cn/debian-security/ $CODENAME-security main contrib non-free non-free-firmware
EOF

# ----------------------------
# Raspberry Pi repo (correct official format)
# ----------------------------
echo "🍓 Configuring Raspberry Pi repository..."

sudo tee /etc/apt/sources.list.d/raspi.list >/dev/null <<EOF
deb http://archive.raspberrypi.com/debian/ $CODENAME main
EOF

# ----------------------------
# ensure keyring exists
# ----------------------------
if [ ! -f /usr/share/keyrings/raspberrypi-archive-keyring.gpg ]; then
	echo "🔑 Installing Raspberry Pi keyring..."
	sudo apt install -y raspberrypi-archive-keyring
fi

# ----------------------------
# update
# ----------------------------
echo "🔄 Updating apt..."
sudo apt update

echo ""
echo "✅ Done!"
echo "👉 Recommended next step:"
echo "   sudo apt full-upgrade -y"
