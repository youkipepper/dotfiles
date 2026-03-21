#!/bin/bash
set -euo pipefail

echo "🚀 Universal CLI Installer Starting..."

DIR="$(cd "$(dirname "$0")" && pwd)"

source "$DIR/lib.sh"

TOOLS_FILE="$DIR/tools.conf"

if [[ ! -f "$TOOLS_FILE" ]]; then
	echo "❌ tools.conf not found"
	exit 1
fi

while read -r tool; do
	[[ -z "$tool" ]] && continue
	[[ "$tool" =~ ^# ]] && continue

	install_pkg "$tool"

done <"$TOOLS_FILE"

echo "✅ All base tools installed"
