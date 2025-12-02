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

# Git clone from clipboard
gcx() {
  git clone `xclip -o -selection clipboard`
}

# Query cht.sh
cht() {
  curl $(echo "cht.sh/$*" | sed 's/ /+/g')
}

alias ls="ls --color=auto"
alias -g xclo="xclip -o -selection clipboard"
alias -g xcli="xclip -i -selection clipboard"
alias :q="exit"
alias v="nvim"
alias pn="pnpm"
alias px="pnpm dlx"
alias s="kitty +kitten ssh"
alias t="task"

#=======#
# Misc. #
#=======#
export EDITOR="nvim"
export LIBVIRT_DEFAULT_URI="qemu:///system"
export MYGITDIR="$HOME/Git"
export LESS="IFR"

# Bitwarden SSH agent
export SSH_AUTH_SOCK="$HOME/.bitwarden-ssh-agent.sock"

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
[[ -f ~/.config/tabtab/zsh/__tabtab.zsh ]] && . ~/.config/tabtab/zsh/__tabtab.zsh || true
[ -f /opt/asdf-vm/asdf.sh ] && . /opt/asdf-vm/asdf.sh

#================#
# Path additions #
#================#

command -v go &>/dev/null && export GOPATH="$(go env GOPATH)"

typeset -U path  # Keep only first occurence of each duplicate value

path+="$HOME/.bin"
path+="$HOME/.local/bin"
path+="$HOME/bin"
path+="$HOME/.mix"
path+="$HOME/.cargo/bin"
path+="$HOME/.azure/bin"
path+="$HOME/.dotnet/tools"
path+="$HOME/.local/share/pnpm"
path+="/opt/nvim-linux-x86_64/bin"

command -v ruby &>/dev/null && path+="$(ruby -e 'print Gem.user_dir')/bin"
command -v go &>/dev/null && path+="$(go env GOPATH)/bin"

export PATH

# pnpm
export PNPM_HOME="$HOME/.local/share/pnpm"
case ":$PATH:" in
  *":$PNPM_HOME:"*) ;;
  *) export PATH="$PNPM_HOME:$PATH" ;;
esac
# pnpm end
