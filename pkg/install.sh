#!/bin/bash
set -uo pipefail

DIR="$(cd "$(dirname "$0")" && pwd)"
PACKAGE_FILE="$DIR/packages.conf"
MODE="${1:-cli}"

case "$MODE" in
cli | gui | all)
	;;
-h | --help)
	echo "Usage: bash pkg/install.sh [cli|gui|all]"
	exit 0
	;;
*)
	echo "Usage: bash pkg/install.sh [cli|gui|all]"
	exit 1
	;;
esac

source "$DIR/lib.sh"

detect_platform || exit 1
require_package_manager || exit 1

echo "🚀 Installing mode: $MODE"
echo "🖥️ Platform: $PLATFORM ($PKG_MANAGER)"

SUCCESS=0
FAILED=0
SKIPPED=0

while IFS='|' read -r group name check brew_type brew_pkg apt_pkg dnf_pkg pacman_pkg || [ -n "${group:-}" ]; do
	[ -z "${group:-}" ] && continue
	case "$group" in \#*) continue ;; esac
	[ "$MODE" != "all" ] && [ "$MODE" != "$group" ] && continue

	case "$PKG_MANAGER" in
	brew) package="$brew_pkg" ;;
	apt) package="$apt_pkg" ;;
	dnf) package="$dnf_pkg" ;;
	pacman) package="$pacman_pkg" ;;
	esac

	echo ""
	echo "👉 $name"

	install_package "$name" "$check" "$brew_type" "$package"
	status=$?

	case "$status" in
	0) SUCCESS=$((SUCCESS + 1)) ;;
	2) SKIPPED=$((SKIPPED + 1)) ;;
	*)
		FAILED=$((FAILED + 1))
		log "WARN" "$name installation failed"
		;;
	esac
done <"$PACKAGE_FILE"

echo ""
echo "===================="
echo "DONE ($MODE)"
echo "✔ success: $SUCCESS"
echo "↷ skipped: $SKIPPED"
echo "⚠ failed: $FAILED"
echo "===================="

[ "$FAILED" -eq 0 ]
