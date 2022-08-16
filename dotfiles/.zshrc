#================#
# Auto-generated #
#================#
# Lines configured by zsh-newuser-install
HISTFILE=~/.histfile
HISTSIZE=20000
SAVEHIST=20000
setopt appendhistory autocd extendedglob notify
bindkey -v
# End of lines configured by zsh-newuser-install
# The following lines were added by compinstall
zstyle :compinstall filename '$HOME/.zshrc'

autoload -Uz compinit
compinit
# End of lines added by compinstall

autoload -U zmv

#=======#
# Zplug #
#=======#
source ~/.zplug/init.zsh

# Themes
zplug "bhilburn/powerlevel9k", use:powerlevel9k.zsh-theme

# Completion
zplug "zsh-users/zsh-autosuggestions"

# Functionality
zplug "changyuheng/zsh-interactive-cd"
zplug "hlissner/zsh-autopair", defer:2
zplug "Tarrasch/zsh-bd"
zplug "laurenkt/zsh-vimto"
zplug "lukechilds/zsh-nvm"  # Node version manager

# Install plugins if there are plugins that have not been installed
if ! zplug check --verbose; then
    printf "Install? [y/N]: "
    if read -q; then
        echo; zplug install
    fi
fi

# Load plugins
zplug load

#=======================#
# Aliases and functions #
#=======================#

# Aptitude
alias apt-i="sudo apt install"
alias apt-u="sudo apt update; sudo apt upgrade"

# Pacman/yay
alias yay-i="yay -S"
alias yay-s="yay -Ss"
alias yay-u="yay -Syu"
alias yay-us='yay -S `pacman -Qu | cut -d" " -f1 | fzf -m`'
alias yay-usa='yay -S `yay -Qu | cut -d" " -f1 | fzf -m`'
alias yay-r="yay -R"

# Git clone from clipboard
gcx() {
  git clone `xclip -o -selection clipboard`
}

# Query cht.sh
cht() {
  curl cht.sh/$1
}

alias ls="ls --color=auto"
alias la="ls --color=auto -A"
alias lr="ls --color=auto -R"  # tree is honestly better
alias ll="ls --color=auto -lh"
alias lla="ls --color=auto -lhA"
alias lal="ls --color=auto -lhA"
alias -g xclo="xclip -o -selection clipboard"
alias -g xcli="xclip -i -selection clipboard"
alias mux="tmuxinator"
alias f="fzf"
alias ft="fzf-tmux"
alias :q="exit"
alias v="nvim"
alias pn="pnpm"

#================#
# Path additions #
#================#

typeset -U path  # Keep only first occurence of each duplicate value

path+="$HOME/.bin"
path+="$HOME/.local/bin"
path+="$HOME/bin"
path+="$HOME/.npm-global/bin"
path+="$HOME/.mix"
path+="$HOME/.cargo/bin"
path+="$HOME/.azure/bin"
command -v ruby &>/dev/null && path+="$(ruby -e 'print Gem.user_dir')/bin"
command -v go &>/dev/null && path+="$(go env GOPATH)/bin"

export PATH
command -v go &>/dev/null && export GOPATH="$(go env GOPATH)"

#===============#
# Powerlevel 9k #
#===============#
POWERLEVEL9K_MODE='nerdfont-complete'
POWERLEVEL9K_PROMPT_ON_NEWLINE=true
POWERLEVEL9K_PROMPT_ADD_NEWLINE=true

DEFAULT_USER="$(whoami)"
POWERLEVEL9K_LEFT_PROMPT_ELEMENTS=(context dir vcs)
POWERLEVEL9K_RIGHT_PROMPT_ELEMENTS=(status virtualenv root_indicator background_jobs)

POWERLEVEL9K_MULTILINE_FIRST_PROMPT_PREFIX=""
POWERLEVEL9K_MULTILINE_LAST_PROMPT_PREFIX="|> "

#=======#
# Misc. #
#=======#
export EDITOR="nvim"
export LIBVIRT_DEFAULT_URI="qemu:///system"
export MYGITDIR="$HOME/Git"
export LESS="IFR"
export RIPGREP_CONFIG_PATH="$HOME/.config/ripgrep"

# GPG SSH agent
export GPG_TTY="$(tty)"
export SSH_AUTH_SOCK="/run/user/$UID/gnupg/S.gpg-agent.ssh"
gpg-connect-agent updatestartuptty /bye > /dev/null

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
[[ -f ~/.config/tabtab/zsh/__tabtab.zsh ]] && . ~/.config/tabtab/zsh/__tabtab.zsh || true
