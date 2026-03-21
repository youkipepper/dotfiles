#!/bin/bash
set -euo pipefail

DOTFILES_DIR="$(cd "$(dirname "$0")" && pwd)"

run() {
	bash "$DOTFILES_DIR/modules/$1.sh"
}

CMD="${1:-all}"

case "$CMD" in
all)
	run base
	run pkg
	run font
	run zsh
	run symlink
	;;

base|pkg|font|zsh|symlink)
	run "$CMD"
	;;

*)
	echo "❌ Unknown command: $CMD"
	exit 1
	;;
esac