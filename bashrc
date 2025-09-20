if ls --color -d . >/dev/null 2>&1; then
    alias ls='ls --color'
else
    # for BSD ls
    export CLICOLOR=1
fi
# if which rsync 1>/dev/null 2>&1; then
#     alias cp='rsync -avz'
# fi
alias d='cd'
alias ll='ls -l'
alias la='ls -la'
alias lh='ls -lh'

alias tmux='tmux -2'
alias recal='history |grep'
alias grep='grep --color -i'
alias g='global'
# alias v='f -e vim'
unset command_not_found_handle

shopt -s cdspell
shopt -s extglob
shopt -s histappend
set -o vi
export HISTTIMEFORMAT="%F %T "
#export XENVIRONMENT="/home/matesea/.Xdefaults.bak"

# tab completion
set show-all-if-ambiguous on
bind 'TAB:complete'
# shift-tab to 
bind '"\e[Z":menu-complete'
bind 'set completion-ignore-case on'

# auto enter directory with cd
shopt -s autocd

# initial a space of the command I execute to hide this command from log
export EXO_MOUNT_IOCHARSET="utf8"
export PROMPT_COMMAND='history -a'

if which gsed 1>/dev/null 2>&1 ; then
    _gsed=gsed
else
    _gsed=sed
fi

function _version { echo "$@" | awk -F. '{ printf("%d%03d%03d%03d\n", $1,$2,$3,$4); }'; }
function __git_tag_or_branch {
    git symbolic-ref -q --short HEAD || git describe --tags --exact-match
}

export HISTCONTROL=ignoreboth:erasedups
if [ $(_version $BASH_VERSION) -ge $(_version "4.3") ]; then
    export HISTSIZE=-1
    export HISTFILESIZE=-1
else
    export HISTSIZE=100000
    export HISTFILESIZE=100000
fi
# set HISTSIZE & HISTFILESIZE -1 will make the history unlimited
# but only support after bash-4.3
# this will make bash fail to start on Mac
# export HISTSIZE=-1
# export HISTFILESIZE=-1

# go up N-th level or directory name match regex
function cd_up() {
    case $1 in
        *[!0-9]*)
            # regex case
            # search argu1 in current path
            cd $(pwd |${_gsed} "s|\(.*/$1[^/]*/\).*|\1|" )
            ;;
        *)
            # cd ../../ (N dirs)
            cd $(printf "%0.0s../" $(seq 1 $1));
            ;;
    esac
}
alias 'u'='cd_up'

# build id database for all files under current folder to files/all.ids
function gen_id() {
    local folder=$1

    if [ -z $folder ] ; then
        folder=.
    fi

    out_folder="$folder/files"
    if [ ! -d $out_folder ]; then
        mkdir $out_folder
    fi

    local output=$2
    if [ -z $output ] && [ ! -d $folder/all ] ; then
        output=all.ids
    elif [ -z $output ] ; then
        # add date to avoid conflict
        output=all-$(date +%F).ids
    fi
    #if [ -e $folder/files/all.files ] ; then
    #    cat $folder/files/all.files |tr '\n' '\0'\
    #        > $folder/files/all0.files
    #    mkid -o $out_folder/$output \
    #        --file0-from=$folder/files/all0.files 2>/dev/null
    #else
        mkid -o $out_folder/$output $folder 2>/dev/null
    #fi

}

# build id database for each subdirectory
function gen_ids() {
    local folder=$1

    if [ -z $folder ] ; then
        folder=.
    fi

    out_folder="$folder/files"
    if [ ! -d $out_folder ]; then
        mkdir $out_folder
    fi

    local _filter_folders="
        -path $folder/out
        -o -path $folder/build
        -o -path $folder/cts
        -o -path $folder/developers
        -o -path $folder/development
        -o -path $folder/files
        -o -path $folder/kernel/out
        -o -path $folder/ndk
        -o -path $folder/pdk
        -o -path $folder/platform_testing
        -o -path $folder/prebuilt
        -o -path $folder/prebuilts
        -o -path $folder/sdk
        -o -path $folder/test
        -o -path $folder/toolchain
        -o -path $folder/tools
        -o -path '*/\.*'"

    for i in $(find $folder -mindepth 1 -maxdepth 1 \
        \( $_filter_folders \) -prune -o \
        \( ! -regex '.*/\..*' -a ! -regex '\./files/' \)\
        -a -type d -print\
        |${_gsed} 's=^\.\/==' |sort -u)
    do
        echo gen $out_folder/$i.ids...
        mkid -o $out_folder/$i.ids $folder/$i 2>/dev/null
    done
}

