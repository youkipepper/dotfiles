gacp() {
	git add . &&
		git commit -m "update: $(date '+%Y-%m-%d %H:%M:%S')" &&
		git push
}

smartgit() {
	local repo="$1"
	local dir="$2"

	if [ -z "$repo" ]; then
		echo "Usage: smartgit <repo-url> [dir]"
		return 1
	fi

	if [ -z "$dir" ]; then
		dir="$(basename "$repo" .git)"
	fi

	is_github() {
		[[ "$1" == https://github.com/* ]]
	}

	try_clone() {
		local url="$1"

		echo "Cloning: $url"

		git clone "$url" "$dir"
	}

	if is_github "$repo"; then
		# 1. direct
		try_clone "$repo" && return 0

		# 2. ghproxy fallback
		local proxy="https://ghproxy.com/$repo"
		try_clone "$proxy" && return 0

		echo "All clone sources failed"
		return 1
	else
		try_clone "$repo"
	fi
}

smartdl() {
	local url="$1"
	local out="${2:-}"

	if [ -z "$url" ]; then
		echo "Usage: smartdl <url> [output]"
		return 1
	fi

	# auto filename
	if [ -z "$out" ]; then
		out="$(basename "$url")"
	fi

	is_github() {
		[[ "$1" == https://github.com/* || "$1" == https://raw.githubusercontent.com/* ]]
	}

	try_download() {
		local u="$1"

		echo "Trying: $u"

		curl -L --retry 3 --retry-delay 2 \
			--connect-timeout 8 --max-time 0 \
			-o "$out" "$u"
	}

	# direct first for GitHub
	if is_github "$url"; then
		try_download "$url" && return 0

		# fallback: ghproxy
		local proxy="https://ghproxy.com/$url"
		try_download "$proxy" && return 0

		echo "All sources failed"
		return 1
	else
		try_download "$url"
	fi
}
