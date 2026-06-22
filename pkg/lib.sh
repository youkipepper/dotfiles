#!/bin/bash

PKG_MANAGER=""
PLATFORM=""
PACKAGE_INDEX_READY=0

log() {
	printf '[%s] %s\n' "$1" "$2"
}

detect_platform() {
	if [ -n "${DOTFILES_PKG_MANAGER:-}" ]; then
		PKG_MANAGER="$DOTFILES_PKG_MANAGER"
		PLATFORM="${DOTFILES_PLATFORM:-test}"
		return 0
	fi

	case "$(uname -s)" in
	Darwin)
		PLATFORM="macos"
		PKG_MANAGER="brew"
		;;
	Linux)
		if [ ! -r /etc/os-release ]; then
			log "ERROR" "Cannot detect Linux distribution"
			return 1
		fi

		. /etc/os-release
		case "${ID:-}" in
		ubuntu | debian)
			PLATFORM="$ID"
			PKG_MANAGER="apt"
			;;
		fedora)
			PLATFORM="fedora"
			PKG_MANAGER="dnf"
			;;
		arch | manjaro)
			PLATFORM="$ID"
			PKG_MANAGER="pacman"
			;;
		*)
			case " ${ID_LIKE:-} " in
			*" debian "*)
				PLATFORM="${ID:-debian}"
				PKG_MANAGER="apt"
				;;
			*" fedora "*)
				PLATFORM="${ID:-fedora}"
				PKG_MANAGER="dnf"
				;;
			*" arch "*)
				PLATFORM="${ID:-arch}"
				PKG_MANAGER="pacman"
				;;
			*)
				log "ERROR" "Unsupported Linux distribution: ${ID:-unknown}"
				return 1
				;;
			esac
			;;
		esac
		;;
	*)
		log "ERROR" "Unsupported operating system: $(uname -s)"
		return 1
		;;
	esac
}

require_package_manager() {
	if ! command -v "$PKG_MANAGER" >/dev/null 2>&1; then
		log "ERROR" "$PKG_MANAGER is required on $PLATFORM"
		return 1
	fi
}

run_as_root() {
	if [ "$(id -u)" -eq 0 ]; then
		"$@"
	elif command -v sudo >/dev/null 2>&1; then
		sudo "$@"
	else
		log "ERROR" "sudo is required to install packages"
		return 1
	fi
}

prepare_package_index() {
	if [ "$PACKAGE_INDEX_READY" -eq 1 ]; then
		return 0
	fi

	if [ "$PKG_MANAGER" = "apt" ]; then
		log "UPDATE" "Refreshing APT package index"
		run_as_root apt update || return 1
	fi

	PACKAGE_INDEX_READY=1
}

is_available() {
	local check="$1"
	local value

	case "$check" in
	cmd:*)
		value="${check#cmd:}"
		command -v "$value" >/dev/null 2>&1
		;;
	app:*)
		value="${check#app:}"
		[ "$PLATFORM" = "macos" ] &&
			{ [ -d "/Applications/$value.app" ] || [ -d "$HOME/Applications/$value.app" ]; }
		;;
	*)
		return 1
		;;
	esac
}

is_package_installed() {
	local package="$1"
	local brew_type="$2"

	case "$PKG_MANAGER" in
	brew)
		if [ "$brew_type" = "cask" ]; then
			brew list --cask "$package" >/dev/null 2>&1
		else
			brew list --formula "$package" >/dev/null 2>&1
		fi
		;;
	apt)
		dpkg-query -W -f='${Status}\n' "$package" 2>/dev/null | grep -q '^install ok installed$'
		;;
	dnf)
		rpm -q "$package" >/dev/null 2>&1
		;;
	pacman)
		pacman -Q "$package" >/dev/null 2>&1
		;;
	esac
}

install_package() {
	local name="$1"
	local check="$2"
	local brew_type="$3"
	local package="$4"

	if is_available "$check"; then
		log "OK" "$name already installed"
		return 0
	fi

	if [ -z "$package" ]; then
		log "SKIP" "$name is not configured for $PLATFORM"
		return 2
	fi

	if is_package_installed "$package" "$brew_type"; then
		log "OK" "$name already installed"
		return 0
	fi

	prepare_package_index || return 1
	log "INSTALL" "$name as $package via $PKG_MANAGER"

	case "$PKG_MANAGER" in
	brew)
		if [ "$brew_type" = "cask" ]; then
			brew install --cask "$package"
		else
			brew install "$package"
		fi
		;;
	apt)
		run_as_root apt install -y "$package"
		;;
	dnf)
		run_as_root dnf install -y "$package"
		;;
	pacman)
		run_as_root pacman -S --needed --noconfirm "$package"
		;;
	esac
}
