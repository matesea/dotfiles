if ls --color -d . >/dev/null 2>&1; then
    alias ls='ls --color'
else
    # for BSD ls
    export CLICOLOR=1
fi
alias ll='ls -l'
alias la='ls -la'
alias lh='ls -lh'
alias sl='ls'
alias LS='ls'
alias SL='ls'

alias tmux='tmux -2'
alias recal='history |grep'
alias grep='grep --color -i'
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
bind '"\e[Z":menu-complete' #

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

export HISTCONTROL=ignorespace:erasedups
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
        -o -name "*.asm" \
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

# build file list of devicetree configurations
function gen_dt() {
    local folder=$1
    if [ -z $folder ] ; then
        folder=.
    fi

    if [ ! -d $folder/files ] ; then
        mkdir $folder/files
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

    # find devicetree files
    find -L $folder \
        \( $_filter_folders \) -prune -o \( \
        -name '*.dts' \
        -o -name '*.dtsi' \
        \) -a -type f -print 2>/dev/null \
        |${_gsed} -e 's#^\.\/##' \
        |sort > $folder/files/dt.files
}

# build file list of selinux configuration
function gen_te() {
    local folder=$1
    if [ -z $folder ] ; then
        folder=.
    fi

    if [ ! -d $folder/files ] ; then
        mkdir $folder/files
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

    # find selinux configuration files
    find -L $folder \
        \( $_filter_folders \) -prune -o \( \
        -name '*.te' \
        -o -name 'file_contexts' \
        \) -a -type f -print 2>/dev/null \
        |${_gsed} -e 's#^\.\/##' \
        |sort > $folder/files/te.files
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
        \) -a -type f -print 2>/dev/null \
        |${_gsed} -e 's#^\.\/##' \
        |sort > $folder/files/mk.files
}

function gen_doc() {
    mkdir -p files
    find Documentation -type f \
        |${_gsed} -e 's#^\.\/##' \
        |sort -u > files/doc.files
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
idf $@ |xargs grep --color $1

}

# grep files
# usage: __gf <leading strings of index files> [-s=<searcher>] <pattern>
function __gf() {
    local folder="$PWD"
    local _searcher="ag"
    local _index_begin="$1"

    if [ -z ${_index_begin} ]; then
        echo "need to specify index file(s)"
        return 1;
    fi
    shift

    if ! ls $folder/files/${_index_begin}*.files 1>/dev/null 2>&1; then
        echo -ne "${FUNCNAME}: no index exists," \
            "gen index first\n"
        return 1;
    fi

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

    cat $folder/files/${_index_lead}*.files |tr '\n' '\0' \
        |xargs -0 ${_searcher} "${@:1}"
}

function gf() {
    __gf all $@
}

# grep make files
function gmk() {
    __gf mk $@
}

function gdoc() {
    __gf doc $@
}

# find files
function __ff() {
    local folder="."
    local args=""
    local _index_begin=$1

    shift

    if [ -z $_index_begin ]; then
        echo "need to specify index file(s)"
        return 1;
    fi

    for i in ${@:1}
    do
        case "$i" in
            -p=*)
                folder=${i/-f=/}
                ;;
            -*)
                args="$args $i"
                ;;
            *)
                args="$args -e $i"
                ;;
        esac
    done

: << idutils_files
    # TODO: generate cscope & ids in parallel
    if ls $folder/files/*.ids 1>/dev/null 2>&1; then
        for pattern in ${@:1}
        do
            for id in $folder/files/*.ids
            do
                fnid -f $id "*$pattern*"
            done
        done 2>/dev/null |sort -u |grep --color $args
idutils_files

    if  ls $folder/files/${_index_begin}*.files 1>/dev/null 2>&1; then
        sort -u $folder/files/${_index_begin}*.files \
            | grep --color $args 2>/dev/null
    else
        echo "${FUNCNAME}: no index found in $folder/files..."
    fi
}

function ff() {
    __ff all $@
}

function fdoc() {
    __ff doc $@
}

# find makefiles
function fmk() {
    __ff mk $@
}
alias fkc='fmk kconfig'
alias famk='fmk Android\.mk$'
alias fmak='fmk Makefile$'

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
    if [ -z $file ] ; then
        echo argument needed
        return
    elif [ ! -f ./files/$file.files ] ; then
        echo "./files/$file.files not exist"
        return
    fi
    echo "gen files/$file.out..."
    cscope -bkq -i files/$file.files -f files/$file.out 2>/dev/null
}

function gen_all_cs() {
    local folder=$1
    if [ -z $folder ] ; then
        folder=.
    fi

    if [ ! -d $folder/files ] ; then
        echo "$folder/files not exist"
        return
    fi

    for i in $(ls $folder/files/*.files |grep -v '\<all*.files\>' )
    do
        local out_name=$(echo $i |${_gsed} 's$\.files$\.out$')
        echo gen $out_name...
        cscope -bkq -i $i -f $out_name 2>/dev/null
    done
}

export PATH="/opt/local/bin/:$HOME/bin:$PATH"
if [[ ${EUID} == 0 ]] ; then
	PS1='\[\033[01;31m\]\h\[\033[01;34m\] \W \$\[\033[00m\] '
else
	PS1='\[\033[01;32m\]\u@\h\[\033[01;34m\] \w \$\[\033[00m\] '
fi

# import local setting
if [ -f $HOME/.bashrc.local ]; then
    source $HOME/.bashrc.local

    ##### example for .bashrc.local #####
    ## cofig HISTFILE
    ## extend PATH ##
    ## nvim ##
    # export XDG_CONFIG_HOME=<DATA_PATH>/.config
    # export XDG_DATA_HOME=<DATA_PATH>/.local/share

    ## fasd ##
    # export _FASD_DATA=<DATA_PATH>/.fasd
    # eval "$(fasd --init auto)"

    ## z ##
    # export _Z_DATA=<DATA_PATH>/.z
    # . ~/bin/z.sh
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
alias va="$EDITOR files/all.files"

__fasd=$(which fasd 2>/dev/null)
__z=$(which z.sh 2>/dev/null)
if [ ! -z $__fasd ] && [ -x $__fasd ] ; then
    eval "$(fasd --init auto)"
    alias v="f -e $EDITOR"
    alias l='fasd -l'
elif [ ! -z $__z ] && [ -x $__z ] ; then
    . $__z
fi
