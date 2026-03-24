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