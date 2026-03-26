# ----------------------------
# Common environment settings
# ----------------------------

export PATH="$HOME/bin:$PATH"
export EDITOR="nvim"

# Load private overrides
PRIVATE_ENV="$HOME/.config/dotfiles/env.local.zsh"
if [ -f "$PRIVATE_ENV" ]; then
    . "$PRIVATE_ENV"
fi