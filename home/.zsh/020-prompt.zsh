# vim: set ft=sh:

autoload colors && colors

export VIRTUAL_ENV_DISABLE_PROMPT=1

export PROMPT_COMMAND='__prompt_command'

function __prompt_command() {
	local EXIT="$?"
	PROMPT=""

	local RCol="%{$reset_color%}"	# Text Reset
	# Regular                    Bold
	local Bla="%{$fg[black]%}"  ; local BBla="%{$fg_bold[black]%}"
	local Red="%{$fg[red]%}"    ; local BRed="%{$fg_bold[red]%}"
	local Gre="%{$fg[green]%}"  ; local BGre="%{$fg_bold[green]%}"
	local Yel="%{$fg[yellow]%}" ; local BYel="%{$fg_bold[yellow]%}"
	local Blu="%{$fg[blue]%}"   ; local BBlu="%{$fg_bold[blue]%}"
	local Pur="%{$fg[purple]%}" ; local BPur="%{$fg_bold[purple]%}"
	local Cya="%{$fg[cyan]%}"   ; local BCya="%{$fg_bold[cyan]%}"
	local Whi="%{$fg[white]%}"  ; local BWhi="%{$fg_bold[white]%}"

  local USER="%n"
  local HOST="%m"
  local WDIR="%~"
  local PROMPT_MARKER=" ->"
  local CLOCK_TIME="%*"

  PROMPT+="${Gre}${USER}${Blu}@${Yel}${HOST}${RCol}:${Cya}[${WDIR}]${RCol} "

  if [ $EXIT != 0 ]; then
    PROMPT+="${Red}(${EXIT})${RCol} "
  fi

  if [ "$VIRTUAL_ENV" != "" ]; then
    env=`echo "$VIRTUAL_ENV" | rev | cut -f 1 -d '/' | rev`
    PROMPT+="${BYel}.${env}.${RCol} "
  fi

  local NEWLINE=$'\n'

  cur_branch=$(git rev-parse --abbrev-ref HEAD 2>/dev/null)

  PROMPT+="${NEWLINE}${PROMPT_MARKER} "
  if [[ -n $cur_branch ]]; then
    RPROMPT="${Blu}${CLOCK_TIME}${Yel} ($cur_branch)${RCol}"
  else
    RPROMPT="${Blu}${CLOCK_TIME}${RCol}"
  fi
}
