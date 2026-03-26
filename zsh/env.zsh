# ## conda
# __conda_setup="$('/opt/homebrew/anaconda3/bin/conda' 'shell.zsh' 'hook' 2>/dev/null)"
# if [ $? -eq 0 ]; then
# 	eval "$__conda_setup"
# else
# 	if [ -f "/opt/homebrew/anaconda3/etc/profile.d/conda.sh" ]; then
# 		. "/opt/homebrew/anaconda3/etc/profile.d/conda.sh"
# 	else
# 		export PATH="/opt/homebrew/anaconda3/bin:$PATH"
# 	fi
# fi
# unset __conda_setup
# # <<< conda initialize <<<

# >>> conda initialize >>>
if command -v conda >/dev/null 2>&1; then
    # Use conda's shell hook if available
    __conda_setup="$(conda 'shell.zsh' 'hook' 2>/dev/null)"
    if [ $? -eq 0 ]; then
        eval "$__conda_setup"
    else
        # fallback to sourcing conda.sh if it exists
        if [ -f "$HOME/anaconda3/etc/profile.d/conda.sh" ]; then
            . "$HOME/anaconda3/etc/profile.d/conda.sh"
        elif [ -f "$HOME/miniconda3/etc/profile.d/conda.sh" ]; then
            . "$HOME/miniconda3/etc/profile.d/conda.sh"
        fi
    fi
    unset __conda_setup
fi
# <<< conda initialize <<<