# build file list of source code
function gen_files() {
    local folder=$1
    if [ -z $folder ] ; then
        folder=.
    fi

    if [ ! -d $folder/files ] ; then
        mkdir $folder/files
    fi

    local output=$2
    if [ -z $output ] && [ ! -d $folder/all ] ; then
        output=all.files
    elif [ -z $output ] ; then
        # add date to avoid conflict
        output=all-$(date +%F).files
    fi

    local _filter_folders="
        -path $folder/out
        -o -path $folder/build
        -o -path $folder/cts
        -o -path $folder/developers
        -o -path $folder/development
        -o -path $folder/files
        -o -path $folder/kernel/out
        -o -path $folder/ndk
        -o -path $folder/pdk
        -o -path $folder/platform_testing
        -o -path $folder/prebuilt
        -o -path $folder/prebuilts
        -o -path $folder/sdk
        -o -path $folder/test
        -o -path $folder/toolchain
        -o -path $folder/tools
        -o -path '*/\.*'"

    echo gen $folder/files/$output...
    find -L $folder \
        \( $_filter_folders \) -prune -o \( \
        -name '*.[cCsShH]' \
        -o -name '*.java' \
        -o -name '*.cpp' \
        -o -name '*.asm' \
        -o -name '*.hal' \
        -o -name '*.hidl' \
        -o -name '*.aidl' \
        \) -a -type f -print 2>/dev/null |sort > $folder/files/$output

    # do not split file index for different folders
    # if files number less than 10000
    if [ $(wc -l < $folder/files/$output) -gt 100000 ]; then
        for i in $(find $folder -mindepth 1 -maxdepth 1 \
            \( $_filter_folders \) -prune -o ! -type d -o -print \
            |grep -vw 'files' |${_gsed} 's#^\.\/##g')
        do
            grep "^\.\/\<$i\>\/" $folder/files/$output \
                |${_gsed} -e 's#^\.\/##' > $folder/files/$i.files
            if [ ! -s $folder/files/$i.files ]; then
                # clear empty files
                rm -f $folder/files/$i.files
            else
                echo gen $folder/files/$i.files...
            fi
        done
    fi

    ${_gsed} -e 's#^\.\/##' -i.old $folder/files/$output
    rm -f $folder/files/${output}.old
}

# build file list of makefiles
function gen_mk() {
    local folder=$1

    if [ -z $folder ] ; then
        folder=.
    fi

    if [ ! -d $folder/files ] ; then
        mkdir $folder/files
    fi

    echo gen $folder/files/mk.files...
    find -L $folder \( \
        -path $folder/out \
        -o -path $folder/kernel/out \
        -o -path '*/\.*' \
        \) -prune \
        -o \( \
        -name "[Mm]akefile*" \
        -o -name "*.mk" \
        -o -name "*.mak" \
        -o -name "[kK]config*" \
        -o -name "[Kk]build*" \
        -o -name "*.pl" \
        -o -name "*.sh" \
        -o -name "*.py" \
        -o -name "*.ld" \
        -o -name "*.lds" \
        -o -name "CMakeLists*" \
        -o -name "SConstruct" \
        -o -name "SConscript" \
        -o -name "*.bat" \
        -o -name '*.bp' \
        \) -a -type f -print 2>/dev/null \
        |${_gsed} -e 's#^\.\/##' \
        |sort > $folder/files/mk.files
}

