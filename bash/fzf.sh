# fl - git log selected files
fl() {
  local files
  IFS=$'\n' files=($(fzf-tmux --query="$1" --multi --select-1 --exit-0))
  [[ -n "$files" ]] && git log "${files[@]}"
}

# _fd - cd to selected directory
_fd() {
  local dir
  dir="$(
    fd "${1:-.}" -t d 2> /dev/null \
      | fzf +m
  )" || return
  cd "$dir" || return
}

# _fda - including hidden directories
_fda() {
  local dir
  dir="$(
    fd "${1:-.}" -t d --hidden 2> /dev/null \
      | fzf +m
  )" || return
  cd "$dir" || return
}

# _fdr - cd to selected parent directory
_fdr() {
  local dirs=()
  local parent_dir

  get_parent_dirs() {
    if [[ -d "$1" ]]; then dirs+=("$1"); else return; fi
    if [[ "$1" == '/' ]]; then
      for _dir in "${dirs[@]}"; do echo "$_dir"; done
    else
      get_parent_dirs "$(dirname "$1")"
    fi
  }

  parent_dir="$(
    get_parent_dirs "$(realpath "${1:-$PWD}")" \
      | fzf +m
  )" || return

  cd "$parent_dir" || return
}

# _fst - cd into the directory from stack
_fst() {
  local dir
  dir="$(
    dirs \
      | sed 's#\s#\n#g' \
      | uniq \
      | sed "s#^~#$HOME#" \
      | fzf +s +m -1 -q "$*"
  )"
  # $dirの存在を確かめないとCtrl-Cしたとき$HOMEにcdしてしまう
  if [[ -d "$dir" ]]; then
    cd "$dir" || return
  fi
}

# _cdf - cd into the directory of the selected file
_cdf() {
  local file
  file="$(fzf +m -q "$*")"
  cd "$(dirname "$file")" || return
}

zd() {
  read -r -d '' helptext <<EOF
usage: zd [OPTIONS]
  zd: cd to selected options below
OPTIONS:
  -d [path]: Directory (default)
  -a [path]: Directory included hidden
  -r [path]: Parent directory
  -s [query]: Directory from stack
  -f [query]: Directory of the selected file
  -h: Print this usage
EOF

  usage() {
    echo "$helptext"
  }

  if [[ -z "$1" ]]; then
    # no arg
    _fd
  elif [[ "$1" == '..' ]]; then
    # arg is '..'
    shift
    _fdr "$1"
  elif [[ "$1" == '-' ]]; then
    # arg is '-'
    shift
    _fst "$*"
  elif [[ "${1:0:1}" != '-' ]]; then
    # first string is not -
    _fd "$(realpath "$1")"
  else
    # args is start from '-'
    while getopts darfszh OPT; do
      case "$OPT" in
        d) shift; _fd  "$1";;
        a) shift; _fda "$1";;
        r) shift; _fdr "$1";;
        s) shift; _fst "$*";;
        f) shift; _cdf "$*";;
        h) usage; return 0;;
        *) usage; return 1;;
      esac
    done
  fi
}

# fe [FUZZY PATTERN] - Open the selected file with the default editor
#   - Bypass fuzzy finder if there's only one match (--select-1)
#   - Exit if there's no match (--exit-0)
fe() {
  local IFS=$'\n'
  local files=()
  files=(
    $(fzf-tmux \
          --query="$1" \
          --multi \
          --select-1 \
          --exit-0
    )
  ) || return
  "${EDITOR:-vim}" "${files[@]}"
}

frg() {
    local files

    [ ! -z "$1" ] || return
    files="$(rg -l "$1" 2>/dev/null)" || return
    files=(
    $(printf '%s' "$files" | fzf --multi --select-1)
        ) || return
    "${EDITOR:-vim}" "${files[@]}"
}

# fco - checkout git branch/tag
fco() {
  local tags
  local branches
  local target

  tags="$(
    git tag \
      | awk '{print "\x1b[31;1mtag\x1b[m\t" $1}'
  )" || return

  branches="$(
    git branch --all \
      | grep -v HEAD \
      | sed 's/.* //' \
      | sed 's#remotes/[^/]*/##' \
      | sort -u \
      | awk '{print "\x1b[34;1mbranch\x1b[m\t" $1}'
  )" || return

  target="$(
    printf '%s\n%s' "$tags" "$branches" \
      | fzf-tmux \
          -d20 \
          -- \
          --no-hscroll \
          --ansi \
          +m \
          -d '\t' \
          -n 2 \
          -1 \
          -q "$*"
  )" || return

  git checkout "$(echo "$target" | awk '{print $2}')"
}

# fshow - git commit browser
fshow() {
  local execute

  execute="grep -o \"[a-f0-9]\{7\}\" \
    | head -1 \
    | xargs -I % sh -c 'git show --color=always % | less -R'"

  git log \
    --graph \
    --color=always \
    --format="%C(auto)%h%d %s %C(black)%C(bold)%cr" "$@" \
    | fzf \
        --ansi \
        --no-sort \
        --reverse \
        --tiebreak=index \
        --bind=ctrl-s:toggle-sort \
        --bind "ctrl-m:execute: ($execute) <<'FZF-EOF'
  {}
FZF-EOF"
}
