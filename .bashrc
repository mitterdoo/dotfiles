#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

alias ls='ls --color=auto'
alias grep='grep --color=auto'
export PS1="\[\033[38;5;85m\]\u@\h\[$(tput sgr0)\][\w]\\$ \[$(tput sgr0)\]"

# fuzzy finder
eval "$(fzf --bash)"

HCONF="/home/ranthos/.config/hypr/hyprland.conf"
NVCONF="/home/ranthos/.config/nvim/lua/config/prefs.lua"

alias dotfiles="/usr/bin/git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME"

neofetch
# if [ -z $DISPLAY ]; then
	
# fi
