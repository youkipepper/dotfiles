#!/usr/bin/env bash
set -e

echo "🚀 Ubuntu mirror switcher (TUNA optimized)"

# ----------------------------
# detect ubuntu version
# ----------------------------
. /etc/os-release

if [ -z "$VERSION_CODENAME" ]; then
    echo "❌ Cannot detect Ubuntu codename"
    exit 1
fi

CODENAME="$VERSION_CODENAME"

echo "📦 Detected Ubuntu: $CODENAME"

# ----------------------------
# backup
# ----------------------------
echo "📁 Backing up APT sources..."
sudo mkdir -p /etc/apt/backup
sudo cp -r /etc/apt/sources.list /etc/apt/backup/ 2>/dev/null || true
sudo cp -r /etc/apt/sources.list.d /etc/apt/backup/ 2>/dev/null || true

# ----------------------------
# clean conflicting sources (safe)
# ----------------------------
echo "🧹 Cleaning conflicting sources..."

sudo rm -f /etc/apt/sources.list.d/ubuntu.sources 2>/dev/null || true

# ----------------------------
# write classic sources.list (compat mode)
# ----------------------------
echo "📝 Writing sources.list (classic mode)..."

sudo tee /etc/apt/sources.list >/dev/null <<EOF
deb https://mirrors.tuna.tsinghua.edu.cn/ubuntu/ $CODENAME main restricted universe multiverse
deb https://mirrors.tuna.tsinghua.edu.cn/ubuntu/ $CODENAME-updates main restricted universe multiverse
deb https://mirrors.tuna.tsinghua.edu.cn/ubuntu/ $CODENAME-backports main restricted universe multiverse
deb https://mirrors.tuna.tsinghua.edu.cn/ubuntu/ $CODENAME-security main restricted universe multiverse
EOF

# ----------------------------
# optional: disable deb822 auto file if exists
# ----------------------------
if [ -f /etc/apt/sources.list.d/ubuntu.sources ]; then
    echo "⚠️ Found deb822 sources file (disabled for safety)"
    sudo mv /etc/apt/sources.list.d/ubuntu.sources /etc/apt/sources.list.d/ubuntu.sources.bak || true
fi

# ----------------------------
# update
# ----------------------------
echo "🔄 Updating APT..."
sudo apt update

echo ""
echo "✅ Done!"
echo "👉 Recommended:"
echo "   sudo apt upgrade -y"