typeset -g ZSH_CONFIG_DIR="${${(%):-%N}:A:h}"
typeset -g DOTFILES_DIR="${ZSH_CONFIG_DIR:h}"

source "$ZSH_CONFIG_DIR/env.zsh"
source "$ZSH_CONFIG_DIR/exports.zsh"

if [[ -f "$ZSH_CONFIG_DIR/env.local.zsh" ]]; then
	source "$ZSH_CONFIG_DIR/env.local.zsh"
fi

source "$ZSH_CONFIG_DIR/functions.zsh"
source "$ZSH_CONFIG_DIR/aliases.zsh"
source "$ZSH_CONFIG_DIR/plugins.zsh"

if command -v starship >/dev/null 2>&1; then
	eval "$(starship init zsh)"
fi

ZSH_SYNTAX_HIGHLIGHTING="$HOME/.zsh/plugins/zsh-syntax-highlighting"
if [[ -f "$ZSH_SYNTAX_HIGHLIGHTING/zsh-syntax-highlighting.zsh" ]]; then
	source "$ZSH_SYNTAX_HIGHLIGHTING/zsh-syntax-highlighting.zsh"
elif [[ -f "$ZSH_SYNTAX_HIGHLIGHTING/init.zsh" ]]; then
	source "$ZSH_SYNTAX_HIGHLIGHTING/init.zsh"
fi
unset ZSH_SYNTAX_HIGHLIGHTING
