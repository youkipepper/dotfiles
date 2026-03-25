# ## ohmyzsh
# export ZSH="$HOME/.oh-my-zsh"
# ZSH_THEME="kardan" # set by `omz`
# plugins=(git z zsh-autosuggestions zsh-syntax-highlighting)
# source $ZSH/oh-my-zsh.sh

# =========================
# ZSH Plugin System (no OMZ)
# =========================

# DOTFILES_ZSH="$HOME/dotfiles/zsh"
ZSH_PLUGINS="$HOME/.zsh/plugins"

load_plugin() {
	local dir="$1"

	if [[ -f "$dir/init.zsh" ]]; then
		source "$dir/init.zsh"
	elif [[ -f "$dir/zsh-autosuggestions.zsh" ]]; then
		source "$dir/zsh-autosuggestions.zsh"
	elif [[ -f "$dir/zsh-syntax-highlighting.zsh" ]]; then
		source "$dir/zsh-syntax-highlighting.zsh"
	else
		echo "[zsh] plugin not found: $dir"
	fi
}

load_plugin "$ZSH_PLUGINS/zsh-autosuggestions"
load_plugin "$ZSH_PLUGINS/zsh-syntax-highlighting"

autoload -Uz compinit
compinit
