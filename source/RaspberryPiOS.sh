#!/usr/bin/env bash
set -e

echo "🚀 Raspberry Pi OS / Debian mirror switcher (simplified)"

# ----------------------------
# configuration
# ----------------------------
CODENAME="trixie"   # Debian codename, change if needed
ARCH=$(dpkg --print-architecture)

echo "📦 Using codename: $CODENAME"
echo "📦 Architecture: $ARCH"

# ----------------------------
# backup existing sources
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
sudo rm -f /etc/apt/sources.list.d/raspi.list || true

# ----------------------------
# main Debian repo (TUNA mirror)
# ----------------------------
echo "📝 Writing /etc/apt/sources.list..."

sudo tee /etc/apt/sources.list >/dev/null <<EOF
deb https://mirrors.tuna.tsinghua.edu.cn/debian/ $CODENAME main contrib non-free non-free-firmware
deb https://mirrors.tuna.tsinghua.edu.cn/debian/ $CODENAME-updates main contrib non-free non-free-firmware
deb https://mirrors.tuna.tsinghua.edu.cn/debian-security/ $CODENAME-security main contrib non-free non-free-firmware
EOF

# ----------------------------
# Raspberry Pi repo (official)
# ----------------------------
echo "🍓 Writing /etc/apt/sources.list.d/raspi.list..."

sudo tee /etc/apt/sources.list.d/raspi.list >/dev/null <<EOF
deb [signed-by=/usr/share/keyrings/raspberrypi-archive-keyring.gpg] http://archive.raspberrypi.com/debian/ $CODENAME main
EOF

# ----------------------------
# ensure Raspberry Pi keyring exists
# ----------------------------
if [ ! -f /usr/share/keyrings/raspberrypi-archive-keyring.gpg ]; then
    echo "🔑 Installing Raspberry Pi keyring..."
    sudo apt update
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