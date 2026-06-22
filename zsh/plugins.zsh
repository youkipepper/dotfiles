ZSH_PLUGINS="$HOME/.zsh/plugins"
ZSH_AUTOSUGGESTIONS="$ZSH_PLUGINS/zsh-autosuggestions"

if [[ -f "$ZSH_AUTOSUGGESTIONS/zsh-autosuggestions.zsh" ]]; then
	source "$ZSH_AUTOSUGGESTIONS/zsh-autosuggestions.zsh"
elif [[ -f "$ZSH_AUTOSUGGESTIONS/init.zsh" ]]; then
	source "$ZSH_AUTOSUGGESTIONS/init.zsh"
fi

autoload -Uz compinit
ZSH_COMPDUMP="${ZDOTDIR:-$HOME}/.zcompdump"
if [[ ! -f "$ZSH_COMPDUMP" || -n "$ZSH_COMPDUMP"(#qN.mh+24) ]]; then
	compinit
else
	compinit -C
fi

if [[ -f "$HOME/.fzf.zsh" ]]; then
	source "$HOME/.fzf.zsh"
fi

unset ZSH_AUTOSUGGESTIONS ZSH_COMPDUMP ZSH_PLUGINS
