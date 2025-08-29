export ZSH="$HOME/.oh-my-zsh"
export ELECTRON_OZONE_PLATFORM_HINT=wayland

plugins=(git zsh-autosuggestions zsh-syntax-highlighting dirhistory aliases)
source $ZSH/oh-my-zsh.sh

alias ls="exa -la --icons=always --no-permissions --no-time --no-user --no-filesize"
alias cd="z"
alias cat="bat"
alias alacritty-nvim='alacritty --config-file \
~/.config/alacritty/alacritty_nvim.yml -e nvim'

eval "$(starship init zsh)"
eval "$(zoxide init zsh)"
eval "$(thefuck --alias)"
eval "$(thefuck --alias fk)"
