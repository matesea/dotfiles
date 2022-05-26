# fl - git log selected files
fl() {
  local files
  IFS=$'\n' files=($(fzf-tmux --query="$1" --multi --select-1 --exit-0))
  [[ -n "$files" ]] && git log "${files[@]}"
}

zcase() {
    local dir
    if [ -z "$__CASES" ]; then
        echo "variable __CASES not defined"
        return
    fi
    # adding trailing slash if not exist
    local cases=${__CASES}
    [[ "${cases}" != */ ]] && cases="${cases}/"

    local pattern="${cases//\//\\\/}"
    dir="$(
        find $cases -maxdepth 2 -mindepth 1 -type d -printf '%T@ %p\n' 2>/dev/null |sort -r |cut -d' ' -f2 \
            |sed "s#$pattern##" | fzf --no-sort)" || return
    cd "$prefix$cases$dir" || return
}

# jump into ramdump folder by finding dmesg_TZ.txt
# sort the result by time in reverse order
zrp() {
    local dir
    if [ -z "$__CASES" ]; then
        echo "variable __CASES not defined"
        return
    fi

    # adding trailing slash if not exist
    local cases="${__CASES/}/"
    [[ "${cases}" != */ ]] && cases="${cases}/"

    local pattern="${cases//\//\\\/}"
    dir="$(find $cases -name dmesg_TZ.txt -printf '%T@ %p\n' 2>/dev/null |sort -r |cut -d' ' -f2 \
        |sed "s#$pattern##" |fzf --no-sort)" || return
    cd $(dirname "$prefix$cases$dir") || return
}

# _fd - cd to selected directory
_fd() {
  local dir
  dir="$(
    fd "${1:-.}" -t d -d 2 2> /dev/null \
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
    $(fzf \
          --query="$1" \
          --multi \
          --select-1 \
          --exit-0
    )
  ) || return
  "${EDITOR:-vim}" "${files[@]}"
}

# select and run executable in this folder
frun() {
  local IFS=$'\n'
  local file=()
  file=(
    $(find . -type f -executable -print | fzf \
          --query="$1" \
          --select-1 \
          --exit-0
    )
  ) || return
  $file
}

# compare files in the same relative path
fcmp() {
  local IFS=$'\n'
  local file=()
  file=(
    $(fzf \
          --select-1 \
          --exit-0
    )
  ) || return
  "${EDITOR:-vim}" "${file}" "$1/${file}" -d
}

# compare files with diffent relative path
fncmp() {
    "${EDITOR:-vim}" -d $(fd "$1") $(fd "$1" "$2")
}

# grep/rg and jump to the line
frg() {
    local files
    local file
    local line
  # to avoid interrupted system call issue
  # https://unix.stackexchange.com/questions/486908/bash-echo-write-error-interrupted-system-call
  trap '' SIGWINCH


    [ ! -z "$1" ] || return
    files="$(rg -F "$1" --vimgrep --no-column 2>/dev/null)" || return
    files=(
        $(printf '%s' "$files" | fzf --select-1)
        ) || return
    file="$(echo "${files[@]}" |awk 'BEGIN{FS=":"}{print $1}')" || return
    line=$(echo "${files[@]}"  |awk 'BEGIN{FS=":"}{print $2}')
    "${EDITOR:-vim}" +$line "${file[@]}"
}

# fco - checkout git branch/tag
fco() {
  local tags
  local branches
  local target

  # to avoid interrupted system call issue
  # https://unix.stackexchange.com/questions/486908/bash-echo-write-error-interrupted-system-call
  trap '' SIGWINCH

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

  ## another implementation
  # local tags branches target
  # branches=$(
  #   git --no-pager branch --all \
  #   | sed '/^$/d') || return
  # tags=$(
  #   git --no-pager tag | awk '{print "\x1b[35;1mtag\x1b[m\t" $1}') || return
  # target=$(
  #   (echo "$branches"; echo "$tags") |
  #   fzf --no-hscroll --no-multi -n 2 \
  #       --ansi) || return
  # git checkout $(awk '{print $2}' <<<"$target" )
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

# -----------------------------------------------------------------------------
# tmux
# -----------------------------------------------------------------------------

# fs [FUZZY PATTERN] - Select selected tmux session
#   - Bypass fuzzy finder if there's only one match (--select-1)
#   - Exit if there's no match (--exit-0)
fs() {
  local session

  session="$(
    tmux list-sessions -F "#{session_name}" \
      | fzf-tmux \
          --query="$1" \
          --select-1 \
          --exit-0
  )" || return

  tmux switch-client -t "$session"
}

# ftpane - switch pane (@george-b)
ftpane() {
  local panes
  local current_window
  local current_pane
  local target
  local target_window
  local target_pane

  panes="$(
    tmux list-panes \
      -s \
      -F '#I:#P - #{pane_current_path} #{pane_current_command}'
  )"
  current_pane="$(tmux display-message -p '#I:#P')"
  current_window="$(tmux display-message -p '#I')"

  target="$(
    echo "$panes" \
      | grep -v "$current_pane" \
      | fzf +m --reverse
  )" || return

  target_window="$(
    echo "$target" \
      | awk 'BEGIN{FS=":|-"} {print$1}'
  )"

  target_pane="$(
    echo "$target" \
      | awk 'BEGIN{FS=":|-"} {print$2}' \
      | cut -c 1
  )"

  if [[ "$current_window" -eq "$target_window" ]]; then
    tmux select-pane -t "$target_window.$target_pane"
  else
    tmux select-pane -t "$target_window.$target_pane" \
      && tmux select-window -t "$target_window"
  fi
}

# select files and mirror into case folder
function mr() {
    if [ -z "$__CASES" ]; then
        echo "variable __CASES not defined"
        return
    fi
    echo "rsync into $__CASES/$(basename ${PWD})..."
    rsync --progress -avz $(fd -d 1| fzf -m) $__CASES/$(basename ${PWD})/
}
