# fzf helpers, sourced from bashrc when fzf is available.
# Ctrl-T / Ctrl-R / Alt-C and `**<TAB>` completion come from `fzf --bash`.

# -----------------------------------------------------------------------------
# files
# -----------------------------------------------------------------------------

# fe [QUERY] - open the selected files with the editor
#   skips the finder when there is exactly one match, exits when there is none
fe() {
  local files
  mapfile -t files < <(fzf --query="$1" --multi --select-1 --exit-0)
  (( ${#files[@]} )) && "${EDITOR:-vim}" "${files[@]}"
}

# fl [QUERY] - git log of the selected files
fl() {
  local files
  mapfile -t files < <(fzf --query="$1" --multi --select-1 --exit-0)
  (( ${#files[@]} )) && git log -- "${files[@]}"
}

# frun [QUERY] - select and run an executable under the current folder
frun() {
  local file
  file=$(find . -type f -executable | fzf --query="$1" --select-1 --exit-0) &&
    "$file"
}

# fcmp DIR - diff a file under pwd against a file under DIR
fcmp() {
  [ -n "$1" ] || { echo "usage: fcmp <dir>"; return 1; }
  local file1 file2
  file1=$(rg --no-messages --files | fzf) || return
  file2=$(rg --no-messages --files "$1" | fzf) || return
  "${EDITOR:-vim}" -d "$file1" "$file2"
}

# frg PATTERN - rg for a fixed string, pick a match, open the editor at that line
frg() {
  [ -n "$1" ] || { echo "usage: frg <pattern>"; return 1; }
  local sel file line
  sel=$(
    rg -F --line-number --no-heading --color=always "$1" |
      fzf --ansi --delimiter : --select-1 --exit-0 \
          --preview 'bat --color=always --style=numbers --highlight-line {2} {1} 2>/dev/null || cat -n {1}' \
          --preview-window '+{2}/2'
  ) || return
  file=${sel%%:*}
  line=${sel#*:}; line=${line%%:*}
  "${EDITOR:-vim}" "+$line" "$file"
}

# -----------------------------------------------------------------------------
# directories: zd
# -----------------------------------------------------------------------------

# cd to a subdirectory (8 levels deep)
_fd() {
  local dir
  dir=$(fd . "${1:-.}" -t d -d 8 2>/dev/null | fzf +m) && cd "$dir"
}

# cd to a subdirectory, hidden ones included
_fda() {
  local dir
  dir=$(fd . "${1:-.}" -t d --hidden 2>/dev/null | fzf +m) && cd "$dir"
}

# cd to a parent directory
_fdr() {
  local dir parents=()
  dir=$(realpath "${1:-$PWD}") && [ -d "$dir" ] || return
  while :; do
    parents+=("$dir")
    [ "$dir" = / ] && break
    dir=$(dirname "$dir")
  done
  dir=$(printf '%s\n' "${parents[@]}" | fzf +m) && cd "$dir"
}

# cd to a directory from the directory stack
_fst() {
  local dir
  dir=$(dirs -l -p | awk '!seen[$0]++' | fzf +s +m -1 -q "$*")
  # check that $dir exists, otherwise cancelling fzf would cd to $HOME
  [ -d "$dir" ] && cd "$dir"
}

# cd to the directory of the selected file
_cdf() {
  local file
  file=$(fzf +m -q "$*") && cd "$(dirname "$file")"
}

zd() {
  case "$1" in
    '')  _fd ;;
    ..)  _fdr "$2" ;;
    -)   shift; _fst "$*" ;;
    -d)  _fd "$2" ;;
    -a)  _fda "$2" ;;
    -r)  _fdr "$2" ;;
    -s)  shift; _fst "$*" ;;
    -f)  shift; _cdf "$*" ;;
    -h|-*)
      cat <<'EOF'
usage: zd [OPTION] [ARG]
  zd [path]     cd to a subdirectory of path (default: .)
  zd .. [path]  cd to a parent directory
  zd - [query]  cd to a directory from the stack
OPTIONS:
  -d [path]   subdirectory (default)
  -a [path]   subdirectory, hidden ones included
  -r [path]   parent directory
  -s [query]  directory from the stack
  -f [query]  directory of the selected file
  -h          print this usage
EOF
      [ "$1" = -h ] ;;
    *)   _fd "$1" ;;
  esac
}

# -----------------------------------------------------------------------------
# git
# -----------------------------------------------------------------------------

# fco [QUERY] - checkout a git branch or tag
fco() {
  git rev-parse --git-dir >/dev/null || return
  local target
  target=$(
    {
      git tag | awk '{print "\x1b[31;1mtag\x1b[m\t" $1}'
      {
        git for-each-ref --format='%(refname:lstrip=2)' refs/heads
        git for-each-ref --format='%(refname:lstrip=3)' refs/remotes
      } | grep -vx HEAD | sort -u | awk '{print "\x1b[34;1mbranch\x1b[m\t" $1}'
    } | fzf --ansi --no-hscroll +m -d '\t' -n 2 -1 -q "$*"
  ) || return
  git checkout "${target#*$'\t'}"
}

# fshow [git log args] - git commit browser
#   preview shows the commit, enter opens it in less, ctrl-s toggles sorting
fshow() {
  local sha='echo {} | grep -o "[a-f0-9]\{7,\}" | head -1'
  git log --graph --color=always \
      --format='%C(auto)%h%d %s %C(dim)%cr' "$@" |
    fzf --ansi --no-sort --reverse --tiebreak=index \
        --bind=ctrl-s:toggle-sort \
        --preview "$sha | xargs -r git show --color=always" \
        --bind "enter:execute($sha | xargs -r -I % sh -c 'git show --color=always % | less -R')"
}

# -----------------------------------------------------------------------------
# tmux
# -----------------------------------------------------------------------------

# fs [QUERY] - switch to (or attach) a tmux session
fs() {
  local session
  session=$(
    tmux list-sessions -F '#{session_name}' |
      fzf --query="$1" --select-1 --exit-0
  ) || return
  if [ -n "$TMUX" ]; then
    tmux switch-client -t "$session"
  else
    tmux attach -t "$session"
  fi
}

# ftpane - switch to another pane in the current session
ftpane() {
  local current target
  current=$(tmux display-message -p '#{pane_id}')
  target=$(
    tmux list-panes -s -F '#{pane_id} #I.#P  #{pane_current_path}  #{pane_current_command}' |
      awk -v cur="$current" '$1 != cur' |
      fzf +m --reverse --height=100% --with-nth=2..
  ) || return
  target=${target%% *}
  tmux select-window -t "$target" && tmux select-pane -t "$target"
}
