#!/bin/bash
set -e

EMAIL="${1:-}"

if [ -z "$EMAIL" ]; then
	echo "❌ Usage: $0 your_email@example.com"
	exit 1
fi

KEY_PATH="$HOME/.ssh/id_ed25519"

# ----------------------------
# generate key
# ----------------------------
if [ -f "$KEY_PATH" ]; then
	echo "✔ SSH key already exists: $KEY_PATH"
else
	echo "🔑 Generating SSH key..."
	ssh-keygen -t ed25519 -C "$EMAIL" -f "$KEY_PATH" -N ""
fi

# ----------------------------
# start agent
# ----------------------------
eval "$(ssh-agent -s)"

# ----------------------------
# add key (cross-platform)
# ----------------------------
if [[ "$OSTYPE" == "darwin"* ]]; then
	ssh-add --apple-use-keychain "$KEY_PATH" 2>/dev/null || ssh-add -K "$KEY_PATH"
else
	ssh-add "$KEY_PATH"
fi

# ----------------------------
# config (append instead of overwrite)
# ----------------------------
CONFIG="$HOME/.ssh/config"

mkdir -p "$HOME/.ssh"
touch "$CONFIG"

if ! grep -q "IdentityFile ~/.ssh/id_ed25519" "$CONFIG"; then
	echo "🔧 Updating SSH config..."
	cat <<EOF >>"$CONFIG"

Host *
  AddKeysToAgent yes
  IdentityFile ~/.ssh/id_ed25519
EOF
fi

# ----------------------------
# copy public key
# ----------------------------
echo "📋 Your public key:"
cat "$KEY_PATH.pub"

echo ""
echo "👉 Add this key to GitHub:"
echo "https://github.com/settings/keys"
