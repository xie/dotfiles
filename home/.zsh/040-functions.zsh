#!/bin/bash

function agree() {
  while true; do
    if [ "${2:-}" = "Y" ]; then
      prompt="Y/n"
      default=Y
    elif [ "${2:-}" = "N" ]; then
      prompt="y/N"
      default=N
    else
      prompt="y/n"
      default=
    fi

    NEWLINE=$'\n'
    read -q "REPLY?$1 [$prompt] ${NEWLINE}" </dev/tty

    if [ -z "$REPLY" ]; then
      REPLY=$default
    fi

    case "$REPLY" in
      Y*|y*) return 0 ;;
      N*|n*) return 1 ;;
    esac
  done
}

function touched { git diff --name-status $@ | cut -f 2-; }
function rt { bundle exec ruby -Itest $@; }
function rtf { rt $@ -n /focus/; }
function delete_ignored_files() { git rm --cached `git ls-files -i --exclude-from=.gitignore`; }
function f { q="$1"; shift; find . -iname "*"$q"*" $@;}
function cr() { vim $(git status --porcelain | cut -d ' ' -f 3-); }
function def() { curl -s dict://dict.org/d:$1 | awk '{ if( $1 == "151" ) { print $1, "\n\n+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++\n" } else print $0 }' | grep -v "[0-9][0-9][0-9]" | grep -v -x ".."; }
function youtube-search() { youtube-dl --playlist-end 1 --restrict-filenames -w  -o "/home/hormoz/media/Music/videos/%(title)s.%(ext)s" "https://www.youtube.com/results?search_query='$1'"; }
function ytmp3() { youtube-dl "$1" -x --audio-format mp3 }

function vimsha() {
  files=""
  for i in $(seq 0 $(($1-1)))
  do
    files="$files $(git show HEAD~$i --oneline --name-only | tail +2)"
    echo $files
  done
  vim $files
}

function gP() {
  branch_name=$(git rev-parse --abbrev-ref HEAD)
	if agree "WARNING: FORCE BRANCH $RED$branch_name$NORMAL" N; then
    git push --force origin "$branch_name"
  else
    echo "Aborted push."
  fi
}

function git_untracked() {
  expr `git status --porcelain 2>/dev/null| grep "^??" | wc -l`
}

function git_dirty() {
  [[ $(git diff --shortstat 2> /dev/null | tail -n1) != "" ]] && return 0
  return 1
}

function git_untracked_or_dirty() {
  git_dirty && return 0
  [[ $(git_untracked) -ge "1" ]] && return 0
  return 1
}

# workaround for matplotlib (http://matplotlib.org/faq/osx_framework.html#pythonhome-function)
function frameworkpython {
    if [[ ! -z "$VIRTUAL_ENV" ]]; then
        PYTHONHOME=$VIRTUAL_ENV /usr/bin/python "$@"
    else
        /usr/bin/python "$@"
    fi
}

function bitgit() {
    (git status 2>&1) >/dev/null

    if [[ "$?" != "0" ]]; then
        echo "Not a git repo"
        return
    fi


    read "username?Username: "
    read -s "pass?Password: "

    echo

    name=$(basename `pwd`)
    read "name_i?Repo Name [$name]: "
    if [[ -n "$name_i" ]]; then
        name="$name_i"
    fi

    private=""
    if agree "Private?" Y; then
        private="true"
    else
        private="false"
    fi

    curl --progress-bar --user "$username:$pass" https://api.bitbucket.org/1.0/repositories/ --data name="$name" --data is_private="$private" | jq .resource_uri
    echo

    git remote add origin "git@bitbucket.org:/$username/$name"

    if agree "Push repo?" Y; then
        git push -u origin master
    fi
}

function L() {
  if [[ $# -eq "0" ]]; then
    r 2>&1 | less
  else
    $@ | less
  fi
}

function review_old() {
  local default_branch=$(git rev-parse --abbrev-ref HEAD)
  local branch="${1:-$default_branch}"

  git fetch origin $branch
  git checkout $branch
  git rebase origin/$branch

  if [[ -a "dev.yml" ]]; then
    dev up
  fi

  merge_base=$(git merge-base HEAD master)
  vim -c "let g:gitgutter_diff_base = '$merge_base'" $(git diff --name-only $merge_base)
}

function rebase_master() {
  local default_branch=$(git rev-parse --abbrev-ref HEAD)
  local branch="${1:-$default_branch}"

  git fetch origin master
  git checkout $branch
  git rebase origin/master
}

function ag-replace() {
ag "$1" --files-with-matches | xargs perl -pi -e "s/$1/$2/g"
}

function kubessh() {
  if [ -z "$1" ]; then
    >&2 echo "missing pod name"
    return 1
  fi

  if [[ "$(kubectl get pods "$1" -n "${KUBECTL_NS}" 2>&1 || true)" == Error* ]]; then
    POD=$(kubectl get pods --selector="app=${1}" -n "${KUBECTL_NS}" | grep ' Running ' | awk '{print $1}')
    if [ -z "${POD}" ]; then
      return 1
    fi
  else
    POD=$1
  fi

  NODE=$(kubectl describe "pods/${POD}" -n "${KUBECTL_NS}" | grep 'Node: ' | awk '{ print $2 }' | cut -d'/' -f1)
  ZONE=$(kubectl describe "nodes/${NODE}" | grep failure-domain.beta.kubernetes.io/zone | cut -d'=' -f2)
  gcloud compute ssh "${NODE}" --zone "${ZONE}"
}

function parand() {
  cd $@
  dir="$(find . -type d -maxdepth 1 -mindepth 1 | shuf | head -1)"
  pa $dir
}

function ddsplunk() {
  earliest=$(echo $@ | grep -io "from_ts=\d\+" | cut -f 2 -d "=" | cut -c -10)
  latest=$(echo $@ | grep -io "to_ts=\d\+" | cut -f 2 -d = | cut -c -10)
  url="https://logs.shopify.io/en-US/app/search/search?earliest=$earliest&latest=$latest"
  echo $url
  open $url
}

function search-pr() {
  original_branch=$(git describe --all --contains "$1" | sed 's/~[0-9]//g' | sed 's/\^[0-9]//g' | cut -d '/' -f 3-)
  if [ -z $original_branch ]; then
    echo "Could not find remote branch for "$1""
    return 1
  fi

  org="Shopify"
  repo=$(basename $(pwd))

  open "https://github.com/$org/$repo/pulls?q=head%3A$original_branch"
}

function fix_core_migrations() {
  bundle exec rake db:drop
  ./bin/rails db:setup db:test:prepare
}
