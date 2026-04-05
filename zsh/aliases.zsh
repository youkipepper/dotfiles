## packing
alias packz='f(){ zip -r "${1%/}.zip" "$1"; }; f'
alias packt='f(){ tar -czvf "${1%/}.tar.gz" "$1"; }; f'

alias lsa='lsd -alh'

alias comfy='conda activate comfyui && cd ~/Desktop/Code/ComfyUI && python main.py'

alias mtlhub='env MTL_HUD_ENABLED=1'

## fastfetch
for i in {2..31}; do
	alias f$i="fastfetch -c examples/$i.jsonc"
done
alias fa='fastfetch -c all'

alias dot='cd ~/dotfiles && nvim .'
alias dotc='cd ~/dotfiles && code .'
alias dotpull='git -C ~/dotfiles pull'
alias dotpush='cd ~/dotfiles && gacp'

alias reload='source ~/.zshrc'

alias ptest='curl -I --max-time 5 https://www.google.com'

alias python='python3'
alias pip='pip3'