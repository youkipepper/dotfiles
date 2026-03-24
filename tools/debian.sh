#!/usr/bin/env bash
set -e

echo "🚀 Switching APT sources to TUNA mirror..."

# ----------------------------
# backup
# ----------------------------
echo "📦 Backing up original sources..."

sudo cp /etc/apt/sources.list /etc/apt/sources.list.bak 2>/dev/null || true
sudo cp -r /etc/apt/sources.list.d /etc/apt/sources.list.d.bak 2>/dev/null || true

# ----------------------------
# detect codename
# ----------------------------
CODENAME=$(grep VERSION_CODENAME /etc/os-release | cut -d= -f2)

if [ -z "$CODENAME" ]; then
    echo "❌ Cannot detect system codename"
    exit 1
fi

echo "📌 Detected codename: $CODENAME"

# ----------------------------
# write sources.list
# ----------------------------
echo "📝 Updating /etc/apt/sources.list..."

sudo tee /etc/apt/sources.list >/dev/null <<EOF
deb https://mirrors.tuna.tsinghua.edu.cn/debian/ $CODENAME main contrib non-free non-free-firmware
deb https://mirrors.tuna.tsinghua.edu.cn/debian-security $CODENAME-security main
deb https://mirrors.tuna.tsinghua.edu.cn/debian/ $CODENAME-updates main
EOF

# ----------------------------
# fix debian.sources (if exists)
# ----------------------------
if [ -f /etc/apt/sources.list.d/debian.sources ]; then
    echo "📝 Updating debian.sources..."

    sudo sed -i 's|http://deb.debian.org/debian/|https://mirrors.tuna.tsinghua.edu.cn/debian/|g' /etc/apt/sources.list.d/debian.sources
    sudo sed -i 's|http://deb.debian.org/debian-security/|https://mirrors.tuna.tsinghua.edu.cn/debian-security|g' /etc/apt/sources.list.d/debian.sources
fi

# ----------------------------
# fix raspberrypi source
# ----------------------------
if [ -f /etc/apt/sources.list.d/raspi.sources ]; then
    echo "📝 Updating raspi.sources..."

    sudo sed -i 's|http://archive.raspberrypi.com/debian/|https://mirrors.tuna.tsinghua.edu.cn/raspberrypi/|g' /etc/apt/sources.list.d/raspi.sources
fi

# ----------------------------
# update
# ----------------------------
echo "🔄 Running apt update..."

sudo apt update

echo ""
echo "✅ Done!"
echo "🚀 Now your apt should be much faster"