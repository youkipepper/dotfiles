#!/usr/bin/env bash
set -e

echo "🚀 Installing Clash for Linux (user mode)..."

# ----------------------------
# check dependencies
# ----------------------------
missing=()

for cmd in xz unzip git; do
    if ! command -v "$cmd" >/dev/null 2>&1; then
        missing+=("$cmd")
    fi
done

if [ ${#missing[@]} -ne 0 ]; then
    echo "❌ Missing dependencies: ${missing[*]}"
    echo ""

    if command -v apt >/dev/null 2>&1; then
        echo "👉 Install with:"
        echo "sudo apt update && sudo apt install -y ${missing[*]}"
    else
        echo "⚠️ Please install manually: ${missing[*]}"
    fi

    exit 1
fi

# ----------------------------
# paths
# ----------------------------
INSTALL_DIR="$HOME/clash"
REPO_URL="https://gh-proxy.org/https://github.com/nelvko/clash-for-linux-install.git"

# ----------------------------
# clone repo
# ----------------------------
if [ -d "$INSTALL_DIR" ]; then
    echo "📁 Directory exists: $INSTALL_DIR"
else
    echo "📦 Cloning to $INSTALL_DIR..."
    git clone --branch master --depth 1 "$REPO_URL" "$INSTALL_DIR"
fi

cd "$INSTALL_DIR"

# ----------------------------
# run install (user mode hint)
# ----------------------------
echo "⚙️ Running install script..."

echo "⚠️ NOTE:"
echo "This upstream script may try to install to system directories."
echo "You may need to modify install.sh if you want fully user-space install."

bash install.sh || {
    echo "❌ install.sh failed (likely due to permission issues)"
    echo "👉 You may need to edit install.sh to use \$HOME paths instead of /usr/local"
    exit 1
}

echo "✅ Done!"