#!/usr/bin/env bash
set -e

echo "🚀 Ubuntu Smart Mirror Switcher (Safe Mode)"

# ----------------------------
# detect system
# ----------------------------
. /etc/os-release
CODENAME="$VERSION_CODENAME"

if [ -z "$CODENAME" ]; then
    echo "❌ Cannot detect Ubuntu codename"
    exit 1
fi

echo "📦 Detected codename: $CODENAME"

# ----------------------------
# detect LTS vs dev
# ----------------------------
IS_LTS=$(grep "LTS" /etc/os-release || true)

if [[ "$CODENAME" == *"questing"* ]] || [[ "$CODENAME" == *"devel"* ]]; then
    MODE="dev"
elif [[ -n "$IS_LTS" ]]; then
    MODE="lts"
else
    MODE="normal"
fi

echo "🧠 Detected mode: $MODE"

# ----------------------------
# backup
# ----------------------------
echo "📁 Backing up sources..."
sudo mkdir -p /etc/apt/backup
sudo cp -r /etc/apt/sources.list /etc/apt/backup/ 2>/dev/null || true
sudo cp -r /etc/apt/sources.list.d /etc/apt/backup/ 2>/dev/null || true

# ----------------------------
# clean conflicting files
# ----------------------------
sudo rm -f /etc/apt/sources.list.d/ubuntu.sources 2>/dev/null || true

# ----------------------------
# choose mirror
# ----------------------------
if [ "$MODE" = "dev" ]; then
    echo "⚠️ Dev version detected → using official Ubuntu archive"
    MIRROR="http://archive.ubuntu.com/ubuntu"

elif [ "$MODE" = "lts" ]; then
    echo "✅ LTS detected → using TUNA mirror"
    MIRROR="https://mirrors.tuna.tsinghua.edu.cn/ubuntu"

else
    echo "📦 Normal release → using TUNA mirror"
    MIRROR="https://mirrors.tuna.tsinghua.edu.cn/ubuntu"
fi

# ----------------------------
# write sources
# ----------------------------
echo "📝 Writing sources.list..."

sudo tee /etc/apt/sources.list >/dev/null <<EOF
deb $MIRROR $CODENAME main restricted universe multiverse
deb $MIRROR $CODENAME-updates main restricted universe multiverse
deb $MIRROR $CODENAME-backports main restricted universe multiverse
deb $MIRROR $CODENAME-security main restricted universe multiverse
EOF

# ----------------------------
# update
# ----------------------------
echo "🔄 Running apt update..."
sudo apt update

echo ""
echo "✅ Done!"

if [ "$MODE" = "dev" ]; then
    echo "⚠️ You are on a development Ubuntu ($CODENAME)"
    echo "👉 Consider switching to LTS for stability:"
    echo "   https://ubuntu.com/download/lts"
else
    echo "🎉 Mirror optimized successfully"
fi

echo "👉 Recommended:"
echo "   sudo apt upgrade -y"