platform='unknown'
unamestr=$(uname)
if [[ "$unamestr" == 'Darwin' ]]; then
  platform='Mac'
elif [[ "$unamestr" == 'Linux' ]]; then
  platform='Linux'
fi

if [[ -f $HOME/.zsh_aliases.local ]]; then
  source $HOME/.zsh_aliases.local
fi

if [[ $platform == 'Linux' ]]; then
  alias ls='ls --color'
  alias la='ls -altur | tail -n20'
  function lc () { ls -altr $@ | tail -n20; }
  alias ll='ls -alr'
  alias l='ls -al'
  alias open='exo-open'
elif [[ $platform == 'Mac' ]]; then
  alias la='ls -altur | tail -n20'
  function lc () { ls -altr $@ | tail -n20; }
  alias ll='ls -alr'
  alias l='ls -CF'
  alias readlink='greadlink'
  alias find='gfind'
  alias xargs='gxargs'
  alias vlc='/Applications/VLC.app/Contents/MacOS/VLC -f'
  function renametab () { echo -ne "\033]0;"$@"\007"; }
fi

if [ -x "$(command -v nvim)" ]; then alias vim='nvim'; fi

alias delugec='deluge-console'
function find_all_videos() { find "$@" -iregex ".*\(m4v\|mpg\|mov\|webm\|mp4\|flv\|wmv\|avi\|mkv\)" -type f -printf "%Ty%Tm%Td%TH%TM%s %p\n"; }
function mpa() { find_all_videos "$@" | sort -r | cut -d " " -f 2- | shuf | xargs -d "\n" mpv -ontop 2&>/dev/null & }
function fpa() { 
  q="$1"
  shift
  # find_all_videos "$@" -iname "*"$q"*" | sort -r | cut -d " " -f 2- | xargs -d "\n" mpv -fs; 
  fzf -f "$@" | xargs -d "\n" mpv -fs; 
}
function pa() { find_all_videos "$@" | sort -r | cut -d " " -f 2- | xargs -d "\n" mpv --image-display-duration=0 --volume=0 2&>/dev/null & }

function find_all_images() { find "$@" -iregex ".*\(png\|jpeg\|jpg\|gif\)" -type f; }
function fea() { find_all_images "$@" | xargs -d "\n" feh --auto-zoom --scale-down; }

alias cdm='cd $HOME/media'
alias cdseedbox='cd /media/Expansion/soulseek-downloads/seedbox/'
alias clones='echo "use dc"'
alias cn='cat ~/notes'
alias couchpotato='sudo /etc/init.d/couchpotato start'
alias dd='cd ~/d'
alias dc='cd ~/d/c'
alias ds='cd ~/d/s'
alias dt='cd ~/d/t'
alias dg='cd ~/d/go/src'
alias dgs='cd ~/d/go/src/github.com/Shopify'
alias dgh='cd ~/d/go/src/github.com/hkdsun'
alias dgb='cd ~/d/go/src/bitbucket.org/hkdsun'
alias dss='cd ~/d/s/shopify'
alias dsk='cd ~/d/s/activefailover'
alias dsm='cd ~/d/s/shopify-m'
alias dsn='cd ~/d/s/shopify-n'
alias dotcd='homesick cd dotfiles'
alias dotcom='homesick exec dotfiles "git add --all :/" && homesick commit dotfiles && homesick push dotfiles'
alias dotdiff='homesick diff dotfiles'
alias dotpull='homesick pull dotfiles && homesick symlink dotfiles'
alias dotpush='homesick push dotfiles'
alias dotst='homesick status dotfiles'
alias en='vim ~/notes'
alias hf='sudo speaker-on'
alias ho='sudo speaker-off'
alias ig='grep -Rin  -C1 --color=auto'
alias ignpl='grep -nRi -C1 --color=auto --include="*src*npl"'
alias igscala='grep -Rin -C1  --color=auto --include="*src*scala"'
alias igsrc='grep -nRi -C1 --color=auto --include="*src*"'
alias irssi='irssi -n i'
alias latexrm='latexmk -c'
alias latexwa='latexmk -xelatex -interaction=nonstopmode -pdf -pvc'
alias playlist='mplayer -playlist'
alias sb='source $HOME/.zshrc'
alias scratch='cd $HOME/d/scratch'
alias screenoff='sleep 1; xset dpms force off'
alias vimscala='vim $(find . -type f -name "*.scala")'
alias vimtex='vim $(find . -type f -name "*.tex")'
alias pf='pioneer-off.py'
alias qk='workon qkdiary'
alias youtube='youtube-dl --playlist-end 1 --restrict-filenames -w -o "/home/hormoz/media/Music/videos/%(title)s.%(ext)s"'
alias curljson='curl -H "Content-Type: application/json"'
alias pam='find . -type f | shuf | xargs -d "\n" mplayer -xy 320 -ontop -nofs -geometry 0%:100%'
alias mount_uw='mkdir /Volumes/smb && mount -t smbfs //hkheradm@ecfile1.uwaterloo.ca/hkheradm /Volumes/smb'
alias umount_uw='umount /Volumes/smb'
function pview() { zathura "$@" > /dev/null 2>&1 & }
alias xargsn='tr "\n" "\0" | xargs -0'
alias xxargs='xargs -d "\n"'

