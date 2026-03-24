#!/usr/bin/env bash
set -e

echo "🚀 Debian / Raspberry Pi mirror switcher"

# ----------------------------
# detect codename
# ----------------------------
CODENAME=$(grep VERSION_CODENAME /etc/os-release | cut -d= -f2)

if [ -z "$CODENAME" ]; then
    echo "❌ Cannot detect system codename"
    exit 1
fi

echo "📦 Detected: $CODENAME"

# ----------------------------
# backup
# ----------------------------
echo "📁 Backing up old sources..."
sudo mkdir -p /etc/apt/backup
sudo cp -r /etc/apt/sources.list* /etc/apt/backup/ 2>/dev/null || true

# ----------------------------
# remove duplicate sources
# ----------------------------
echo "🧹 Cleaning duplicate sources..."
sudo rm -f /etc/apt/sources.list.d/debian.sources

# ----------------------------
# write new sources.list
# ----------------------------
echo "📝 Writing new sources..."

sudo tee /etc/apt/sources.list >/dev/null <<EOF
deb https://mirrors.tuna.tsinghua.edu.cn/debian/ $CODENAME main contrib non-free non-free-firmware
deb https://mirrors.tuna.tsinghua.edu.cn/debian-security ${CODENAME}-security main
deb https://mirrors.tuna.tsinghua.edu.cn/debian/ ${CODENAME}-updates main
EOF

# ----------------------------
# raspberry pi repo
# ----------------------------
if [ -f /etc/apt/sources.list.d/raspi.sources ]; then
    echo "🍓 Updating Raspberry Pi repo..."

    sudo tee /etc/apt/sources.list.d/raspi.sources >/dev/null <<EOF
Types: deb
URIs: https://mirrors.tuna.tsinghua.edu.cn/raspberrypi/
Suites: $CODENAME
Components: main
Signed-By: /usr/share/keyrings/raspberrypi-archive-keyring.pgp
EOF
fi

# ----------------------------
# update
# ----------------------------
echo "🔄 Updating apt..."

sudo apt update

echo ""
echo "✅ Done!"
echo "👉 If needed, upgrade with:"
echo "   sudo apt upgrade -y"