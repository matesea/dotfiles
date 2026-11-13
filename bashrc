if ls --color -d . >/dev/null 2>&1; then
    alias ls='ls --color'
else
    # for BSD ls
    export CLICOLOR=1
fi
alias d='cd'
alias ll='ls -l'
alias la='ls -la'
alias lh='ls -lh'

alias recal='history |grep -i'
alias grep='grep --color=auto'
alias g='global'
unset command_not_found_handle

shopt -s cdspell
shopt -s extglob
shopt -s histappend
shopt -s checkwinsize
shopt -s globstar
# auto enter directory with cd
shopt -s autocd

# readline settings only make sense with line editing,
# skip them for non-interactive shells (ssh host cmd, bash -lc ...)
if [[ $- == *i* ]]; then
    set -o vi
    bind 'set show-all-if-ambiguous on'
    bind 'set completion-ignore-case on'
    bind 'set colored-stats on'
    bind 'set mark-symlinked-directories on'
    # shift-tab to cycle through completions
    bind '"\e[Z":menu-complete'
fi

# history: unlimited, timestamped, shared across sessions
# ignoreboth: skip duplicates and commands starting with a space
export HISTCONTROL=ignoreboth:erasedups
export HISTSIZE=-1
export HISTFILESIZE=-1
export HISTTIMEFORMAT="%F %T "
[[ $PROMPT_COMMAND == *"history -a"* ]] ||
    PROMPT_COMMAND="history -a${PROMPT_COMMAND:+; $PROMPT_COMMAND}"

# go up N-th level or directory name match regex
function cd_up() {
    case $1 in
        *[!0-9]*)
            # regex case
            # search argu1 in current path
            cd "$(pwd | sed "s|\(.*/$1[^/]*/\).*|\1|")"
            ;;
        *)
            # cd ../../ (N dirs)
            cd "$(printf "%0.0s../" $(seq 1 "$1"))"
            ;;
    esac
}
alias 'u'='cd_up'

if [[ ${EUID} == 0 ]] ; then
	PS1='\[\033[01;31m\]\h\[\033[01;34m\] \W \$\[\033[00m\] '
else
	PS1='\[\033[01;32m\]\u@\h\[\033[01;34m\] \w \$\[\033[00m\] '
fi

# import local setting
if [ -f "$HOME/.local/bashrc" ]; then
    source "$HOME/.local/bashrc"

    ##### example for .bashrc.local #####
    ## cofig HISTFILE
    ## extend PATH ##
    ## nvim ##
    # export XDG_CONFIG_HOME=<DATA_PATH>/.config
    # export XDG_DATA_HOME=<DATA_PATH>/.local/share
fi

# nvim path may depend on PATH & bashrc.local
if command -v nvim >/dev/null 2>&1; then
    alias vi='nvim'
    export VISUAL=nvim
else
    alias vi='vim'
    export VISUAL=vim
fi
export EDITOR="$VISUAL"

# zoxide
if command -v zoxide >/dev/null 2>&1; then
    eval "$(zoxide init bash)"
    # zi to cd with fzf, as zz
    # zq to query but don't cd, as zl
    alias zq='zoxide query'
fi

if [ -z "${dotfiles}" ] ; then
    dotfiles=${HOME}/dotfiles
fi

# import fzf bash completion & key-bindings
if [ -n "$fzf_path" ] ; then
    if [ -f "$fzf_path/.fzf.bash" ] ; then
        source "$fzf_path/.fzf.bash"
    fi
    unset fzf_path
elif [ -f "${XDG_CONFIG_HOME:-$HOME/.config}"/fzf/fzf.bash ]; then
    source "${XDG_CONFIG_HOME:-$HOME/.config}"/fzf/fzf.bash
elif [ -f ~/.fzf.bash ] ; then
    source ~/.fzf.bash
fi

if command -v fzf >/dev/null 2>&1; then
    if command -v rg >/dev/null 2>&1; then
        export FZF_DEFAULT_COMMAND='rg --no-messages --files --no-ignore 2>/dev/null'
    elif command -v fd >/dev/null 2>&1; then
        export FZF_DEFAULT_COMMAND='fd -t f -I 2>/dev/null'
    else
        export FZF_DEFAULT_COMMAND='
         (git ls-tree -r --name-only HEAD ||
             find . -path "*/\.*" -prune -o -type f -print -o -type l -print |
             sed s/^..//) 2> /dev/null'
    fi
    export FZF_DEFAULT_OPTS='--height 40% --border --bind "ctrl-t:toggle-all,ctrl-d:deselect-all"'
    # To apply the command to CTRL-T as well
    export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
    # Alt-C: cd into a subdirectory, same listing as `zd`
    if command -v fd >/dev/null 2>&1; then
        export FZF_ALT_C_COMMAND='fd -t d 2>/dev/null'
    fi

    if [ -f "${dotfiles}/bash/fzf.sh" ] ; then
        source "${dotfiles}/bash/fzf.sh"
    fi
    alias zr='zd -r'
    alias zf='zd -f'
fi

if [ -f "${dotfiles}/ignore" ] ; then
    alias rg="rg --ignore-file ${dotfiles}/ignore --smart-case"
    alias ag="ag --path-to-ignore ${dotfiles}/ignore"
else
    alias rg="rg --smart-case"
fi

# compress a directory into <dir>.tar.gz, then remove the directory
function targz() {
    local dir=${1%/}
    [ -n "$dir" ] && [ -d "$dir" ] || { echo "usage: targz <dir>"; return 1; }
    tar --use-compress-program=pigz -cf "${dir}.tar.gz" "${dir}" && rm -rf "${dir}"
}

# gcd: navigate to project root
function gcd() {
    local dir=$PWD
    local gitroot
    gitroot=$(git rev-parse --show-toplevel 2>/dev/null)

    if [ -n "$gitroot" ]; then
        cd "$gitroot"
        return
    fi
    while [ "$dir" != "/" ]; do
        if [ -e "$dir/.git" ] || [ -e "$dir/.repo" ] || [ -e "$dir/GTAGS" ]; then
            cd "$dir"
            return
        fi
        dir=$(dirname "$dir")
    done
}

# open files that define the given symbol (GNU global)
function vg() {
    if [ -e GTAGS ]; then
        "${EDITOR:-vim}" $(global "$1")
    fi
}