# list files whose content match pattern
function idf() {
    local pattern=$1
    local options="-ils"
    local folder="$PWD"

    for i in ${@:2}
    do
        case "$i" in
            (-f=*)  folder=${i/-f=/};;
            (-p=*)  pattern=${i/-p=/};;
            (-o=*)  options=${i/-o=/};;
        esac
    done

    if [ -z "$pattern" -o ! -d "$folder/files" ] ; then
        echo -e "usage: ${FUNCNAME} pattern [folder] [options]\n"
        lid --help
    elif ls $folder/files/*.ids &> /dev/null; then
        for i in $folder/files/*.ids
        do
            lid $options -R filenames -f $i "$pattern"
        done 2>/dev/null \
                |cut -d" " -f2- \
                |${_gsed} -e 's#^\ \ *##' -e 's#\ \ *#\n#g' \
                |sort -u
    else
        echo -ne "${FUNCNAME}: no any index exists, " \
            "gen_ids first please\n"
    fi

}

# list files and the grep results whose content match pattern
function idg() {
: << 'version1'
    local pattern=$1
    local options="-ils"
    local folder="$PWD"

    for i in ${@:2}
    do
        case "$i" in
            (-f=*)  folder=${i/-f=/};;
            (-p=*)  pattern=${i/-p=/};;
            (-o=*)  options=${i/-o=/};;
        esac
    done

    if [ -z "$pattern" -o ! -d "$folder/files" ] ; then
        echo -e "usage: ${FUNCNAME} pattern [folder] [options]\n"
        lid --help
    elif ls $folder/files/*.ids &> /dev/null; then
        for i in $folder/files/*.ids
        do
            #if tty -s <&1; then
                lid $options -R grep -f $i "$pattern" 2>/dev/null \
                    |sort -u |grep "$pattern" --color
            #else
            #    lid $options -R grep -f $i "$pattern" 2>/dev/null \
            #        |sort |uniq |grep "$pattern"
            #fi
        done
    # elif ls $folder/files/*.files &> /dev/null; then
    #     ( if [ -e $folder/files/src.files ] ; then
    #         cat $folder/files/src.files
    #     else
    #         cat $folder/files/*.files |sort -u
    #     fi ) |xargs ag "$pattern" 2>/dev/null
    else
        echo -ne "${FUNCNAME}: no index exists" \
            "gen_ids first please\n"
    fi
version1

    # version 2: use idf directly to make the results colorful
    local _searcher="ag"
    local output=$(idf $@)

    case "$1" in
        -s=ag)
            # ag is already the default searcher
            shift
            ;;
        -s=grep)
            _searcher="grep --color -i"
            shift;
            ;;
    esac

    # rollback to grep if ag not available
    if [ "$_searcher" = "ag" ] && [! which ag 1>/dev/null 2>&1 ]; then
        _searcher="grep --color -i"
    fi

    if [ -z "${output}" ]; then
        echo "id '$1' not found"
    else
        ${_searcher} -H $1 ${output}
    fi

}

function foreach_in() {
    local local_path=$1
    #echo "$local_path"
    for i in ${@:2}
    do
        #echo "i=$i"
        #if [ -e "$i/$local_path" -o -d "$i/$local_path" ] ; then
            echo "$i/$local_path" |sed -e 's#\/\/*#\/#g'
        #fi
    done
}

function gen_cs() {
    local file=$1
    local out

    if [ -z $file ] ; then
        echo argument needed
        return
    elif [ ! -f ./files/$file.files ] ; then
        echo "./files/$file.files not exist"
        return
    fi

    if [ -z $2 ] ; then
        out=$file
    else
        out=${file}-${2}
    fi
    echo "gen files/${out}.out..."
    cscope -bkq -i files/$file.files -f files/${out}.out 2>/dev/null
}

# gen cscope for all files under current directory with version string appended
function gen_csav() {
    gen_cs all $(__git_tag_or_branch)
}

function gen_cs_for_each_subdir() {
    local folder=$1
    if [ -z $folder ] ; then
        folder=.
    fi

    if [ ! -d $folder/files ] ; then
        echo "$folder/files not exist"
        return
    fi

    for i in $(fd -d 1 .files $folder/files/ -E 'all*.files' )
    do
        local out_name=$(echo $i |${_gsed} 's$\.files$\.out$')
        echo gen $out_name...
        cscope -bkq -i $i -f $out_name 2>/dev/null
    done
}

# link gtags db generated by leaderf back to pwd
# generate by gen_tags.vim
function linkGtags() {
    local cache="$HOME/.cache/tags_dir"
    local dbname=$(echo $PWD | sed 's#[\ \.\/\\\:]##g')
    if [ ! -e $cache/$dbname ]; then
        echo "$cache/$dbname not exist"
        return
    fi
    rm -f GPATH GRTAGS GTAGS
    for i in $cache/$dbname/{GPATH,GRTAGS,GTAGS} ; do
        [ -e $i ] && ln -s $i $(basename $i)
    done
}

# link gtags db generated by leaderf back to pwd
# generate by Leaderf
function linkLFGtags() {
    local LfCache
    if [ ! -z $XDG_DATA_HOME ]; then
        LfCache=$(find $XDG_DATA_HOME/vim -type d -name .LfCache)
    else
        LfCache=$(find "$HOME/.local/vim" -type d -name .LfCache)
    fi
    [ ! -z $LfCache ] || return
    rm -f GPATH GRTAGS GTAGS
    for i in $LfCache/gtags/${PWD//\/\%}/{GPATH,GRTAGS,GTAGS} ; do
        [ -e $i ] && ln -s $i $(basename $i)
    done
}

function genGtags() {
    local LfCache
    # VIMDATA set in vimrc
    if [ ! -z $XDG_DATA_HOME ]; then
        LfCache=$(find $XDG_DATA_HOME/vim -type d -name .LfCache)
    else
        LfCache=$(find "$HOME/.local/vim" -type d -name .LfCache)
    fi
    [ ! -z $LfCache ] || return
    if [ -e "$LfCache/gtags/${PWD//\//%}/" ] && [ -e "$LfCache/gtags/${PWD//\//%}/GTAGS" ] ; then
        gtags -i "$LfCache/gtags/${PWD//\//%}/"
    else
        mkdir -p "$LfCache/gtags/${PWD//\//%}/"
        gtags "$LfCache/gtags/${PWD//\//%}/"
    fi
    for i in $LfCache/gtags/${PWD//\//%}/G* ; do
        if [ -e $i ]; then
            ln -sf $i $(basename $i)
        fi
    done
}

if [[ ${EUID} == 0 ]] ; then
	PS1='\[\033[01;31m\]\h\[\033[01;34m\] \W \$\[\033[00m\] '
else
	PS1='\[\033[01;32m\]\u@\h\[\033[01;34m\] \w \$\[\033[00m\] '
fi

# import local setting
if [ -f $HOME/.local/bashrc ]; then
    source $HOME/.local/bashrc

    ##### example for .bashrc.local #####
    ## cofig HISTFILE
    ## extend PATH ##
    ## nvim ##
    # export XDG_CONFIG_HOME=<DATA_PATH>/.config
    # export XDG_DATA_HOME=<DATA_PATH>/.local/share

elif [ -f $HOME/.local2/bashrc ]; then
    # WA when $HOME/.local has been occupied
    source $HOME/.local2/bashrc
fi

_nvim=$(which nvim 2>/dev/null)
# nvim patch may depend on PATH & bashrc.local
if [ ! -z $_nvim ] && [ -x $_nvim ] ; then
    alias vi='nvim'
    export VISUAL=nvim
else
    alias vi='vim'
    export VISUAL=vim
fi
export EDITOR="$VISUAL"

__zoxide=$(which zoxide 2>/dev/null)

# zoxide
if [ ! -z $__zoxide ]; then
    eval "$(zoxide init bash)"
    # zi to cd with fzf, as zz
    # zq to query but don't cd, as zl
    alias zq='zoxide query'
fi

if [ -z ${dotfiles} ] ; then
    dotfiles=${HOME}/dotfiles
fi

# import fzf bash completion & key-bindings
if [ ! -z $fzf_path ] ; then
    if [ -f $fzf_path/.fzf.bash ] ; then
        source $fzf_path/.fzf.bash
    fi
    unset fzf_path
elif [ -f "${XDG_CONFIG_HOME:-$HOME/.config}"/fzf/fzf.bash ]; then
    source "${XDG_CONFIG_HOME:-$HOME/.config}"/fzf/fzf.bash
elif [ -f ~/.fzf.bash ] ; then
    source ~/.fzf.bash
fi

__fzf=$(which fzf 2>/dev/null)

# for fzf
if [ ! -z $__fzf ] ; then
    __fd=$(which fd 2>/dev/null)
    __rg=$(which rg 2>/dev/null)

    # rg is even faster than fd
    if [ ! -z $__rg ] ; then
        export FZF_DEFAULT_COMMAND='rg --no-messages --files --no-ignore 2>/dev/null'
    elif [ ! -z $__fd ] ; then
        export FZF_DEFAULT_COMMAND='fd -t f -I 2>/dev/null'
    else
        export FZF_DEFAULT_COMMAND='
         (git ls-tree -r --name-only HEAD ||
             find . -path "*/\.*" -prune -o -type f -print -o -type l -print |
             sed s/^..//) 2> /dev/null'
    fi
    export FZF_DEFAULT_OPTS='--height 40% --border --bind "ctrl-t:toggle-all,ctrl-d:deselect-all"'

    # if [ -f ${dotfiles}/bash/fzf-extras/fzf-extras.sh ] ; then
    #     source ${dotfiles}/bash/fzf-extras/fzf-extras.sh
    # fi

    if [ -f ${dotfiles}/bash/fzf.sh ] ; then
        source ${dotfiles}/bash/fzf.sh
    fi
    # alias za='zd -a'
    alias zr='zd -r'
    alias zf='zd -f'
fi

# To apply the command to CTRL-T as well
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"

unset __fd __fzf __rg __zoxide

if [ -f ${dotfiles}/ignore ] ; then
    alias rg="rg --ignore-file ${dotfiles}/ignore --smart-case"
    alias ag="ag --path-to-ignore ${dotfiles}/ignore"
else
    alias rg="rg --smart-case"
fi

function targz() {
    local dir=${1%/}
    tar --use-compress-program="pigz --recursive" -cf ${dir}.tar.gz ${dir} && rm -rf ${dir}
}

# gcd: navigate to project root
function gcd() {
    local dir=$(pwd)
    local gitroot=$(git rev-parse --show-toplevel 2>/dev/null)

    if [ ! -z $gitroot ]; then
        cd $gitroot
        return
    fi
    while [ "$dir" != "/" ];
    do
        if [ -e $dir/.git -o -e $dir/.repo -o -e $dir/GTAGS -o -e $dir/.files.gz ]; then
            cd $dir
            return
        fi
        dir=$(dirname $dir)
    done
}

function vg() {
    if [ -e GTAGS ]; then
        "${EDITOR:-vim}" $(global $1)
    fi
}
