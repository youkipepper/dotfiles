#!/bin/bash

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

is_installed() {
	command -v "$1" >/dev/null 2>&1
}

install_pkg() {
	local pkg="$1"

	if is_installed "$pkg"; then
		log "OK" "$pkg already installed"
		return 0
	fi

	log "INSTALL" "$pkg via $PKG"

	case "$PKG" in
	brew)
		brew install "$pkg" || log "WARN" "brew failed: $pkg"
		;;
	apt)
		sudo apt install -y "$pkg" || log "WARN" "apt failed: $pkg"
		;;
	dnf)
		sudo dnf install -y "$pkg" || log "WARN" "dnf failed: $pkg"
		;;
	pacman)
		sudo pacman -S --noconfirm "$pkg" || log "WARN" "pacman failed: $pkg"
		;;
	*)
		log "WARN" "No package manager for $pkg"
		;;
	esac

	return 0
}
