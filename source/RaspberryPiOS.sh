#!/usr/bin/env bash
set -e

echo "🚀 Raspberry Pi OS mirror switcher (optimized)"

# ----------------------------
# detect system info
# ----------------------------
CODENAME=$(grep VERSION_CODENAME /etc/os-release | cut -d= -f2)
ARCH=$(dpkg --print-architecture)

if [ -z "$CODENAME" ]; then
    echo "⚠️ Cannot detect codename, defaulting to trixie"
    CODENAME="trixie"
fi

echo "📦 Detected:"
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
sudo rm -f /etc/apt/sources.list.d/raspi.list || true

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
# ensure keyring exists
if [ ! -f /usr/share/keyrings/raspberrypi-archive-keyring.gpg ]; then
    echo "🔑 Installing Raspberry Pi keyring..."
    sudo apt install -y raspberrypi-archive-keyring
fi

sudo tee /etc/apt/sources.list.d/raspi.list >/dev/null <<EOF
deb [signed-by=/usr/share/keyrings/raspberrypi-archive-keyring.gpg] http://archive.raspberrypi.org/debian/ $CODENAME main
EOF

# ----------------------------
# update
# ----------------------------
echo "🔄 Updating apt..."
sudo apt update

echo ""
echo "✅ Done!"
echo "👉 Recommended next step:"
echo "   sudo apt full-upgrade -y"