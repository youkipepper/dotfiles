source ~/dotfiles/zsh/aliases.zsh
source ~/dotfiles/zsh/exports.zsh
source ~/dotfiles/zsh/functions.zsh
source ~/dotfiles/zsh/plugins.zsh
source ~/dotfiles/zsh/env.zsh

## starship
eval "$(starship init zsh)"

# Load private overrides
PRIVATE_ENV="$HOME/dotfiles/zsh/env.local.zsh"
if [ -f "$PRIVATE_ENV" ]; then
    . "$PRIVATE_ENV"
fi