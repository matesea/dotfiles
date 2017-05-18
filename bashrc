alias ll='ls -l'
alias la='ls -la'
alias lh='ls -lh'
alias sl='ls'
alias LS='ls'
alias SL='ls'
alias tmux='tmux -2'
alias recal='history |grep'
alias grep='grep --color=auto'
# alias v='f -e vim'
unset command_not_found_handle

shopt -s cdspell
shopt -s extglob
shopt -s histappend
set -o vi
export HISTTIMEFORMAT="%F %T "
#export XENVIRONMENT="/home/matesea/.Xdefaults.bak"

# initial a space of the command I execute to hide this command from log
export HISTCONTROL=ignorespace:erasedups
export HISTSIZE=30000
export EXO_MOUNT_IOCHARSET="utf8"

if [ -x $(which nvim) ] ; then
    alias vi='nvim'
    export VISUAL=nvim
else
    alias vi='vim'
    export VISUAL=vim
fi
export EDITOR="$VISUAL"

# go up N-th level or directory name match regex
function cd_up() {
    case $1 in
        *[!0-9]*)
            # regex case
            # search argu1 in current path
            cd $(pwd | sed "s|\(.*/$1[^/]*/\).*|\1|" )
            ;;
        *)
            # cd ../../ (N dirs)
            cd $(printf "%0.0s../" $(seq 1 $1));
            ;;
    esac
}
alias 'u'='cd_up'

function gen_ids(){
    local folder=$1

    if [ -z $folder ] ; then
        folder=.
    fi

    out_folder="$folder/files"
    if [ ! -d $out_folder ]; then
        mkdir $out_folder
    fi

    for i in $(find $folder -mindepth 1 -maxdepth 1 \
        \( ! -regex '.*/\..*' -a ! -regex '\./files/' \) -type d\
        |sed 's=^\.\/==')
    do
        echo gen $out_folder/$i.ids...
        mkid -o $out_folder/$i.ids $folder/$i 2>/dev/null
    done
}

function gen_files(){
    local folder=$1
    if [ -z $folder ] ; then
        folder=.
    fi

    if [ ! -d $folder/files ] ; then
        mkdir $folder/files
    fi

    local output=$2
    if [ -z $output ] && [ ! -d $folder/src ] ; then
        output=src.files
    elif [ -z $output ] ; then
        # add date to avoid conflict
        output=src-$(date +%F).files
    fi

    echo gen $folder/files/$output...
    find -L $folder \
        \( \
        -path $folder/out \
        -o -path $folder/build \
        -o -path $folder/cts \
        -o -path $folder/prebuilts \
        -o -path $folder/ndk \
        -o -path $folder/development \
        -o -path $folder/sdk \
        -o -path $folder/prebuilt \
        -o -path $folder/kernel/out \
        -o -path '*/\.*' \
        \) -prune -o \( \
        -name '*.[cCsShH]' \
        -o -name '*.java' \
        -o -name '*.cpp' \
        -o -name "*.asm" \
        \) -a -type f -print | sort > $folder/files/$output
    
    for i in $(find $folder -mindepth 1 -maxdepth 1 \
        \( \
        -path $folder/out \
        -o -path $folder/build \
        -o -path $folder/cts \
        -o -path $folder/prebuilts \
        -o -path $folder/ndk \
        -o -path $folder/development \
        -o -path $folder/sdk \
        -o -path $folder/prebuilt \
        -o -path $folder/files \
        -o -path '*/\.*' \
        \) -prune -o ! -type d -o -print \
        |grep -vw 'files' |sed 's#^\.\/##g')
    do
        grep "^\.\/\<$i\>\/" $folder/files/$output \
            |sed -e 's#^\.\/##' > $folder/files/$i.files
        if [ ! -s $folder/files/$i.files ]; then
            # clear empty files
            rm -f $folder/files/$i.files
        else
            echo gen $folder/files/$i.files...
        fi
    done
    sed -e 's#^\.\/##' -i.old $folder/files/$output
    rm -f $folder/files/${output}.old
}

function gen_mk(){
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
        \) -a -type f -print | \
        sed -e 's#^\.\/##' |sort > $folder/files/mk.files
}

