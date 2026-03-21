#!/bin/bash
set -u # ⚠️ 只保留 -u，不用 -e

echo "🚀 Starting Universal CLI Installer..."

DIR="$(cd "$(dirname "$0")" && pwd)"

source "$DIR/lib.sh"

TOOLS_FILE="$DIR/tools.conf"

if [[ ! -f "$TOOLS_FILE" ]]; then
	echo "❌ tools.conf not found"
	exit 1
fi

SUCCESS=0
FAILED=0

while read -r tool; do
	[[ -z "$tool" ]] && continue
	[[ "$tool" =~ ^# ]] && continue

	echo ""
	echo "=============================="
	echo "👉 Processing: $tool"
	echo "=============================="

	if install_pkg "$tool"; then
		SUCCESS=$((SUCCESS + 1))
	else
		FAILED=$((FAILED + 1))
		echo "[WARN] skipped: $tool"
	fi

done <"$TOOLS_FILE"

echo ""
echo "=============================="
echo "✅ DONE"
echo "✔ success: $SUCCESS"
echo "⚠ failed:  $FAILED"
echo "=============================="
