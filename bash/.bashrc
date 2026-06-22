if command -v starship >/dev/null 2>&1; then
	eval "$(starship init bash)"
fi
[ -f ~/.fzf.bash ] && source ~/.fzf.bash