#!/bin/bash

set -euo pipefail

OS="$(uname -s)"

detect_pkg() {
	if command -v brew >/dev/null 2>&1; then
		echo "brew"
	elif command -v apt >/dev/null 2>&1; then
		echo "apt"
	elif command -v dnf >/dev/null 2>&1; then
		echo "dnf"
	elif command -v pacman >/dev/null 2>&1; then
		echo "pacman"
	else
		echo "unknown"
	fi
}

PKG=$(detect_pkg)

log() {
	echo "[$1] $2"
}

need_cmd() {
	command -v "$1" >/dev/null 2>&1
}

install_pkg() {
	local pkg="$1"

	if need_cmd "$pkg"; then
		log "OK" "$pkg already installed"
		return
	fi

	log "INSTALL" "$pkg via $PKG"

	case "$PKG" in
	brew)
		brew install "$pkg"
		;;
	apt)
		sudo apt update -y
		sudo apt install -y "$pkg"
		;;
	dnf)
		sudo dnf install -y "$pkg"
		;;
	pacman)
		sudo pacman -S --noconfirm "$pkg"
		;;
	*)
		log "WARN" "No supported package manager for $pkg"
		;;
	esac
}
