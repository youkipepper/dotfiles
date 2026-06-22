if command -v lsd >/dev/null 2>&1; then
	alias lsa='lsd -alh'
else
	alias lsa='ls -alh'
fi

if command -v fastfetch >/dev/null 2>&1; then
	for i in {2..31}; do
		alias f$i="fastfetch -c examples/$i.jsonc"
	done
	unset i
	alias fa='fastfetch -c all'
	alias f='fastfetch'
fi

if command -v nvim >/dev/null 2>&1; then
	alias dot='cd "$DOTFILES_DIR" && nvim .'
fi

if command -v code >/dev/null 2>&1; then
	alias dotc='cd "$DOTFILES_DIR" && code .'
	alias codexc='cd "$HOME/.codex" && code .'
fi

alias dotpull='git -C "$DOTFILES_DIR" pull'
alias dotpush='cd "$DOTFILES_DIR" && gacp'
alias reload='source "$HOME/.zshrc"'

if command -v curl >/dev/null 2>&1; then
	alias ptest='curl -I --max-time 5 https://www.google.com'
fi

if [[ "$OSTYPE" == darwin* ]]; then
	alias mtlhub='env MTL_HUD_ENABLED=1'
	if command -v xattr >/dev/null 2>&1; then
		alias fixapp='sudo xattr -r -d com.apple.quarantine'
	fi
fi

if command -v starship >/dev/null 2>&1; then
	alias sp='starship preset --list'
fi

if command -v pip >/dev/null 2>&1; then
	alias pipc='pip install -i https://pypi.tuna.tsinghua.edu.cn/simple'
elif command -v pip3 >/dev/null 2>&1; then
	alias pipc='pip3 install -i https://pypi.tuna.tsinghua.edu.cn/simple'
fi

alias ds='du -h -d 1 | sort -hr'