function gen_css(){
    local folder=$1
    if [ -z $folder ] ; then
        folder=.
    fi

    if [ ! -d $folder/files ] ; then
        echo "$folder/files not exit"
        return
    fi

    for i in $(ls $folder/files/*.files | grep -v '\<src.files\>' )
    do
        local out_name=$(echo $i | sed 's$\.files$\.out$')
        echo gen $out_name...
        cscope -bkq -i $i -f $out_name 2>/dev/null
    done
}

# function f(){
#     local pattern=$1
#     local force_grep=0
# 
#     for i in ${@:2}
#     do
#         case "$i" in
#             (-f=*) folder=${i/-f=/} ;;
#             (-g)   force_grep=1 ;;
#             (-p=*) pattern=${i/-p=/} ;;
#         esac
#     done
# 
#     if [ -z "$folder" ]; then 
#         folder="."
#     fi
# 
#     if [ -z "$pattern" -o ! -d $folder/files ] ; then 
#         echo -e "usage: ${FUNCNAME} <pattern> <folder>\n\tfind matching pattern under the specified folder"
#     else
#         local files=$(for i in $folder/files/*.ids
#                 do
#                     fnid "$pattern" -f $i -S newline
#                 done 2>/dev/null)
#         set -- $files
#         ( echo $files |sed -e 's=\ =\n=g'; 
#         if [ ${#@} == 0 -o "$force_grep" == "1" ]; then
#             ( grep -h "$pattern" $folder/files/*.files ||\
#                 find $folder -name "$pattern" ) | sed -e 's=^\.\/==' 2>/dev/null
#         fi) | sort | uniq |grep "$pattern"
#     fi
# }

function idf(){
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
        echo -e "usage: ${FUNCNAME} pattern [ folder] [options]\n"
        lid --help
    elif ls $folder/files/*.ids &> /dev/null; then
        for i in $folder/files/*.ids
        do
            lid $options -R filenames -f $i "$pattern" 2>/dev/null \
                | cut -d" " -f2- \
                | sort |uniq |tr '[:blank:]' '\n'
        done
    elif ls $folder/files/*.files &> /dev/null; then
        ( if [ -e $folder/files/src.files ] ; then
            cat $folder/files/src.files
        else
            cat $folder/files/*.files | sort | uniq
        fi ) | xargs grep -l "$pattern" 2>/dev/null
    else
        echo -e "${FUNCNAME}: no any index exists\n"
            "\tgen_ids or gen_files first please"
    fi

}

function idg(){
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
        echo -e "usage: ${FUNCNAME} pattern [ folder] [options]\n"
        lid --help
    elif ls $folder/files/*.ids &> /dev/null; then
        for i in $folder/files/*.ids
        do
            if tty -s <&1; then
                lid $options -R grep -f $i "$pattern" 2>/dev/null \
                    | sort |uniq |grep "$pattern"
            else
                lid $options -R grep -f $i "$pattern" 2>/dev/null \
                    | sort |uniq |grep "$pattern"
            fi
        done
    elif ls $folder/files/*.files &> /dev/null; then
        ( if [ -e $folder/files/src.files ] ; then
            cat $folder/files/src.files
        else
            cat $folder/files/*.files | sort | uniq
        fi ) | xargs ag "$pattern" 2>/dev/null
    else
        echo -e "${FUNCNAME}: no any index exists\n"
            "\tgen_ids or gen_files first please"
    fi

}

# find files
# ag version
function f(){
    local folder="."
    local args=""

    for i in ${@:1}
    do
        case "$i" in
            -p=*)
                folder=${i/-f=/}
                ;;
            *)
                args="$args $i"
                ;;
        esac
    done
    #echo "folder=$folder \$args=$args"

    if [ -e $folder/files ] ; then
        for i in $args
        do
            if [ $folder == "." ] ; then
                ag -h $i $folder/files/src.files
            else
                ag -h $i $folder/files/src.files \
                    | sed -e "s!^\.\/!$folder\/!"
            fi
        done 2>/dev/null
    else
        echo "$folder/files/src.files not exist"
    fi
}

function foreach_in(){
    local local_path=$1
    #echo "$local_path"
    for i in ${@:2}
    do
        #echo "i=$i"
        #if [ -e "$i/$local_path" -o -d "$i/$local_path" ] ; then 
            echo "$i/$local_path"
        #fi
    done
}

function gen_css(){
    local folder=$1
    if [ -z $folder ] ; then
        folder=.
    fi

    if [ ! -d $folder/files ] ; then
        echo $folder/files not exist
        return
    fi

    for i in $(ls $folder/files/*.files|grep -v '\<src\.files\>')
    do
        local out_name=$(echo $i|sed 's$\.files$\.out$')
        echo gen $out_name...
        cscope -bkq -i $i -f $out_name 2>/dev/null
    done
}

function gen_cs(){
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

export PATH="/opt/local/bin/:$HOME/bin:$PATH"
if [[ ${EUID} == 0 ]] ; then
	PS1='\[\033[01;31m\]\h\[\033[01;34m\] \W \$\[\033[00m\] '
else
	PS1='\[\033[01;32m\]\u@\h\[\033[01;34m\] \w \$\[\033[00m\] '
fi

# import local setting
if [ -f $HOME/.bashrc.local ]; then
    source $HOME/.bashrc.local
fi
