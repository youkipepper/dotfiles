# ## ohmyzsh
# export ZSH="$HOME/.oh-my-zsh"
# ZSH_THEME="kardan" # set by `omz`
# plugins=(git z zsh-autosuggestions zsh-syntax-highlighting)
# source $ZSH/oh-my-zsh.sh

# =========================
# ZSH Plugin System (no OMZ)
# =========================

DOTFILES_ZSH="$HOME/dotfiles/zsh"

# completion
autoload -Uz compinit
compinit

load_plugin() {
	local dir="$1"

	if [[ -f "$dir/init.zsh" ]]; then
		source "$dir/init.zsh"
		return
	fi

	local name="${dir:t}"

	if [[ -f "$dir/$name.zsh" ]]; then
		source "$dir/$name.zsh"
		return
	fi

	echo "[zsh] plugin not found: $dir"
}

load_plugin "$DOTFILES_ZSH/plugins/zsh-autosuggestions"
load_plugin "$DOTFILES_ZSH/plugins/zsh-syntax-highlighting"

autoload -Uz compinit
compinit