# Finder
alias showFiles='defaults write com.apple.finder AppleShowAllFiles YES; killall Finder /System/Library/CoreServices/Finder.app'
alias hideFiles='defaults write com.apple.finder AppleShowAllFiles NO; killall Finder /System/Library/CoreServices/Finder.app'

alias todo='cat .TODO'

alias ka9='killall -9'
alias k9='kill -9'

# Show human friendly numbers and colors
alias df='df -h'
alias du='du -h -d 2'

# YADR support
alias yav='yadr vim-add-plugin'
alias ydv='yadr vim-delete-plugin'
alias ylv='yadr vim-list-plugin'
alias yup='yadr update-plugins'
alias yip='yadr init-plugins'

alias tar_backup='tar -cvpzf mbp_home_backup.tar.gz --exclude mbp_home_backup_tar.gz --one-file-system'


alias vs='cd ~/d/shopify-vagrant && vagrant ssh'
alias vu='cd ~/d/shopify-vagrant && vagrant up'
alias update_vagrant='cd ~/d/shopify-vagrant/ && git pull origin master && vagrant up && vagrant provision'

alias ura='gfop && bundle install && bundle exec rake db:migrate db:test:prepare'
alias gfop='gfo && git pull'
alias gfo='git fetch --prune origin'
alias gcr='git commit --amend --reuse-message=HEAD'
alias gds='git diff --staged'
alias gs='git status'
alias gd='git diff'
alias gc='git commit'
alias gp='git push'
alias gpp='git pull'
alias gpm='git pull origin master'
alias squash='git rebase -i $(git merge-base HEAD master)'

alias pusht='pushbullet push nexus note '

alias ncr='ncmpcpp -h raspberrypi.local'
alias ncc='ncmpcpp'
alias g='hub'

alias tt='tmux'
alias ta='tmux a'
alias tat='tmux a -t'
alias tls='tmux list-sessions'
alias feh='feh --scale-down --auto-zoom'
alias xclip='xclip -selection clipboard'
alias mp='mpv --volume=100'
alias speaker-on='spkctl on'
alias speaker-off='spkctl off'
alias matlab='matlab -nodesktop -nosplash'
alias vn='vim -c "VimwikiIndex" -c "cd ~/Documents/Vimwiki/notes/"'
alias vnn='vim -c "VimwikiIndex" -c "cd ~/Documents/Vimwiki/notes/" -c "FZF"'
alias vnc='cd ~/Documents/Vimwiki/notes/'

alias k='kubectl'
alias dx='docker exec -it'

alias t1e4='k --context "tier1-us-east-4"'
alias t1e5='k --context "tier1-us-east-5"'
alias t1c4='k --context "tier1-us-central-4"'
alias t1c5='k --context "tier1-us-central-5"'
alias se4='k --context "tier1-us-east-4" -n shopify-core'
alias se5='k --context "tier1-us-east-5" -n shopify-core'
alias sc4='k --context "tier1-us-central-4" -n shopify-core'
alias sc5='k --context "tier1-us-central-5" -n shopify-core'
alias redist1c1='k --context "redis-tier1-us-central1-1"'
alias redist1e1='k --context "redis-tier1-us-east1-1"'

# private
alias permsp='find . -type f ! -executable -exec chmod 600 {} \; && find . -type f -executable -exec chmod 700 {} \; && find . -type d -exec chmod 700 {} \;'
# user (writer)
alias permsu='find . -type f ! -executable -exec chmod 644 {} \; && find . -type f -executable -exec chmod 755 {} \; && find . -type d -exec chmod 755 {} \;'
# group (writer)
alias permsg='find . -type f ! -executable -exec chmod 664 {} \; && find . -type f -executable -exec chmod 775 {} \; && find . -type d -exec chmod 775 {} \;'

alias kctx='kubectx'
alias kns='kubens'
alias latexmk='latexmk -view=pdf'
alias ytdl='youtube-dl'
