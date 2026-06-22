gacp() {
	git add . &&
		git commit -m "update: $(date '+%Y-%m-%d %H:%M:%S')" &&
		git push
}

packz() {
	if (( $# != 1 )); then
		echo "Usage: packz <path>"
		return 1
	fi

	zip -r "${1%/}.zip" "$1"
}

packt() {
	if (( $# != 1 )); then
		echo "Usage: packt <path>"
		return 1
	fi

	tar -czvf "${1%/}.tar.gz" "$1"
}

spuse() {
	if ! command -v starship >/dev/null 2>&1; then
		echo "starship is not installed"
		return 1
	fi

	if (( $# != 1 )); then
		echo "Usage: spuse <preset>"
		return 1
	fi

	starship preset "$1" -o "$HOME/.config/starship.toml"
}

smartgit() {
	local repo="$1"
	local dir="${2:-}"
	local proxy

	if [[ -z "$repo" ]]; then
		echo "Usage: smartgit <repo-url> [dir]"
		return 1
	fi

	[[ -z "$dir" ]] && dir="$(basename "$repo" .git)"

	echo "Cloning: $repo"
	git clone "$repo" "$dir" && return 0

	if [[ "$repo" == https://github.com/* ]]; then
		proxy="https://gh-proxy.org/$repo"
		echo "Cloning: $proxy"
		git clone "$proxy" "$dir" && return 0
	fi

	echo "All clone sources failed"
	return 1
}

smartdl() {
	local url="$1"
	local out="${2:-}"
	local proxy

	if [[ -z "$url" ]]; then
		echo "Usage: smartdl <url> [output]"
		return 1
	fi

	[[ -z "$out" ]] && out="$(basename "${url%%\?*}")"

	echo "Trying: $url"
	curl -L --fail --retry 3 --retry-delay 2 \
		--connect-timeout 8 --max-time 0 \
		-o "$out" "$url" && return 0

	if [[ "$url" == https://github.com/* || "$url" == https://raw.githubusercontent.com/* ]]; then
		proxy="https://gh-proxy.org/$url"
		echo "Trying: $proxy"
		curl -L --fail --retry 3 --retry-delay 2 \
			--connect-timeout 8 --max-time 0 \
			-o "$out" "$proxy" && return 0
	fi

	echo "All sources failed"
	return 1
}
