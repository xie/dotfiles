autoload colors && colors

setopt histignorespace
setopt interactivecomments
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'

bindkey '^[[Z' reverse-menu-complete
bindkey '^R' history-incremental-search-backward

if [[ `uname` == 'Darwin' ]]; then
  platform='Mac'
elif [[ `uname` == 'Linux' ]]; then
  platform='Linux'
fi

[[ -f ~/.zshrc.local ]] && source ~/.zshrc.local

# ls colors
if [[ $platform == "Mac" ]]; then
  eval `gdircolors ~/.zsh/dir_colors`
  alias ls='gls --color'
else
  eval `dircolors ~/.zsh/dir_colors`
  alias ls='ls --color'
fi
zstyle ':completion:*' list-colors "${(@s.:.)LS_COLORS}"

case $- in
    *i*) ;;
      *) return;;
esac

export HISTCONTROL=ignoredups:erasedups  # no duplicate entries
export HISTSIZE=100000                   # big big history
export HISTFILESIZE=1000000               # big big history

#kills all *detached* screen sessions
killscreens () {
    screen -ls | grep Detached | cut -d. -f1 | awk '{print $1}' | xargs kill
}

function clip() {
  if command -v xclip 1>/dev/null; then
    if [[ -p /dev/stdin ]] ; then
      # stdin is a pipe
      # stdin -> clipboard
      xclip -i -selection clipboard
    else
      # stdin is not a pipe
      # clipboard -> stdout
      xclip -o -selection clipboard
    fi
  else
    echo "Remember to install xclip"
  fi
}

PERL_MB_OPT="--install_base \"/home/hormoz/.perl5\""; export PERL_MB_OPT;
PERL_MM_OPT="INSTALL_BASE=/home/hormoz/.perl5"; export PERL_MM_OPT;

RED="$fg[red]"
WHITE="$fg[white]"
NORMAL="$reset_color"

export NVM_DIR="/home/vagrant/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"  # This loads nvm

LS_COLORS='di=34:fi=0:ln=91:pi=5:so=5:bd=5:cd=5:or=31:mi=0:ex=32:*.rpm=90'
export LS_COLORS

if [[ -f /opt/dev/dev.sh ]] && [[ $- == *i* ]]; then
  source /opt/dev/dev.sh
fi

if type "__git_complete" > /dev/null 2>&1 ; then
  __git_complete g __git_main
fi

export PATH="$PATH:$HOME/.yarn/bin"
export PATH="$PATH:$HOME/.localbin"
