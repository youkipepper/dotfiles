#!/bin/bash
set -u

DIR="$(cd "$(dirname "$0")" && pwd)"

source "$DIR/lib.sh"

MODE="${1:-cli}"

if [[ "$MODE" == "cli" ]]; then
	FILE="$DIR/cli.conf"
elif [[ "$MODE" == "gui" ]]; then
	FILE="$DIR/gui.conf"
else
	echo "Usage: install.sh [cli|gui]"
	exit 1
fi

echo "🚀 Installing mode: $MODE"
echo "📦 Using file: $FILE"

SUCCESS=0
FAILED=0

while read -r tool; do
	[[ -z "$tool" ]] && continue
	[[ "$tool" =~ ^# ]] && continue

	echo ""
	echo "👉 $tool"

	if install_pkg "$tool"; then
		SUCCESS=$((SUCCESS + 1))
	else
		FAILED=$((FAILED + 1))
		echo "[WARN] skipped $tool"
	fi

done <"$FILE"

echo ""
echo "===================="
echo "DONE ($MODE)"
echo "✔ success: $SUCCESS"
echo "⚠ failed: $FAILED"
echo "===================="
