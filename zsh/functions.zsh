gacp() {
	git add . &&
		git commit -m "update: $(date '+%Y-%m-%d %H:%M:%S')" &&
		git push
}

gclone() {
	if [ -z "$1" ]; then
		echo "Usage: gclone <github-url>"
		return 1
	fi

	local url="$1"

	if [[ "$url" == *gh-proxy.org* ]]; then
		git clone "$url"
	else
		git clone "https://gh-proxy.org/https://github.com/${url#https://github.com/}"
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
